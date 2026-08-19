import 'package:parking_link/core/cache/cache_policy.dart';
import 'package:parking_link/core/services/sync_logger.dart';
import 'package:parking_link/features/parking/data/datasources/parking_local_datasource.dart';

typedef CacheInvalidationListener = void Function();

class CacheInvalidationService {
  final ParkingLocalDataSource? _local;
  final CacheInvalidationListener? _onInvalidated;

  CacheInvalidationService({
    ParkingLocalDataSource? localDataSource,
    CacheInvalidationListener? onInvalidated,
  })  : _local = localDataSource,
        _onInvalidated = onInvalidated;

  Future<void> invalidateNearbyLots() async {
    final local = _local;
    if (local == null) return;

    await local.purgeExpiredLots(ttl: Duration.zero);
    SyncLogger.cacheInvalidated('nearby_lots');
    _onInvalidated?.call();
  }

  Future<void> invalidateVehicleTypes() async {
    final local = _local;
    if (local == null) return;

    await local.purgeExpiredVehicleTypes(ttl: Duration.zero);
    SyncLogger.cacheInvalidated('vehicle_types');
    _onInvalidated?.call();
  }

  Future<void> invalidateAll() async {
    final local = _local;
    if (local == null) return;

    await local.clearAll();
    SyncLogger.cacheInvalidated('all');
    _onInvalidated?.call();
  }

  Future<void> purgeStaleEntries() async {
    final local = _local;
    if (local == null) return;

    await local.purgeExpiredLots(ttl: CachePolicy.nearbyLotsTtl);
    await local.purgeExpiredVehicleTypes(ttl: CachePolicy.vehicleTypesTtl);
    SyncLogger.cacheInvalidated('stale_entries');
    _onInvalidated?.call();
  }
}
