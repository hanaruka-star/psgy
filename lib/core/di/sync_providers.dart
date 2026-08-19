import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/cache/cache_sync_state.dart';
import 'package:parking_link/core/di/firebase_providers.dart';
import 'package:parking_link/core/di/isar_providers.dart';
import 'package:parking_link/core/di/parking_providers.dart';
import 'package:parking_link/core/di/user_providers.dart';
import 'package:parking_link/core/network/connectivity_service.dart';
import 'package:parking_link/core/services/background_sync_service.dart';
import 'package:parking_link/core/services/cache_invalidation_service.dart';
import 'package:parking_link/features/user/domain/entities/geo_coordinate.dart';

final cacheSyncStateProvider =
    StateProvider<CacheSyncState>((ref) => const CacheSyncState());

final cacheInvalidationServiceProvider =
    Provider<CacheInvalidationService>((ref) {
  return CacheInvalidationService(
    localDataSource: ref.watch(parkingLocalDataSourceProvider),
    onInvalidated: () {
      _invalidateUserMapLotSnapshots(ref);
    },
  );
});

final backgroundSyncServiceProvider = Provider<BackgroundSyncService>((ref) {
  final service = BackgroundSyncService(
    connectivity: ref.watch(connectivityServiceProvider),
    userRepository: ref.watch(userRepositoryProvider),
    parkingRepository: ref.watch(parkingRepositoryProvider),
    cacheInvalidation: ref.watch(cacheInvalidationServiceProvider),
    localDataSource: ref.watch(parkingLocalDataSourceProvider),
    monitoring: ref.watch(monitoringServiceProvider),
    onStateChanged: (state) {
      ref.read(cacheSyncStateProvider.notifier).state = state;
      if (!state.isSyncing && state.lastLotsSyncAt != null) {
        _invalidateUserMapLotSnapshots(ref);
      }
    },
    getSearchCenter: () {
      final mapCenter = ref.read(mapSearchCenterProvider);
      return mapCenter;
    },
  );

  ref.onDispose(service.dispose);
  return service;
});

Future<void> triggerUserDataSync(
  WidgetRef ref, {
  required SyncTrigger trigger,
  GeoCoordinate? center,
}) async {
  final syncService = ref.read(backgroundSyncServiceProvider);
  await syncService.syncNow(trigger: trigger, center: center);
  ref.invalidate(userNearbyCacheSnapshotProvider);
  ref.invalidate(userNearbyNetworkSnapshotProvider);
  ref.invalidate(userSurveyingCacheSnapshotProvider);
  ref.invalidate(userSurveyingNetworkSnapshotProvider);
}

void _invalidateUserMapLotSnapshots(Ref ref) {
  ref.invalidate(userNearbyCacheSnapshotProvider);
  ref.invalidate(userNearbyNetworkSnapshotProvider);
  ref.invalidate(userSurveyingCacheSnapshotProvider);
  ref.invalidate(userSurveyingNetworkSnapshotProvider);
}
