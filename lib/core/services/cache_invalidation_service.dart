import 'package:psgy/core/services/sync_logger.dart';

typedef CacheInvalidationListener = void Function();

/// Local-cache invalidation hook. Parking-lot collections were removed;
/// this keeps the sync pattern for future gym/coach cache.
class CacheInvalidationService {
  final CacheInvalidationListener? _onInvalidated;

  CacheInvalidationService({
    CacheInvalidationListener? onInvalidated,
  }) : _onInvalidated = onInvalidated;

  Future<void> invalidateAll() async {
    SyncLogger.cacheInvalidated('all');
    _onInvalidated?.call();
  }

  Future<void> purgeStaleEntries() async {
    SyncLogger.cacheInvalidated('stale_entries');
    _onInvalidated?.call();
  }
}
