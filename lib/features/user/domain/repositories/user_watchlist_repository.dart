import 'package:parking_link/features/user/domain/entities/watchlist_entity.dart';

typedef WatchlistRepository = UserWatchlistRepository;

abstract class UserWatchlistRepository {
  Stream<List<WatchlistEntity>> watchWatchlist();

  Stream<int> watchUnreadBadgeCount();

  Future<bool> isWatched(String lotId);

  Future<void> add(WatchlistEntity entry);

  Future<void> remove(String lotId);

  Future<bool> toggle(WatchlistEntity entry);

  Future<void> markAllRead();

  Future<void> markLotRead(String lotId);
}

extension UserWatchlistRepositoryLegacy on UserWatchlistRepository {
  Stream<Set<String>> watchWatchedLotIds() {
    return watchWatchlist().map(
      (items) => items.map((item) => item.lotId).toSet(),
    );
  }
}
