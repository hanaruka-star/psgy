import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/cache/cache_sync_state.dart';
import 'package:psgy/core/network/connectivity_service.dart';
import 'package:psgy/core/services/background_sync_service.dart';
import 'package:psgy/core/services/cache_invalidation_service.dart';
import 'package:psgy/features/user/domain/entities/geo_coordinate.dart';

final cacheSyncStateProvider =
    StateProvider<CacheSyncState>((ref) => const CacheSyncState());

final cacheInvalidationServiceProvider =
    Provider<CacheInvalidationService>((ref) {
  return CacheInvalidationService();
});

final backgroundSyncServiceProvider = Provider<BackgroundSyncService>((ref) {
  final service = BackgroundSyncService(
    connectivity: ref.watch(connectivityServiceProvider),
    cacheInvalidation: ref.watch(cacheInvalidationServiceProvider),
    onStateChanged: (state) {
      ref.read(cacheSyncStateProvider.notifier).state = state;
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
  await ref.read(backgroundSyncServiceProvider).syncNow(
        trigger: trigger,
        center: center,
      );
}
