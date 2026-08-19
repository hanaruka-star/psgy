import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/shared/widgets/micro_interactions.dart';

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool outlined;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ScaleTap(
      onTap: onPressed,
      enableHaptic: true,
      scale: 0.96,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md + 2,
        ),
        decoration: BoxDecoration(
          color: outlined
              ? Colors.transparent
              : (backgroundColor ?? colorScheme.primary),
          borderRadius: AppSpacing.borderRadiusMd,
          border: outlined
              ? Border.all(color: colorScheme.outline)
              : null,
          boxShadow: outlined
              ? null
              : [
                  BoxShadow(
                    color: (backgroundColor ?? colorScheme.primary)
                        .withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: outlined
                  ? colorScheme.onSurface
                  : (foregroundColor ?? colorScheme.onPrimary),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: outlined
                        ? colorScheme.onSurface
                        : (foregroundColor ?? colorScheme.onPrimary),
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
