import 'package:parking_link/core/cache/cache_metrics.dart';

enum SyncTrigger {
  manual,
  mapIdle,
  connectivity,
  periodic,
  foreground,
  invalidation,
}

class CacheSyncState {
  final DateTime? lastLotsSyncAt;
  final DateTime? lastVehicleTypesSyncAt;
  final Duration? lastSyncDuration;
  final SyncTrigger? lastTrigger;
  final bool isSyncing;
  final CacheMetrics metrics;
  final String? lastError;

  const CacheSyncState({
    this.lastLotsSyncAt,
    this.lastVehicleTypesSyncAt,
    this.lastSyncDuration,
    this.lastTrigger,
    this.isSyncing = false,
    this.metrics = CacheMetrics.empty,
    this.lastError,
  });

  CacheSyncState copyWith({
    DateTime? lastLotsSyncAt,
    DateTime? lastVehicleTypesSyncAt,
    Duration? lastSyncDuration,
    SyncTrigger? lastTrigger,
    bool? isSyncing,
    CacheMetrics? metrics,
    String? lastError,
    bool clearError = false,
  }) {
    return CacheSyncState(
      lastLotsSyncAt: lastLotsSyncAt ?? this.lastLotsSyncAt,
      lastVehicleTypesSyncAt:
          lastVehicleTypesSyncAt ?? this.lastVehicleTypesSyncAt,
      lastSyncDuration: lastSyncDuration ?? this.lastSyncDuration,
      lastTrigger: lastTrigger ?? this.lastTrigger,
      isSyncing: isSyncing ?? this.isSyncing,
      metrics: metrics ?? this.metrics,
      lastError: clearError ? null : (lastError ?? this.lastError),
    );
  }
}
