import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/di/user_providers.dart';
import 'package:psgy/core/utils/currency_formatter.dart';
import 'package:psgy/features/user/presentation/providers/user_providers.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:psgy/features/user/domain/entities/map_lot_item.dart';
import 'package:psgy/features/parking/domain/entities/surveying_lot_entity.dart';
import 'package:psgy/features/user/presentation/widgets/map_lot_actions.dart';
import 'package:psgy/features/user/presentation/widgets/parking_lot_list_tile.dart';
import 'package:psgy/shared/widgets/modern_card.dart';
import 'package:psgy/shared/widgets/status_chip.dart';

/// Premium bottom-sheet card: name, slots, price, distance, actions.
class MapLotSheetCard extends ConsumerWidget {
  final MapLotItem item;
  final double? distanceKm;
  final bool isSelected;
  final VoidCallback onTap;

  const MapLotSheetCard({
    super.key,
    required this.item,
    required this.distanceKm,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSurveying = item.isSurveying;
    final photoUrl = item.surveyingLot?.photoUrl?.trim();
    final hasImage = photoUrl != null && photoUrl.isNotEmpty;

    return ModernCard(
      selected: isSelected,
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      item.address,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (distanceKm != null)
                Container(
                  padding: AppSpacing.chipPadding,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    '${distanceKm!.toStringAsFixed(1)} km',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.primary,
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md - 2),
          if (isSurveying)
            _SurveyingMeta(lot: item.surveyingLot!)
          else
            _ActiveMeta(lotId: item.id),
          const SizedBox(height: AppSpacing.md - 2),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => openLotDirections(
                    context: context,
                    lat: item.lat,
                    lng: item.lng,
                  ),
                  icon: const Icon(Icons.directions_rounded, size: 18),
                  label: const Text('Chỉ đường'),
                ),
              ),
              if (hasImage) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () => openLotImage(
                      context: context,
                      photoUrl: photoUrl,
                      lotName: item.name,
                    ),
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: const Text('Xem hình'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ActiveMeta extends ConsumerWidget {
  final String lotId;

  const _ActiveMeta({required this.lotId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typesAsync = ref.watch(lotVehicleTypesProvider(lotId));
    final filter = ref.watch(vehicleTypeFilterProvider);

    return typesAsync.when(
      loading: () => const LinearProgressIndicator(minHeight: 4),
      error: (_, __) => const SizedBox.shrink(),
      data: (types) {
        final vt = _pickType(types, filter);
        if (vt == null) return const SizedBox.shrink();
        return Row(
          children: [
            StatusChip.slots(
              available: vt.availableSlots,
              total: vt.totalSlots,
            ),
            const SizedBox(width: AppSpacing.sm),
            StatusChip.open(isOpen: vt.availableSlots > 0),
            const Spacer(),
            Text(
              formatVehiclePrice(vt),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        );
      },
    );
  }

  VehicleTypeEntity? _pickType(List<VehicleTypeEntity> types, String filter) {
    if (types.isEmpty) return null;
    if (filter == 'car') {
      for (final t in types) {
        if (t.type == 'car') return t;
      }
      return types.first;
    }
    if (filter == 'moto') {
      for (final t in types) {
        if (t.type == 'moto') return t;
      }
      return types.first;
    }
    if (filter == 'all') {
      return types.first;
    }
    if (filter == 'other') {
      for (final t in types) {
        if (t.type != 'car' && t.type != 'moto') return t;
      }
      return types.first;
    }
    return types.first;
  }
}

class _SurveyingMeta extends ConsumerWidget {
  final SurveyingLotEntity lot;

  const _SurveyingMeta({required this.lot});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = _surveyingStatusLabel(lot);
    final category = lot.category.trim();
    final priceText = _surveyingPriceText(lot);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            StatusChip(
              label: status,
              variant: StatusChipVariant.warning,
              icon: Icons.construction_outlined,
            ),
            if (category.isNotEmpty && status != category) ...[
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ],
        ),
        if (priceText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            priceText,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ],
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
