import 'package:flutter/material.dart';
import 'package:parking_link/core/error/app_error_ui.dart';
import 'package:parking_link/core/error/app_exception.dart';
import 'package:parking_link/core/theme/app_colors.dart';
import 'package:parking_link/core/theme/app_spacing.dart';
import 'package:parking_link/shared/widgets/micro_interactions.dart';

class AppErrorView extends StatelessWidget {
  final AppErrorPresentation presentation;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final VoidCallback? onSupportAction;
  final bool compact;
  final Widget? progress;

  const AppErrorView({
    super.key,
    required this.presentation,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.onSupportAction,
    this.compact = false,
    this.progress,
  });

  factory AppErrorView.fromError(
    Object error, {
    VoidCallback? onPrimaryAction,
    VoidCallback? onSecondaryAction,
    VoidCallback? onSupportAction,
    bool compact = false,
    Widget? progress,
  }) {
    return AppErrorView(
      presentation: AppErrorUi.from(error),
      onPrimaryAction: onPrimaryAction,
      onSecondaryAction: onSecondaryAction,
      onSupportAction: onSupportAction,
      compact: compact,
      progress: progress,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _CompactErrorCard(
        presentation: presentation,
        onPrimaryAction: onPrimaryAction,
        onSecondaryAction: onSecondaryAction,
      );
    }

    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ErrorIcon(presentation: presentation),
              const SizedBox(height: AppSpacing.lg),
              Text(
                presentation.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                presentation.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
              ),
              if (progress != null) ...[
                const SizedBox(height: AppSpacing.lg),
                progress!,
              ],
              const SizedBox(height: AppSpacing.xl),
              if (onPrimaryAction != null)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onPrimaryAction,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(presentation.primaryActionLabel),
                  ),
                ),
              if (onSecondaryAction != null &&
                  presentation.secondaryActionLabel != null) ...[
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onSecondaryAction,
                    child: Text(presentation.secondaryActionLabel!),
                  ),
                ),
              ],
              if (presentation.showSupportAction &&
                  onSupportAction != null) ...[
                const SizedBox(height: AppSpacing.sm),
                TextButton.icon(
                  onPressed: onSupportAction,
                  icon: const Icon(Icons.support_agent_rounded, size: 18),
                  label: const Text('Liên hệ hỗ trợ'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkErrorView extends AppErrorView {
  NetworkErrorView({
    super.key,
    super.progress,
    super.compact = false,
    VoidCallback? onRetry,
    VoidCallback? onUseCache,
  }) : super(
          presentation: AppErrorUi.from(
            const NetworkException(
              'Kiểm tra kết nối mạng và thử lại.',
            ),
          ),
          onPrimaryAction: onRetry,
          onSecondaryAction: onUseCache,
        );
}

class LocationErrorView extends AppErrorView {
  LocationErrorView({
    super.key,
    super.compact = false,
    required bool serviceDisabled,
    VoidCallback? onRetry,
    VoidCallback? onManualLocation,
  }) : super(
          presentation: AppErrorUi.locationDenied(
            serviceDisabled: serviceDisabled,
          ),
          onPrimaryAction: onRetry,
          onSecondaryAction: onManualLocation,
        );
}

class _CompactErrorCard extends StatelessWidget {
  final AppErrorPresentation presentation;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;

  const _CompactErrorCard({
    required this.presentation,
    this.onPrimaryAction,
    this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: presentation.iconBackground.withValues(alpha: 0.65),
      borderRadius: AppSpacing.borderRadiusMd,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(presentation.icon, color: presentation.iconColor, size: 22),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    presentation.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    presentation.message,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  if (onPrimaryAction != null || onSecondaryAction != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: [
                        if (onPrimaryAction != null)
                          ScaleTap(
                            onTap: onPrimaryAction,
                            child: Text(
                              presentation.primaryActionLabel,
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        if (onSecondaryAction != null &&
                            presentation.secondaryActionLabel != null)
                          ScaleTap(
                            onTap: onSecondaryAction,
                            child: Text(
                              presentation.secondaryActionLabel!,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorIcon extends StatelessWidget {
  final AppErrorPresentation presentation;

  const _ErrorIcon({required this.presentation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: presentation.iconBackground.withValues(alpha: 0.85),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: presentation.iconColor.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        presentation.icon,
        size: 44,
        color: presentation.iconColor,
      ),
    );
  }
}

class RetryProgressIndicator extends StatelessWidget {
  final int attempt;
  final Duration nextDelay;

  const RetryProgressIndicator({
    super.key,
    required this.attempt,
    required this.nextDelay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LinearProgressIndicator(minHeight: 3),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Đang thử lại (lần $attempt) sau ${nextDelay.inSeconds}s...',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
        ),
      ],
    );
  }
}
