import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:psgy/core/cache/cache_sync_state.dart';
import 'package:psgy/core/config/app_config.dart';
import 'package:psgy/core/config/flavor.dart';
import 'package:psgy/core/debug/debug_providers.dart';
import 'package:psgy/core/di/sync_providers.dart';
import 'package:psgy/core/routes/app_navigator.dart';
import 'package:psgy/core/theme/app_spacing.dart';

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
                _toast(context, 'Background sync triggered');
              },
            ),
            _ActionTile(
              icon: Icons.delete_sweep_outlined,
              title: 'Clear Isar Cache',
              subtitle: 'Xóa cache local (AppSettings / migration marker)',
              onTap: () async {
                await ref.read(cacheInvalidationServiceProvider).invalidateAll();
                if (!context.mounted) return;
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
              icon: Icons.analytics_outlined,
              title: 'View Cache Metrics',
              subtitle: syncState.lastError == null
                  ? 'Last error: none'
                  : 'Last error: ${syncState.lastError}',
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
              'Mở menu: giữ logo Splash 2s • lắc máy (dev)',
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

  static String _metricsDetail(CacheSyncState state) {
    final fmt = DateFormat('yyyy-MM-dd HH:mm:ss');
    return [
      'Syncing: ${state.isSyncing}',
      'Last sync: ${state.lastLotsSyncAt != null ? fmt.format(state.lastLotsSyncAt!) : '-'}',
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
