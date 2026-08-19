import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/config/flavor.dart';
import 'package:parking_link/core/di/fcm_providers.dart';
import 'package:parking_link/core/di/watchlist_providers.dart';
import 'package:parking_link/core/services/fcm_notification_service.dart';
import 'package:parking_link/features/user/presentation/handlers/watchlist_event_handlers.dart';

/// Initializes FCM + local notifications for User flavor watchlist.
class WatchlistNotificationBootstrap extends ConsumerStatefulWidget {
  final Widget child;

  const WatchlistNotificationBootstrap({super.key, required this.child});

  @override
  ConsumerState<WatchlistNotificationBootstrap> createState() =>
      _WatchlistNotificationBootstrapState();
}

class _WatchlistNotificationBootstrapState
    extends ConsumerState<WatchlistNotificationBootstrap> {
  @override
  void initState() {
    super.initState();
    if (FlavorConfig.isUser && !kIsWeb) {
      _initNotifications();
    }
  }

  Future<void> _initNotifications() async {
    ref.read(watchlistEventHandlersRegisteredProvider);

    final fcm = ref.read(fcmNotificationServiceProvider);

    await ref.read(watchlistLocalNotificationServiceProvider).initialize(
          onNotificationTap: (lotId) {
            handleWatchlistNotificationTapWithReader(
              ref.read,
              WatchlistNotificationPayload(
                lotId: lotId,
                lotName: 'Bãi xe',
                type: FcmNotificationService.lotOpenedType,
              ),
            );
          },
        );

    try {
      await fcm.requestPermission();
      await fcm.getToken();

      await fcm.configureWatchlistHandlers(
        onForegroundMessage: (message) {
          final payload = fcm.parseMessage(message);
          if (payload == null) return;
          handleWatchlistForegroundMessageWithReader(ref.read, payload);
        },
        onNotificationOpened: (payload) {
          handleWatchlistNotificationTapWithReader(ref.read, payload);
        },
      );
    } catch (e, st) {
      debugPrint('WatchlistNotificationBootstrap FCM init failed: $e\n$st');
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
