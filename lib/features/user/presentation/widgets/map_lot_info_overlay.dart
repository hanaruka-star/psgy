import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/di/user_providers.dart';
import 'package:psgy/core/utils/currency_formatter.dart';
import 'package:psgy/features/user/presentation/providers/user_providers.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/parking/domain/entities/surveying_lot_entity.dart';
import 'package:psgy/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:psgy/features/user/domain/entities/map_lot_item.dart';
import 'package:psgy/features/user/presentation/widgets/map_lot_actions.dart';
import 'package:psgy/features/user/presentation/widgets/parking_lot_list_tile.dart';
import 'package:psgy/shared/widgets/micro_interactions.dart';

/// Floating info card shown when a map marker is selected.
class MapLotInfoOverlay extends ConsumerWidget {
  final MapLotItem item;
  final double? distanceKm;
  final VoidCallback onClose;

  const MapLotInfoOverlay({
    super.key,
    required this.item,
    required this.distanceKm,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final isSurveying = item.isSurveying;
    final photoUrl = item.surveyingLot?.photoUrl?.trim();
    final hasImage = photoUrl != null && photoUrl.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 16 * (1 - value)),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (distanceKm != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '📍 ${distanceKm!.toStringAsFixed(1)} km',
                            style: textTheme.labelMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  ScaleTap(
                    onTap: onClose,
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white.withValues(alpha: 0.75),
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              if (isSurveying)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _surveyingPriceText(item.surveyingLot!) ?? '🔍 Đang khảo sát',
                      style: textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _surveyingMetaLine(item.surveyingLot!),
                      style: textTheme.labelMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.86),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              else
                _ActiveSlotPriceRow(lotId: item.parkingLot!.id),
              const SizedBox(height: AppSpacing.md - 2),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => openLotDirections(
                        context: context,
                        lat: item.lat,
                        lng: item.lng,
                      ),
                      icon: const Icon(Icons.directions_rounded, size: 18),
                      label: const Text('Chỉ đường'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2A2A3A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                    ),
                  ),
                  if (hasImage) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => openLotImage(
                          context: context,
                          photoUrl: photoUrl,
                          lotName: item.name,
                        ),
                        icon: const Icon(Icons.photo_library_outlined, size: 18),
                        label: const Text('Xem hình'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _surveyingMetaLine(SurveyingLotEntity lot) {
    final slots = lot.totalSlots > 0 ? lot.totalSlots : (lot.estimatedSlots ?? 0);
    final slotText = '~$slots chỗ';
    if (lot.category.trim().isNotEmpty) {
      return '$slotText • 🛣️ ${lot.category.trim()}';
    }
    return '$slotText • 🔍 Đang khảo sát';
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

class _ActiveSlotPriceRow extends ConsumerWidget {
  final String lotId;

  const _ActiveSlotPriceRow({required this.lotId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final typesAsync = ref.watch(lotVehicleTypesProvider(lotId));
    final filter = ref.watch(vehicleTypeFilterProvider);

    return typesAsync.when(
      loading: () => Text(
        '⏳ Đang tải thông tin slot',
        style: textTheme.bodySmall?.copyWith(
          color: Colors.white.withValues(alpha: 0.75),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (types) {
        final display = _pickType(types, filter);
        if (display == null) {
          return Text(
            'Chưa có thông tin slot',
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
            ),
          );
        }
        return Text(
          '${_vehicleIcon(display.type)} ${display.availableSlots}/${display.totalSlots} chỗ • ${formatVehiclePrice(display)}',
          style: textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        );
      },
    );
  }

  String _vehicleIcon(String type) {
    if (type == 'car') return '🚗';
    if (type == 'moto') return '🏍️';
    return '🚘';
  }

  VehicleTypeEntity? _pickType(
    List<VehicleTypeEntity> types,
    String filter,
  ) {
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
