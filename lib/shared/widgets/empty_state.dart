import 'package:flutter/material.dart';
import 'package:parking_link/core/theme/app_spacing.dart';
import 'package:parking_link/core/error/app_error_ui.dart';
import 'package:parking_link/shared/widgets/app_error_view.dart';

class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.35),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 40,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall,
          ),
        ],
        if (action != null) ...[
          const SizedBox(height: AppSpacing.lg),
          action!,
        ],
      ],
    );

    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: content,
      ),
    );
  }
}

class AppErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;
  final VoidCallback? onSecondary;
  final String? secondaryActionLabel;

  const AppErrorState({
    super.key,
    required this.error,
    this.onRetry,
    this.onSecondary,
    this.secondaryActionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final presentation = AppErrorUi.from(error);
    final effectivePresentation = secondaryActionLabel != null
        ? presentation.copyWith(secondaryActionLabel: secondaryActionLabel)
        : presentation;

    return AppErrorView(
      presentation: effectivePresentation,
      onPrimaryAction: onRetry,
      onSecondaryAction: onSecondary,
    );
  }
}
