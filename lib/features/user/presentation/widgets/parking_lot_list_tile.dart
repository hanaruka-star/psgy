import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:parking_link/core/theme/app_spacing.dart';
import 'package:parking_link/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:parking_link/core/di/user_providers.dart';
import 'package:parking_link/shared/widgets/lot_slot_summary.dart';
import 'package:parking_link/shared/widgets/modern_card.dart';
import 'package:parking_link/shared/widgets/status_chip.dart';
import 'package:url_launcher/url_launcher.dart';

class ParkingLotListTile extends ConsumerWidget {
  final ParkingLotEntity lot;
  final double? distanceKm;
  final bool isSelected;
  final VoidCallback onTap;

  const ParkingLotListTile({
    super.key,
    required this.lot,
    required this.distanceKm,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleTypesAsync = ref.watch(lotVehicleTypesProvider(lot.id));
    final colorScheme = Theme.of(context).colorScheme;

    return ModernCard(
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
                  color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Icon(
                  Icons.local_parking_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm + 2),
              Expanded(
                child: Text(
                  lot.name,
                  style: Theme.of(context).textTheme.titleMedium,
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
                    _formatDistance(distanceKm!),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            lot.address,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          StatusChip.open(isOpen: lot.isOpen),
          const SizedBox(height: AppSpacing.sm + 2),
          vehicleTypesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text(
              error.toString().replaceFirst('Exception: ', ''),
              style: TextStyle(color: colorScheme.error),
            ),
            data: (vehicleTypes) => LotSlotSummary(vehicleTypes: vehicleTypes),
          ),
          const SizedBox(height: AppSpacing.md - 2),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _openDirections(context),
              icon: const Icon(Icons.directions_rounded, size: 18),
              label: const Text('Chỉ đường'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDistance(double distanceKm) {
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  Future<void> _openDirections(BuildContext context) async {
    final lat = lot.lat;
    final lng = lot.lng;
    final urls = [
      Uri.parse('comgooglemaps://?daddr=$lat,$lng&directionsmode=driving'),
      Uri.parse('maps://?daddr=$lat,$lng'),
      Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
      ),
    ];

    for (final url in urls) {
      try {
        if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
          return;
        }
      } catch (_) {}
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Không thể mở ứng dụng bản đồ')),
    );
  }
}

String formatVehiclePrice(VehicleTypeEntity vehicleType) {
  final amount = NumberFormat.decimalPattern('vi_VN').format(
    vehicleType.priceAmount,
  );
  final unit = vehicleType.isPerDay ? 'ngày' : 'lượt';
  return '$amountđ/$unit';
}
