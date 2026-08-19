import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/di/app_settings_providers.dart';
import 'package:psgy/core/di/event_providers.dart';
import 'package:psgy/core/di/fcm_providers.dart';
import 'package:psgy/core/di/isar_providers.dart';
import 'package:psgy/features/user/data/datasources/watchlist_local_datasource.dart';
import 'package:psgy/features/user/data/datasources/watchlist_remote_datasource.dart';
import 'package:psgy/features/user/data/repositories/watchlist_repository_impl.dart';
import 'package:psgy/features/user/data/services/fcm_watchlist_notification_port.dart';
import 'package:psgy/features/user/data/services/watchlist_auth_service.dart';
import 'package:psgy/features/user/data/services/watchlist_local_notification_service.dart';
import 'package:psgy/features/user/domain/entities/watchlist_entity.dart';
import 'package:psgy/features/user/domain/repositories/user_watchlist_repository.dart';
import 'package:psgy/features/user/domain/usecases/watchlist/add_to_watchlist_usecase.dart';
import 'package:psgy/features/user/domain/usecases/watchlist/notify_watchlist_lot_opened_usecase.dart';
import 'package:psgy/features/user/domain/usecases/watchlist/toggle_watch_lot_usecase.dart';
import 'package:psgy/features/user/domain/usecases/watchlist/watch_user_watchlist_usecase.dart';
import 'package:psgy/features/user/presentation/handlers/watchlist_event_handlers.dart';

final watchlistLocalNotificationServiceProvider =
    Provider<WatchlistLocalNotificationService>((ref) {
  return WatchlistLocalNotificationService();
});

final watchlistAuthServiceProvider = Provider<WatchlistAuthService>((ref) {
  return WatchlistAuthService();
});

final fcmWatchlistNotificationPortProvider =
    Provider<FcmWatchlistNotificationPort>((ref) {
  return FcmWatchlistNotificationPort(
    fcmService: ref.watch(fcmNotificationServiceProvider),
    notificationsEnabled: () async {
      return ref.read(watchlistNotificationsEnabledProvider).valueOrNull ?? true;
    },
  );
});

final watchlistLocalDataSourceProvider =
    Provider<WatchlistLocalDataSource>((ref) {
  return WatchlistLocalDataSource(ref.watch(isarProvider));
});

final watchlistRemoteDataSourceProvider =
    Provider<WatchlistRemoteDataSource>((ref) {
  return WatchlistRemoteDataSource();
});

final watchlistRepositoryProvider = Provider<UserWatchlistRepository>((ref) {
  return WatchlistRepositoryImpl(
    localDataSource: ref.watch(watchlistLocalDataSourceProvider),
    remoteDataSource: ref.watch(watchlistRemoteDataSourceProvider),
    authService: ref.watch(watchlistAuthServiceProvider),
    notificationPort: ref.watch(fcmWatchlistNotificationPortProvider),
    fcmPort: ref.watch(fcmWatchlistNotificationPortProvider),
  );
});

final watchUserWatchlistUseCaseProvider =
    Provider<WatchUserWatchlistUseCase>((ref) {
  return WatchUserWatchlistUseCase(ref.watch(watchlistRepositoryProvider));
});

final addToWatchlistUseCaseProvider = Provider<AddToWatchlistUseCase>((ref) {
  return AddToWatchlistUseCase(ref.watch(watchlistRepositoryProvider));
});

final toggleWatchLotUseCaseProvider = Provider<ToggleWatchLotUseCase>((ref) {
  return ToggleWatchLotUseCase(ref.watch(watchlistRepositoryProvider));
});

final notifyWatchlistLotOpenedUseCaseProvider =
    Provider<NotifyWatchlistLotOpenedUseCase>((ref) {
  return NotifyWatchlistLotOpenedUseCase(ref.watch(domainEventBusProvider));
});

/// Ensures watchlist event handlers are registered once per bus instance.
final watchlistEventHandlersRegisteredProvider = Provider<void>((ref) {
  registerWatchlistEventHandlers(ref, ref.watch(domainEventBusProvider));
});

final userWatchlistProvider = StreamProvider<List<WatchlistEntity>>((ref) {
  ref.watch(watchlistEventHandlersRegisteredProvider);
  return ref.watch(watchUserWatchlistUseCaseProvider)();
});

final watchedLotIdsProvider = StreamProvider<Set<String>>((ref) {
  return ref.watch(watchUserWatchlistUseCaseProvider)().map(
        (items) => items.map((item) => item.lotId).toSet(),
      );
});

final watchlistBadgeCountProvider = StreamProvider<int>((ref) {
  return ref.watch(watchlistRepositoryProvider).watchUnreadBadgeCount();
});

/// Re-subscribe all watched lots after notifications are re-enabled.
final resyncWatchlistFcmTopicsProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final enabled =
        ref.read(watchlistNotificationsEnabledProvider).valueOrNull ?? true;
    if (!enabled) return;

    final items = await ref.read(watchUserWatchlistUseCaseProvider)().first;
    final port = ref.read(fcmWatchlistNotificationPortProvider);
    for (final item in items) {
      await port.registerInterest(item.lotId);
    }
  };
});

/// Unsubscribe all FCM topics when notifications are disabled.
final unsubscribeAllWatchlistFcmTopicsProvider =
    Provider<Future<void> Function()>((ref) {
  return () async {
    final items = await ref.read(watchUserWatchlistUseCaseProvider)().first;
    final port = ref.read(fcmWatchlistNotificationPortProvider);
    for (final item in items) {
      await port.unregisterInterest(item.lotId);
    }
  };
});
