import 'package:psgy/core/cache/cache_metrics.dart';
import 'package:psgy/core/cache/cache_sync_state.dart';

/// Normalized performance payload for Firebase Performance custom events.
class PerformanceMetrics {
  const PerformanceMetrics._();

  static Map<String, Object> fromSync({
    required CacheSyncState state,
    required int syncedLots,
    required int syncedVehicleTypeLots,
  }) {
    return {
      'sync_duration_ms': state.lastSyncDuration?.inMilliseconds ?? 0,
      'synced_lots': syncedLots,
      'synced_vehicle_type_lots': syncedVehicleTypeLots,
      'cached_lots': state.metrics.lotsCount,
      'cached_vehicle_types': state.metrics.vehicleTypesCount,
      'cached_sessions': state.metrics.sessionsCount,
      'trigger': state.lastTrigger?.name ?? 'unknown',
    };
  }

  static Map<String, Object> fromMapRender({
    required int markerCount,
    required int lotCount,
    required int durationMs,
  }) {
    return {
      'marker_count': markerCount,
      'lot_count': lotCount,
      'duration_ms': durationMs,
    };
  }

  static Map<String, Object> fromNearbyQuery({
    required int lotCount,
    required String mode,
    required int durationMs,
  }) {
    return {
      'lot_count': lotCount,
      'mode': mode,
      'duration_ms': durationMs,
    };
  }

  static Map<String, Object> fromCacheBanner({
    required bool isConnected,
    required CacheSyncState syncState,
  }) {
    return {
      'is_connected': isConnected,
      'is_syncing': syncState.isSyncing,
      'cached_lots': syncState.metrics.lotsCount,
      'cached_vehicle_types': syncState.metrics.vehicleTypesCount,
      'last_sync_ms': syncState.lastLotsSyncAt?.millisecondsSinceEpoch ?? 0,
    };
  }

  static Map<String, Object> fromIsar({
    required String operation,
    required int itemCount,
    required int durationMs,
  }) {
    return {
      'operation': operation,
      'item_count': itemCount,
      'duration_ms': durationMs,
    };
  }

  static Map<String, Object> fromCacheMetrics(CacheMetrics metrics) {
    return {
      'cached_lots': metrics.lotsCount,
      'cached_vehicle_types': metrics.vehicleTypesCount,
      'cached_sessions': metrics.sessionsCount,
      'latest_lots_cached_at_ms':
          metrics.latestLotsCachedAt?.millisecondsSinceEpoch ?? 0,
      'latest_vehicle_types_cached_at_ms':
          metrics.latestVehicleTypesCachedAt?.millisecondsSinceEpoch ?? 0,
    };
  }
}
