import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:parking_link/features/parking/domain/pricing/flat_pricing_strategy.dart';
import 'package:parking_link/features/parking/domain/pricing/i_pricing_strategy.dart';

/// Resolves the pricing strategy for a vehicle type.
///
/// This phase always returns [FlatPricingStrategy]. Future phases may switch
/// on [VehicleTypeEntity.pricingModel]:
///   - `per_trip` -> FlatPricingStrategy
///   - `per_hour` -> HourlyPricingStrategy (not yet implemented)
///   - `per_day`  -> DailyPricingStrategy (not yet implemented)
IPricingStrategy pricingStrategyFor(VehicleTypeEntity vehicleType) {
  return const FlatPricingStrategy();
}
