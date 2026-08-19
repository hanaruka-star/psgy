import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:psgy/core/di/watchlist_providers.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/user/domain/entities/watchlist_entity.dart';
import 'package:psgy/features/user/presentation/screens/user_notification_settings_screen.dart';
import 'package:psgy/features/user/presentation/widgets/parking_lot_marker.dart';
import 'package:psgy/shared/widgets/empty_state.dart';
import 'package:psgy/shared/widgets/modern_card.dart';
import 'package:psgy/shared/widgets/status_chip.dart';

class WatchlistScreen extends ConsumerStatefulWidget {
  const WatchlistScreen({super.key});

  @override
  ConsumerState<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(watchlistRepositoryProvider).markAllRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final watchlistAsync = ref.watch(userWatchlistProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bãi đang theo dõi'),
        actions: [
          IconButton(
            tooltip: 'Cài đặt thông báo',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const UserNotificationSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: watchlistAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(userWatchlistProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return EmptyStateView(
              icon: Icons.notifications_none_rounded,
              title: 'Chưa theo dõi bãi nào',
              subtitle:
                  'Theo dõi bãi khảo sát trên bản đồ — chúng tôi sẽ thông báo khi bãi mở cửa.',
              action: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.map_outlined, size: 18),
                label: const Text('Khám phá bản đồ'),
              ),
            );
          }

          return ListView.separated(
            padding: AppSpacing.screenPadding,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              return _WatchlistCard(
                entry: items[index],
                onDismiss: () async {
                  await ref
                      .read(toggleWatchLotUseCaseProvider)
                      .call(items[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _WatchlistCard extends StatelessWidget {
  final WatchlistEntity entry;
  final VoidCallback onDismiss;

  const _WatchlistCard({
    required this.entry,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      enableScaleTap: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.construction_rounded,
                color: surveyingMarkerColor,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  entry.lotName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (entry.hasUnreadUpdate)
                const StatusChip(
                  label: 'Mới',
                  variant: StatusChipVariant.success,
                  icon: Icons.fiber_new_rounded,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            entry.estimatedOpeningAt == null
                ? 'Ngày mở cửa: chưa xác định'
                : 'Dự kiến mở: ${DateFormat('dd/MM/yyyy').format(entry.estimatedOpeningAt!)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: surveyingMarkerDeep,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Theo dõi từ ${DateFormat('dd/MM/yyyy').format(entry.watchedAt)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onDismiss,
              icon: const Icon(Icons.notifications_off_outlined, size: 18),
              label: const Text('Bỏ theo dõi'),
            ),
          ),
        ],
      ),
    );
  }
}
