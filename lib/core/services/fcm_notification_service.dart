import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Parsed watchlist lot-open push payload.
class WatchlistNotificationPayload {
  final String lotId;
  final String lotName;
  final String type;

  const WatchlistNotificationPayload({
    required this.lotId,
    required this.lotName,
    required this.type,
  });

  bool get isLotOpened => type == 'lot_opened';
}

typedef WatchlistNotificationTapHandler = void Function(
  WatchlistNotificationPayload payload,
);

/// Central FCM wrapper: permission, token, topics, message routing.
class FcmNotificationService {
  static const defaultAndroidChannelId = 'psgy_default';
  static const watchlistAndroidChannelId = defaultAndroidChannelId;
  static const lotOpenedType = 'lot_opened';
  // DEBT-009: FCM works on production/TestFlight; dev builds may delay APNs token.

  final FirebaseMessaging Function() _messagingFactory;
  StreamSubscription<String>? _tokenRefreshSub;
  final List<StreamSubscription<dynamic>> _messageSubs = [];

  FcmNotificationService({FirebaseMessaging Function()? messagingFactory})
      : _messagingFactory =
            messagingFactory ?? (() => FirebaseMessaging.instance);

  FirebaseMessaging get _messaging => _messagingFactory();
  bool get _isIosRuntime =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  Future<bool> requestPermission() async {
    if (kIsWeb) return false;

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  static const _tokenMaxAttempts = 5;
  static const _tokenRetryDelay = Duration(seconds: 3);

  Future<String?> _waitForApnsToken() async {
    for (var attempt = 1; attempt <= _tokenMaxAttempts; attempt++) {
      final apnsToken = await _messaging.getAPNSToken();
      if (apnsToken != null) {
        return apnsToken;
      }
      if (attempt < _tokenMaxAttempts) {
        await Future.delayed(_tokenRetryDelay);
      }
    }
    debugPrint(
      '⚠️ FCM APNs token unavailable after $_tokenMaxAttempts attempts '
      '(common on dev builds; production/TestFlight usually succeeds).',
    );
    return null;
  }

  Future<String?> getToken() async {
    if (kIsWeb) return null;

    if (_isIosRuntime) {
      final apnsToken = await _waitForApnsToken();
      if (apnsToken == null) {
        return null;
      }
      // Give iOS a moment before fetching FCM token.
      await Future.delayed(const Duration(seconds: 2));
    }

    for (var attempt = 1; attempt <= _tokenMaxAttempts; attempt++) {
      try {
        final token = await _messaging.getToken();
        if (token != null && token.trim().isNotEmpty) {
          return token;
        }

        if (attempt < _tokenMaxAttempts) {
          await Future.delayed(_tokenRetryDelay);
          continue;
        }
        debugPrint(
          '⚠️ FCM token is empty after $_tokenMaxAttempts attempts.',
        );
        return null;
      } catch (e) {
        if (attempt < _tokenMaxAttempts) {
          await Future.delayed(_tokenRetryDelay);
          continue;
        }
        debugPrint(
          '⚠️ FCM token fetch failed after $_tokenMaxAttempts attempts: $e',
        );
        return null;
      }
    }
    return null;
  }

  void listenToTokenRefresh(void Function(String token) onRefresh) {
    _tokenRefreshSub?.cancel();
    _tokenRefreshSub = _messaging.onTokenRefresh.listen(onRefresh);
  }

  Future<void> subscribeToTopic(String topic) async {
    if (kIsWeb || topic.trim().isEmpty) return;
    try {
      await _messaging.subscribeToTopic(topic);
    } catch (e, st) {
      debugPrint('FCM subscribeToTopic($topic) failed: $e\n$st');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    if (kIsWeb || topic.trim().isEmpty) return;
    try {
      await _messaging.unsubscribeFromTopic(topic);
    } catch (e, st) {
      debugPrint('FCM unsubscribeFromTopic($topic) failed: $e\n$st');
    }
  }

  WatchlistNotificationPayload? parseMessage(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] ?? lotOpenedType;
    if (type != lotOpenedType) return null;

    final lotId = data['lotId'];
    if (lotId == null || lotId.isEmpty) return null;

    final lotName = data['lotName'] ??
        message.notification?.title ??
        'Bãi xe';

    return WatchlistNotificationPayload(
      lotId: lotId,
      lotName: lotName,
      type: type,
    );
  }

  /// Wire foreground, background-open, and cold-start notification taps.
  Future<void> configureWatchlistHandlers({
    required void Function(RemoteMessage message) onForegroundMessage,
    required WatchlistNotificationTapHandler onNotificationOpened,
  }) async {
    for (final sub in _messageSubs) {
      await sub.cancel();
    }
    _messageSubs.clear();

    _messageSubs.add(
      FirebaseMessaging.onMessage.listen(onForegroundMessage),
    );
    _messageSubs.add(
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        final payload = parseMessage(message);
        if (payload != null) onNotificationOpened(payload);
      }),
    );

    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      final payload = parseMessage(initial);
      if (payload != null) onNotificationOpened(payload);
    }
  }

  Future<void> dispose() async {
    await _tokenRefreshSub?.cancel();
    for (final sub in _messageSubs) {
      await sub.cancel();
    }
    _messageSubs.clear();
  }
}
