import 'package:isar/isar.dart';
import 'package:parking_link/features/user/data/local/watched_lot_isar.dart';
import 'package:parking_link/features/user/domain/entities/watchlist_entity.dart';

class WatchlistLocalDataSource {
  final Isar _isar;

  WatchlistLocalDataSource(this._isar);

  Stream<List<WatchedLotIsar>> watchAll() {
    return _isar.watchedLotIsars
        .where()
        .sortByWatchedAtDesc()
        .watch(fireImmediately: true);
  }

  Stream<int> watchUnreadCount() {
    return watchAll().map(
      (items) => items.where((item) => item.hasUnreadUpdate).length,
    );
  }

  Future<bool> isWatched(String lotId) async {
    final count =
        await _isar.watchedLotIsars.filter().lotIdEqualTo(lotId).count();
    return count > 0;
  }

  Future<void> add(WatchlistEntity entry) async {
    await _isar.writeTxn(() async {
      await _isar.watchedLotIsars.put(
        WatchedLotIsar()
          ..lotId = entry.lotId
          ..lotName = entry.lotName
          ..watchedAt = entry.watchedAt
          ..estimatedOpeningAt = entry.estimatedOpeningAt
          ..hasUnreadUpdate = entry.hasUnreadUpdate,
      );
    });
  }

  Future<void> remove(String lotId) async {
    await _isar.writeTxn(() async {
      await _isar.watchedLotIsars.filter().lotIdEqualTo(lotId).deleteAll();
    });
  }

  Future<void> markAllRead() async {
    await _isar.writeTxn(() async {
      final items = await _isar.watchedLotIsars.where().findAll();
      for (final item in items) {
        item.hasUnreadUpdate = false;
        await _isar.watchedLotIsars.put(item);
      }
    });
  }

  Future<void> markLotRead(String lotId) async {
    await _isar.writeTxn(() async {
      final item = await _isar.watchedLotIsars.getByLotId(lotId);
      if (item == null) return;
      item.hasUnreadUpdate = false;
      await _isar.watchedLotIsars.put(item);
    });
  }

  Future<void> setUnread(String lotId, {required bool unread}) async {
    await _isar.writeTxn(() async {
      final item = await _isar.watchedLotIsars.getByLotId(lotId);
      if (item == null) return;
      item.hasUnreadUpdate = unread;
      await _isar.watchedLotIsars.put(item);
    });
  }

  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.watchedLotIsars.clear();
    });
  }

  WatchlistEntity toEntity(WatchedLotIsar model) {
    return WatchlistEntity(
      lotId: model.lotId,
      lotName: model.lotName,
      watchedAt: model.watchedAt,
      estimatedOpeningAt: model.estimatedOpeningAt,
      hasUnreadUpdate: model.hasUnreadUpdate,
    );
  }
}
