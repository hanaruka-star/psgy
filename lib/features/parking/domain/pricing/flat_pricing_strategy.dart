import 'package:parking_link/features/parking/domain/entities/parking_session_entity.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:parking_link/features/parking/domain/pricing/i_pricing_strategy.dart';

/// Flat per-trip pricing: the fee equals [VehicleTypeEntity.priceAmount]
/// regardless of parking duration.
class FlatPricingStrategy implements IPricingStrategy {
  const FlatPricingStrategy();

  @override
  int calculate({
    required ParkingSessionEntity session,
    required VehicleTypeEntity vehicleType,
    required DateTime now,
  }) {
    return vehicleType.priceAmount;
  }
}
