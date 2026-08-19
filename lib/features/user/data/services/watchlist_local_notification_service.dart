import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:psgy/core/services/fcm_notification_service.dart';
import 'package:psgy/features/user/domain/ports/watchlist_cloud_function_port.dart';

typedef LocalNotificationTapHandler = void Function(String lotId);

/// Local notifications for watchlist events (foreground / FCM fallback).
class WatchlistLocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  final WatchlistCloudFunctionPort _cloudContract;
  bool _initialized = false;
  LocalNotificationTapHandler? _onTap;

  WatchlistLocalNotificationService({
    FlutterLocalNotificationsPlugin? plugin,
    WatchlistCloudFunctionPort? cloudContract,
  })  : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
        _cloudContract = cloudContract ?? WatchlistCloudFunctionContract();

  Future<void> initialize({LocalNotificationTapHandler? onNotificationTap}) async {
    if (_initialized || kIsWeb) return;
    _onTap = onNotificationTap;

    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings();
      await _plugin.initialize(
        const InitializationSettings(android: android, iOS: ios),
        onDidReceiveNotificationResponse: (response) {
          final lotId = response.payload;
          if (lotId != null && lotId.isNotEmpty) {
            _onTap?.call(lotId);
          }
        },
      );
      await _ensureAndroidChannel();
      _initialized = true;
    } catch (e, st) {
      debugPrint('WatchlistLocalNotificationService init skipped: $e\n$st');
    }
  }

  Future<void> _ensureAndroidChannel() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        FcmNotificationService.watchlistAndroidChannelId,
        'Theo dõi bãi xe',
        description: 'Thông báo khi bãi khảo sát mở cửa',
        importance: Importance.high,
      ),
    );
  }

  Future<void> showLotOpened({
    required String lotId,
    required String lotName,
  }) async {
    if (!_initialized) return;

    final payload = _cloudContract.openingNotificationPayload(
      lotId: lotId,
      lotName: lotName,
    );

    const androidDetails = AndroidNotificationDetails(
      FcmNotificationService.watchlistAndroidChannelId,
      'Theo dõi bãi xe',
      channelDescription: 'Thông báo khi bãi khảo sát mở cửa',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(''),
    );

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        androidDetails.channelId,
        androidDetails.channelName,
        channelDescription: androidDetails.channelDescription,
        importance: androidDetails.importance,
        priority: androidDetails.priority,
        icon: androidDetails.icon,
        styleInformation: BigTextStyleInformation(payload['body']!),
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _plugin.show(
      lotId.hashCode,
      payload['title'],
      payload['body'],
      details,
      payload: lotId,
    );
  }
}
