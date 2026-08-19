import 'package:flutter/material.dart';
import 'package:parking_link/core/theme/app_colors.dart';
import 'package:parking_link/core/theme/app_spacing.dart';

enum StatusChipVariant { success, warning, danger, info, neutral }

class StatusChip extends StatelessWidget {
  final String label;
  final StatusChipVariant variant;
  final IconData? icon;

  const StatusChip({
    super.key,
    required this.label,
    this.variant = StatusChipVariant.neutral,
    this.icon,
  });

  factory StatusChip.open({required bool isOpen}) {
    return StatusChip(
      label: isOpen ? 'Đang mở' : 'Đóng cửa',
      variant: isOpen ? StatusChipVariant.success : StatusChipVariant.danger,
      icon: isOpen ? Icons.check_circle_rounded : Icons.cancel_rounded,
    );
  }

  factory StatusChip.slots({
    required int available,
    required int total,
  }) {
    final ratio = total == 0 ? 0.0 : available / total;
    final variant = ratio > 0.5
        ? StatusChipVariant.success
        : ratio > 0.1
            ? StatusChipVariant.warning
            : StatusChipVariant.danger;

    return StatusChip(
      label: 'Còn $available/$total',
      variant: variant,
      icon: Icons.local_parking_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _resolveColors(isDark);

    return Container(
      padding: AppSpacing.chipPadding,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: colors.foreground.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: colors.foreground),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.foreground,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  _ChipColors _resolveColors(bool isDark) {
    switch (variant) {
      case StatusChipVariant.success:
        return _ChipColors(
          background: isDark ? const Color(0xFF14532D) : AppColors.successContainer,
          foreground: isDark ? AppColors.success : AppColors.onSuccessContainer,
        );
      case StatusChipVariant.warning:
        return _ChipColors(
          background: isDark ? const Color(0xFF7C2D12) : AppColors.warningContainer,
          foreground: isDark ? AppColors.warning : AppColors.onWarningContainer,
        );
      case StatusChipVariant.danger:
        return _ChipColors(
          background: isDark ? const Color(0xFF7F1D1D) : AppColors.dangerContainer,
          foreground: isDark ? AppColors.danger : AppColors.onDangerContainer,
        );
      case StatusChipVariant.info:
        return _ChipColors(
          background: isDark ? AppColors.onPrimaryContainer : AppColors.primaryContainer,
          foreground: isDark ? AppColors.primaryLight : AppColors.onPrimaryContainer,
        );
      case StatusChipVariant.neutral:
        return _ChipColors(
          background: isDark
              ? AppColors.surfaceVariantDark
              : AppColors.surfaceVariantLight,
          foreground: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        );
    }
  }
}

class _ChipColors {
  final Color background;
  final Color foreground;

  const _ChipColors({required this.background, required this.foreground});
}
