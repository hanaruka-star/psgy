import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/theme/app_spacing.dart';
import 'package:parking_link/features/user/presentation/widgets/parking_lot_marker.dart';
import 'package:parking_link/shared/widgets/micro_interactions.dart';
import 'package:parking_link/shared/widgets/modern_card.dart';

final mapLegendExpandedProvider = StateProvider<bool>((ref) => false);

class MapLegend extends ConsumerWidget {
  const MapLegend({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = ref.watch(mapLegendExpandedProvider);

    if (!expanded) {
      return ScaleTap(
        onTap: () =>
            ref.read(mapLegendExpandedProvider.notifier).state = true,
        child: ModernCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md - 2,
            vertical: AppSpacing.sm + 2,
          ),
          borderRadius: AppSpacing.borderRadiusMd,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: surveyingMarkerColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Chú thích',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.expand_less_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.outline,
              ),
            ],
          ),
        ),
      );
    }

    return ModernCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md - 2,
        vertical: AppSpacing.sm + 2,
      ),
      borderRadius: AppSpacing.borderRadiusMd,
      enableScaleTap: false,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 260),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Chú thích bản đồ',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                ScaleTap(
                  onTap: () => ref
                      .read(mapLegendExpandedProvider.notifier)
                      .state = false,
                  child: Icon(
                    Icons.expand_more_rounded,
                    size: 18,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            const _LegendRow(
              color: Color(0xFF22C55E),
              icon: Icons.local_parking_rounded,
              label: 'Xanh — Có chỗ realtime',
              hint: 'Bãi động, số chỗ cập nhật theo thời gian thực',
            ),
            const SizedBox(height: AppSpacing.sm),
            const _LegendRow(
              color: surveyingMarkerColor,
              icon: Icons.construction_outlined,
              label: 'Vàng — Bãi tiềm năng',
              hint: 'Bãi tĩnh khảo sát, chỉ hiển thị ước tính',
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final String hint;

  const _LegendRow({
    required this.color,
    required this.icon,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                hint,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 11,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
