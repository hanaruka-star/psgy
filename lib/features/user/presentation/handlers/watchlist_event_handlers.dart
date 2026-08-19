import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/di/app_settings_providers.dart';
import 'package:psgy/core/di/watchlist_providers.dart';
import 'package:psgy/core/events/domain_event_bus.dart';
import 'package:psgy/core/events/watchlist_lot_opened_event.dart';
import 'package:psgy/core/services/fcm_notification_service.dart';
import 'package:psgy/features/user/presentation/providers/watchlist_notification_providers.dart';

/// Registers domain-event listeners for watchlist side effects.
void registerWatchlistEventHandlers(Ref ref, DomainEventBus bus) {
  bus.subscribe<WatchlistLotOpenedEvent>((event) async {
    final enabled =
        ref.read(watchlistNotificationsEnabledProvider).valueOrNull ?? true;
    if (!enabled) return;

    await ref.read(watchlistLocalNotificationServiceProvider).showLotOpened(
          lotId: event.lotId,
          lotName: event.lotName,
        );
    await ref.read(watchlistLocalDataSourceProvider).setUnread(
          event.lotId,
          unread: true,
        );
  });
}

/// Called from FCM bootstrap (WidgetRef) when user taps a push notification.
void handleWatchlistNotificationTapWithReader(
  T Function<T>(ProviderListenable<T> provider) read,
  WatchlistNotificationPayload payload,
) {
  read(pendingWatchlistLotNavigationProvider.notifier).state = payload;
  read(watchlistLocalDataSourceProvider).setUnread(
        payload.lotId,
        unread: true,
      );
}

/// Called when a push arrives while the app is in foreground.
void handleWatchlistForegroundMessageWithReader(
  T Function<T>(ProviderListenable<T> provider) read,
  WatchlistNotificationPayload payload,
) {
  final enabled =
      read(watchlistNotificationsEnabledProvider).valueOrNull ?? true;
  if (!enabled) return;

  read(notifyWatchlistLotOpenedUseCaseProvider).call(
        lotId: payload.lotId,
        lotName: payload.lotName,
      );
}
