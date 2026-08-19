import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:parking_link/core/cache/cache_sync_state.dart';
import 'package:parking_link/core/config/app_config.dart';
import 'package:parking_link/core/config/flavor.dart';
import 'package:parking_link/core/debug/debug_providers.dart';
import 'package:parking_link/core/di/app_settings_providers.dart';
import 'package:parking_link/core/di/sync_providers.dart';
import 'package:parking_link/core/di/user_providers.dart';
import 'package:parking_link/core/di/watchlist_providers.dart';
import 'package:parking_link/core/routes/app_navigator.dart';
import 'package:parking_link/core/services/fcm_notification_service.dart';
import 'package:parking_link/core/theme/app_spacing.dart';
import 'package:parking_link/features/user/presentation/handlers/watchlist_event_handlers.dart';

/// Bottom sheet with QA tools for real-device testing (dev/staging only).
class DebugMenuSheet extends ConsumerWidget {
  const DebugMenuSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const DebugMenuSheet(),
    );
  }

  static Future<void> showFromRootNavigator() {
    final context = appNavigatorKey.currentContext;
    if (context == null) {
      return Future.value();
    }
    return show(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(cacheSyncStateProvider);
    final simulateOffline = ref.watch(debugSimulateOfflineProvider);
    final notificationsEnabled =
        ref.watch(watchlistNotificationsEnabledProvider).valueOrNull ?? true;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Debug Menu',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${FlavorConfig.appName} • ${AppConfig.environmentLabel} • ${AppConfig.fullVersion}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            _ActionTile(
              icon: Icons.sync_rounded,
              title: 'Force Background Sync',
              subtitle: syncState.isSyncing
                  ? 'Đang sync...'
                  : _formatLastSync(syncState),
              onTap: () async {
                Navigator.pop(context);
                ref.read(debugSimulateOfflineProvider.notifier).state = false;
                await ref.read(backgroundSyncServiceProvider).syncNow(
                      trigger: SyncTrigger.manual,
                    );
                if (!context.mounted) return;
                ref.invalidate(userNearbyCacheSnapshotProvider);
                ref.invalidate(userNearbyNetworkSnapshotProvider);
                ref.invalidate(userSurveyingCacheSnapshotProvider);
                ref.invalidate(userSurveyingNetworkSnapshotProvider);
                _toast(context, 'Background sync triggered');
              },
            ),
            _ActionTile(
              icon: Icons.delete_sweep_outlined,
              title: 'Clear Isar Cache',
              subtitle: 'Xóa lots, vehicle types, sessions trong cache local',
              onTap: () async {
                await ref
                    .read(cacheInvalidationServiceProvider)
                    .invalidateAll();
                if (!context.mounted) return;
                ref.invalidate(userNearbyCacheSnapshotProvider);
                ref.invalidate(userNearbyNetworkSnapshotProvider);
                ref.invalidate(userSurveyingCacheSnapshotProvider);
                ref.invalidate(userSurveyingNetworkSnapshotProvider);
                Navigator.pop(context);
                _toast(context, 'Isar cache cleared');
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.wifi_off_rounded),
              title: const Text('Simulate Offline Mode'),
              subtitle: const Text('App coi như mất mạng (không tắt Wi‑Fi)'),
              value: simulateOffline,
              onChanged: (value) {
                ref.read(debugSimulateOfflineProvider.notifier).state = value;
              },
            ),
            _ActionTile(
              icon: Icons.notifications_active_outlined,
              title: 'Trigger Fake Notification',
              subtitle: notificationsEnabled
                  ? 'WatchlistLotOpenedEvent + local notif'
                  : 'Thông báo đang tắt trong Settings',
              onTap: () {
                const lotId = 'debug_fake_lot';
                const lotName = 'Bãi Demo Debug';
                handleWatchlistForegroundMessageWithReader(
                  ref.read,
                  const WatchlistNotificationPayload(
                    lotId: lotId,
                    lotName: lotName,
                    type: FcmNotificationService.lotOpenedType,
                  ),
                );
                Navigator.pop(context);
                _toast(context, 'Fake notification sent');
              },
            ),
            _ActionTile(
              icon: Icons.playlist_remove_rounded,
              title: 'Reset Watchlist',
              subtitle: 'Xóa toàn bộ bãi đang theo dõi (local)',
              onTap: () async {
                await ref.read(watchlistLocalDataSourceProvider).clearAll();
                if (!context.mounted) return;
                ref.invalidate(userWatchlistProvider);
                ref.invalidate(watchedLotIdsProvider);
                ref.invalidate(watchlistBadgeCountProvider);
                Navigator.pop(context);
                _toast(context, 'Watchlist reset');
              },
            ),
            _ActionTile(
              icon: Icons.analytics_outlined,
              title: 'View Cache Metrics',
              subtitle: _metricsSummary(syncState),
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Cache Metrics'),
                    content: SingleChildScrollView(
                      child: Text(_metricsDetail(syncState)),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Đóng'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Mở menu: giữ logo Splash 2s • giữ thanh tìm kiếm Map 2s • lắc máy (dev)',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  static String _formatLastSync(CacheSyncState state) {
    if (state.lastLotsSyncAt == null) return 'Chưa sync';
    final fmt = DateFormat('HH:mm:ss');
    return 'Lần cuối ${fmt.format(state.lastLotsSyncAt!)} • ${state.lastTrigger?.name ?? '-'}';
  }

  static String _metricsSummary(CacheSyncState state) {
    final m = state.metrics;
    return '${m.lotsCount} lots • ${m.vehicleTypesCount} VT • ${m.sessionsCount} sessions';
  }

  static String _metricsDetail(CacheSyncState state) {
    final m = state.metrics;
    final fmt = DateFormat('yyyy-MM-dd HH:mm:ss');
    return [
      'Lots cached: ${m.lotsCount}',
      'Vehicle types: ${m.vehicleTypesCount}',
      'Sessions: ${m.sessionsCount}',
      'Latest lots cache: ${m.latestLotsCachedAt != null ? fmt.format(m.latestLotsCachedAt!) : '-'}',
      'Latest VT cache: ${m.latestVehicleTypesCachedAt != null ? fmt.format(m.latestVehicleTypesCachedAt!) : '-'}',
      'Syncing: ${state.isSyncing}',
      'Last duration: ${state.lastSyncDuration?.inMilliseconds ?? '-'} ms',
      'Last error: ${state.lastError ?? 'none'}',
    ].join('\n');
  }

  static void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
