import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/cache/cache_sync_state.dart';
import 'package:psgy/core/di/firebase_providers.dart';
import 'package:psgy/core/di/sync_providers.dart';
import 'package:psgy/core/monitoring/performance_metrics.dart';
import 'package:psgy/core/network/connectivity_service.dart';
import 'package:psgy/core/theme/app_colors.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/shared/widgets/micro_interactions.dart';
import 'package:psgy/shared/widgets/status_chip.dart';

enum CacheBannerLevel { good, stale, offline }

class CacheStatusBanner extends ConsumerStatefulWidget {
  final VoidCallback? onRefresh;

  const CacheStatusBanner({super.key, this.onRefresh});

  @override
  ConsumerState<CacheStatusBanner> createState() => _CacheStatusBannerState();
}

class _CacheStatusBannerState extends ConsumerState<CacheStatusBanner> {
  @override
  Widget build(BuildContext context) {
    final isConnected =
        ref.watch(connectivityStatusProvider).valueOrNull ?? true;
    final syncState = ref.watch(cacheSyncStateProvider);

    ref.listen<CacheSyncState>(cacheSyncStateProvider, (previous, next) {
      if (previous == next) return;

      ref.read(monitoringServiceProvider).logEvent(
            'cache_status_banner',
            PerformanceMetrics.fromCacheBanner(
              isConnected: isConnected,
              syncState: next,
            ),
          );
    });

    final banner = _buildBanner(
      isConnected: isConnected,
      syncState: syncState,
    );

    if (banner == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          0,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.3),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: banner,
        ),
      ),
    );
  }

  Widget? _buildBanner({
    required bool isConnected,
    required CacheSyncState syncState,
  }) {
    if (syncState.isSyncing) {
      return const _BannerPill(
        pillKey: ValueKey('syncing'),
        level: CacheBannerLevel.good,
        icon: Icons.sync_rounded,
        title: 'Đang đồng bộ',
        subtitle: 'Cập nhật dữ liệu mới nhất...',
        variant: StatusChipVariant.info,
        showSpinner: true,
      );
    }

    final lastSync =
        syncState.lastLotsSyncAt ?? syncState.metrics.latestLotsCachedAt;
    final lastSyncLabel = _formatLastSync(lastSync);

    if (!isConnected) {
      return _BannerPill(
        pillKey: const ValueKey('offline'),
        level: CacheBannerLevel.offline,
        icon: Icons.wifi_off_rounded,
        title: 'Bạn đang offline',
        subtitle: lastSyncLabel == null
            ? 'Hiển thị dữ liệu đã lưu trên máy.'
            : 'Dữ liệu cache lần cuối: $lastSyncLabel',
        variant: StatusChipVariant.danger,
        actionLabel: widget.onRefresh == null ? null : 'Thử lại',
        onAction: widget.onRefresh,
      );
    }

    if (lastSyncLabel != null && _isStale(lastSync)) {
      return _BannerPill(
        pillKey: const ValueKey('stale'),
        level: CacheBannerLevel.stale,
        icon: Icons.schedule_rounded,
        title: 'Dữ liệu có thể đã cũ',
        subtitle: 'Đồng bộ lần cuối: $lastSyncLabel',
        variant: StatusChipVariant.warning,
        actionLabel: widget.onRefresh == null ? null : 'Làm mới',
        onAction: widget.onRefresh,
      );
    }

    return null;
  }

  bool _isStale(DateTime? lastSync) {
    if (lastSync == null) return true;
    return DateTime.now().difference(lastSync) > const Duration(minutes: 30);
  }

  String? _formatLastSync(DateTime? lastSync) {
    if (lastSync == null) return null;

    final diff = DateTime.now().difference(lastSync);
    if (diff.inMinutes < 1) return 'vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }
}

class _BannerPill extends StatelessWidget {
  final Key? pillKey;
  final CacheBannerLevel level;
  final IconData icon;
  final String title;
  final String subtitle;
  final StatusChipVariant variant;
  final bool showSpinner;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _BannerPill({
    this.pillKey,
    required this.level,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.variant,
    this.showSpinner = false,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = _background(isDark);
    final foreground = _foreground(isDark);

    return Material(
      key: pillKey,
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: foreground.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: foreground.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: foreground),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: foreground.withValues(alpha: 0.92),
                        ),
                  ),
                ],
              ),
            ),
            if (showSpinner)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foreground,
                ),
              )
            else if (actionLabel != null && onAction != null)
              ScaleTap(
                onTap: onAction,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  child: Text(
                    actionLabel!,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.underline,
                          decorationColor: foreground,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _background(bool isDark) {
    switch (variant) {
      case StatusChipVariant.success:
        return isDark ? const Color(0xFF14532D) : AppColors.successContainer;
      case StatusChipVariant.warning:
        return isDark ? const Color(0xFF7C2D12) : AppColors.warningContainer;
      case StatusChipVariant.danger:
        return isDark ? const Color(0xFF7F1D1D) : AppColors.dangerContainer;
      case StatusChipVariant.info:
        return isDark
            ? AppColors.onPrimaryContainer
            : AppColors.primaryContainer;
      case StatusChipVariant.neutral:
        return isDark
            ? AppColors.surfaceVariantDark
            : AppColors.surfaceVariantLight;
    }
  }

  Color _foreground(bool isDark) {
    switch (variant) {
      case StatusChipVariant.success:
        return isDark ? AppColors.success : AppColors.onSuccessContainer;
      case StatusChipVariant.warning:
        return isDark ? AppColors.warning : AppColors.onWarningContainer;
      case StatusChipVariant.danger:
        return isDark ? AppColors.danger : AppColors.onDangerContainer;
      case StatusChipVariant.info:
        return isDark ? AppColors.primaryLight : AppColors.onPrimaryContainer;
      case StatusChipVariant.neutral:
        return isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    }
  }
}
