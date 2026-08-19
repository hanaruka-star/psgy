import 'package:psgy/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:psgy/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:psgy/features/user/domain/entities/user_lot_filter.dart';

class FilterParkingLotsUseCase {
  List<ParkingLotEntity> call({
    required List<ParkingLotEntity> lots,
    required Map<String, List<VehicleTypeEntity>> vehicleTypesByLotId,
    required UserLotFilter filter,
  }) {
    final filteredLots = <ParkingLotEntity>[];

    for (final lot in lots) {
      if (filter.openOnly && !lot.isOpen) {
        continue;
      }

      final vehicleTypes = vehicleTypesByLotId[lot.id] ?? const [];

      if (filter.vehicleType != null) {
        final hasFilteredTypeSlot = vehicleTypes.any(
          (vehicleType) =>
              vehicleType.type == filter.vehicleType &&
              vehicleType.availableSlots > 0,
        );
        if (!hasFilteredTypeSlot) {
          continue;
        }
      }

      if (filter.availableOnly) {
        final hasAnySlot = vehicleTypes.any(
          (vehicleType) => vehicleType.availableSlots > 0,
        );
        if (!hasAnySlot) {
          continue;
        }
      }

      filteredLots.add(lot);
    }

    return filteredLots;
  }
}
