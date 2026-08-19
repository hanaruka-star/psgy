import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/di/app_settings_providers.dart';
import 'package:parking_link/core/di/watchlist_providers.dart';
import 'package:parking_link/core/theme/app_spacing.dart';
import 'package:parking_link/shared/widgets/modern_card.dart';

/// Toggle for potential-lot (watchlist) push notifications.
class UserNotificationSettingsScreen extends ConsumerWidget {
  const UserNotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabledAsync = ref.watch(watchlistNotificationsEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
      ),
      body: enabledAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Lỗi: $error')),
        data: (enabled) {
          return ListView(
            padding: AppSpacing.screenPadding,
            children: [
              ModernCard(
                enableScaleTap: false,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Thông báo bãi tiềm năng'),
                  subtitle: const Text(
                    'Nhận thông báo khi bãi khảo sát bạn theo dõi mở cửa. '
                    'Chúng tôi chỉ gửi khi có thay đổi thực sự — không spam.',
                  ),
                  value: enabled,
                  onChanged: (value) async {
                    final datasource =
                        ref.read(appSettingsLocalDataSourceProvider);
                    await datasource.setWatchlistNotificationsEnabled(value);

                    if (value) {
                      await ref.read(resyncWatchlistFcmTopicsProvider)();
                    } else {
                      await ref.read(unsubscribeAllWatchlistFcmTopicsProvider)();
                    }
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Bạn có thể bật/tắt bất cứ lúc nào. Các bãi trong danh sách '
                'theo dõi vẫn được lưu khi tắt thông báo.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}
