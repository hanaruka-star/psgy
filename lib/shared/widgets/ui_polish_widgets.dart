import 'package:flutter/material.dart';
import 'package:parking_link/core/theme/app_colors.dart';
import 'package:parking_link/core/theme/app_spacing.dart';
import 'package:parking_link/shared/widgets/micro_interactions.dart';

class MapActionFab extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isSpinning;

  const MapActionFab({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.isPrimary = false,
    this.isSpinning = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = isPrimary ? 56.0 : 44.0;
    final iconSize = isPrimary ? 24.0 : 20.0;

    return ScaleTap(
      onTap: onPressed,
      enableHaptic: true,
      child: Tooltip(
        message: tooltip,
        child: Material(
          elevation: 3,
          shadowColor: colorScheme.primary.withValues(alpha: 0.25),
          color: isPrimary ? colorScheme.primary : colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            side: BorderSide(
              color: isPrimary
                  ? Colors.transparent
                  : colorScheme.outline.withValues(alpha: 0.4),
            ),
          ),
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: isSpinning
                  ? SizedBox(
                      width: iconSize - 4,
                      height: iconSize - 4,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isPrimary
                            ? colorScheme.onPrimary
                            : colorScheme.primary,
                      ),
                    )
                  : Icon(
                      icon,
                      size: iconSize,
                      color: isPrimary
                          ? colorScheme.onPrimary
                          : colorScheme.primary,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final IconData? icon;

  const AnimatedFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ScaleTap(
      onTap: () => onSelected(!selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md - 2,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outline,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedSlotProgressBar extends StatelessWidget {
  final double value;
  final double height;

  const AnimatedSlotProgressBar({
    super.key,
    required this.value,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    final color = AppColors.slotColor(clamped);

    return ClipRRect(
      borderRadius: AppSpacing.borderRadiusSm,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: clamped),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, _) {
          return LinearProgressIndicator(
            value: animatedValue,
            minHeight: height,
            backgroundColor: Theme.of(context)
                .colorScheme
                .outline
                .withValues(alpha: 0.2),
            color: color,
          );
        },
      ),
    );
  }
}

class DragSheetHandle extends StatelessWidget {
  const DragSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        width: 48,
        height: 5,
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: colorScheme.outline.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}
