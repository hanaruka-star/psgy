import 'package:parking_link/features/user/data/datasources/watchlist_local_datasource.dart';
import 'package:parking_link/features/user/data/datasources/watchlist_remote_datasource.dart';
import 'package:parking_link/features/user/data/services/fcm_watchlist_notification_port.dart';
import 'package:parking_link/features/user/data/services/watchlist_auth_service.dart';
import 'package:parking_link/features/user/domain/entities/watchlist_entity.dart';
import 'package:parking_link/features/user/domain/ports/watchlist_notification_port.dart';
import 'package:parking_link/features/user/domain/repositories/user_watchlist_repository.dart';

class WatchlistRepositoryImpl implements UserWatchlistRepository {
  final WatchlistLocalDataSource localDataSource;
  final WatchlistRemoteDataSource remoteDataSource;
  final WatchlistAuthService authService;
  final WatchlistNotificationPort notificationPort;
  final FcmWatchlistNotificationPort? fcmPort;

  WatchlistRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.authService,
    WatchlistNotificationPort? notificationPort,
    this.fcmPort,
  }) : notificationPort =
            notificationPort ?? NoOpWatchlistNotificationPort();

  @override
  Stream<List<WatchlistEntity>> watchWatchlist() {
    return localDataSource.watchAll().map(
          (items) => items.map(localDataSource.toEntity).toList(),
        );
  }

  @override
  Stream<int> watchUnreadBadgeCount() => localDataSource.watchUnreadCount();

  @override
  Future<bool> isWatched(String lotId) => localDataSource.isWatched(lotId);

  @override
  Future<void> add(WatchlistEntity entry) async {
    await localDataSource.add(entry);
    await authService.ensureUserId();
    await remoteDataSource.upsert(entry);
    await notificationPort.registerInterest(entry.lotId);
  }

  @override
  Future<void> remove(String lotId) async {
    await localDataSource.remove(lotId);
    await remoteDataSource.remove(lotId);
    await fcmPort?.unregisterInterest(lotId);
  }

  @override
  Future<bool> toggle(WatchlistEntity entry) async {
    final watched = await isWatched(entry.lotId);
    if (watched) {
      await remove(entry.lotId);
      return false;
    }
    await add(entry);
    return true;
  }

  @override
  Future<void> markAllRead() => localDataSource.markAllRead();

  @override
  Future<void> markLotRead(String lotId) => localDataSource.markLotRead(lotId);
}
