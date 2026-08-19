import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_colors.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:psgy/features/user/presentation/widgets/parking_lot_list_tile.dart';
import 'package:psgy/shared/widgets/status_chip.dart';
import 'package:psgy/shared/widgets/ui_polish_widgets.dart';

class LotSlotSummary extends StatelessWidget {
  final List<VehicleTypeEntity> vehicleTypes;

  const LotSlotSummary({super.key, required this.vehicleTypes});

  @override
  Widget build(BuildContext context) {
    if (vehicleTypes.isEmpty) {
      return Text(
        'Chưa có thông tin slot',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: vehicleTypes.map((vehicleType) {
        final total = vehicleType.totalSlots;
        final available = vehicleType.availableSlots;
        final ratio = total == 0 ? 0.0 : available / total;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _typeLabel(vehicleType.type),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  StatusChip.slots(available: available, total: total),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              AnimatedSlotProgressBar(value: ratio),
              const SizedBox(height: AppSpacing.xs),
              Text(
                formatVehiclePrice(vehicleType),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.slotColor(ratio),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _typeLabel(String type) {
    if (type == 'car') return 'Xe hơi';
    if (type == 'moto') return 'Xe máy';
    return type;
  }
}
