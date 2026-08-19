import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:parking_link/core/di/watchlist_providers.dart';
import 'package:parking_link/core/utils/currency_formatter.dart';
import 'package:parking_link/core/theme/app_colors.dart';
import 'package:parking_link/core/theme/app_spacing.dart';
import 'package:parking_link/features/parking/domain/entities/surveying_lot_entity.dart';
import 'package:parking_link/features/user/domain/entities/watchlist_entity.dart';
import 'package:parking_link/features/user/presentation/widgets/parking_lot_marker.dart';
import 'package:parking_link/features/user/presentation/widgets/watch_follow_button.dart';
import 'package:parking_link/shared/widgets/modern_card.dart';
import 'package:parking_link/shared/widgets/status_chip.dart';

class SurveyingLotListTile extends ConsumerWidget {
  final SurveyingLotEntity lot;
  final double? distanceKm;
  final bool isSelected;
  final VoidCallback onTap;

  const SurveyingLotListTile({
    super.key,
    required this.lot,
    required this.distanceKm,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWatched = ref.watch(
      watchedLotIdsProvider.select(
        (async) => async.valueOrNull?.contains(lot.id) ?? false,
      ),
    );
    final surveyingStatus = _surveyingStatusLabel(lot);

    return RepaintBoundary(
      child: ModernCard(
      selected: isSelected,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      surveyingMarkerColor.withValues(alpha: 0.25),
                      surveyingMarkerDeep.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: const Icon(
                  Icons.construction_outlined,
                  color: surveyingMarkerColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm + 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lot.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Potential Parking',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: surveyingMarkerColor,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                    ),
                  ],
                ),
              ),
              if (distanceKm != null)
                Container(
                  padding: AppSpacing.chipPadding,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    '${distanceKm!.toStringAsFixed(1)} km',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(lot.address, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppSpacing.sm),
          StatusChip(
            label: surveyingStatus,
            variant: StatusChipVariant.warning,
            icon: Icons.info_outline_rounded,
          ),
          const SizedBox(height: AppSpacing.md - 2),
          _InfoRow(
            icon: Icons.event_rounded,
            label: 'Ngày khảo sát',
            value: lot.surveyedAt == null
                ? 'Chưa ghi nhận'
                : DateFormat('dd/MM/yyyy').format(lot.surveyedAt!),
          ),
          if (lot.estimatedOpeningAt != null)
            _InfoRow(
              icon: Icons.schedule_rounded,
              label: 'Dự kiến mở cửa',
              value: DateFormat('dd/MM/yyyy').format(lot.estimatedOpeningAt!),
              highlight: true,
            ),
          _InfoRow(
            icon: Icons.local_parking_rounded,
            label: 'Số chỗ',
            value: lot.totalSlots > 0
                ? lot.totalSlots.toString()
                : (lot.estimatedSlots?.toString() ?? 'Chưa xác định'),
          ),
          if (_surveyingPriceText(lot) != null)
            _InfoRow(
              icon: Icons.payments_outlined,
              label: 'Giá',
              value: _surveyingPriceText(lot)!,
            ),
          if (lot.notes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              lot.notes,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          _WatchLotSection(
            lot: lot,
            isWatched: isWatched,
          ),
        ],
      ),
      ),
    );
  }

  String _surveyingStatusLabel(SurveyingLotEntity lot) {
    final vehicle = lot.vehicleTypes == 'both'
        ? '🚗🏍️'
        : lot.vehicleTypes == 'car'
            ? '🚗'
            : lot.vehicleTypes == 'moto'
                ? '🏍️'
                : '';
    if (lot.totalSlots > 0) {
      final suffix = vehicle.isEmpty ? '' : ' $vehicle';
      return '~${lot.totalSlots} chỗ$suffix';
    }
    if (lot.category.trim().isNotEmpty) {
      final suffix = vehicle.isEmpty ? '' : ' $vehicle';
      return '${lot.category.trim()}$suffix';
    }
    if (vehicle.isNotEmpty) return vehicle;
    return 'Đang khảo sát';
  }

  String? _surveyingPriceText(SurveyingLotEntity lot) {
    final car = '🚗 ${_priceLabel(lot.carPrice)}';
    final moto = '🏍️ ${_priceLabel(lot.motoPrice)}';
    return switch (lot.vehicleTypes) {
      'both' => '$car • $moto',
      'car' => car,
      'moto' => moto,
      _ => null,
    };
  }

  String _priceLabel(int price) => formatVnd(price);
}

class _WatchLotSection extends ConsumerStatefulWidget {
  final SurveyingLotEntity lot;
  final bool isWatched;

  const _WatchLotSection({
    required this.lot,
    required this.isWatched,
  });

  @override
  ConsumerState<_WatchLotSection> createState() => _WatchLotSectionState();
}

class _WatchLotSectionState extends ConsumerState<_WatchLotSection> {
  bool _loading = false;

  Future<void> _toggle() async {
    setState(() => _loading = true);
    try {
      final entry = WatchlistEntity.fromSurveying(
        lotId: widget.lot.id,
        lotName: widget.lot.name,
        estimatedOpeningAt: widget.lot.estimatedOpeningAt,
      );
      final nowWatched =
          await ref.read(toggleWatchLotUseCaseProvider).call(entry);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            nowWatched
                ? 'Bạn sẽ được thông báo khi bãi mở cửa.'
                : 'Đã bỏ theo dõi ${widget.lot.name}.',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WatchFollowButton(
      isWatched: widget.isWatched,
      isLoading: _loading,
      onPressed: _toggle,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: AppSpacing.sm),
          Text('$label: ', style: Theme.of(context).textTheme.bodySmall),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: highlight
                        ? surveyingMarkerDeep
                        : AppColors.onWarningContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
