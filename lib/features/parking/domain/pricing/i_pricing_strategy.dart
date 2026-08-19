import 'package:psgy/features/parking/domain/entities/parking_session_entity.dart';
import 'package:psgy/features/parking/domain/entities/vehicle_type_entity.dart';

/// Strategy for estimating a parking fee.
///
/// Pure domain — must not depend on Firebase/Isar/http or any side effect.
abstract class IPricingStrategy {
  /// Returns the estimated fee (VND) for [session].
  ///
  /// - [session]: provides `checkedInAt`.
  /// - [vehicleType]: provides `pricingModel` + `priceAmount`.
  /// - [now]: reference time used to derive parking duration.
  int calculate({
    required ParkingSessionEntity session,
    required VehicleTypeEntity vehicleType,
    required DateTime now,
  });
}
