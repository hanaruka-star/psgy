import 'package:flutter/foundation.dart';
import 'package:parking_link/core/cache/cache_metrics.dart';
import 'package:parking_link/core/cache/cache_sync_state.dart';

class SyncLogger {
  const SyncLogger._();

  static void info(String message) {
    debugPrint('[Sync] $message');
  }

  static void syncStarted(SyncTrigger trigger) {
    info('Started (${trigger.name})');
  }

  static void syncCompleted({
    required SyncTrigger trigger,
    required Duration duration,
    required CacheMetrics metrics,
    required int syncedLots,
    required int syncedVehicleTypeLots,
  }) {
    info(
      'Completed (${trigger.name}) in ${duration.inMilliseconds}ms | '
      'lots=$syncedLots vehicleTypeLots=$syncedVehicleTypeLots | '
      'cached=${metrics.lotsCount} lots, ${metrics.vehicleTypesCount} types',
    );
  }

  static void syncFailed(SyncTrigger trigger, Object error) {
    info('Failed (${trigger.name}): $error');
  }

  static void connectivityChanged({required bool isConnected}) {
    info('Connectivity -> ${isConnected ? 'online' : 'offline'}');
  }

  static void cacheInvalidated(String scope) {
    info('Cache invalidated: $scope');
  }
}
