import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:parking_link/features/parking/domain/entities/surveying_lot_entity.dart';
import 'package:parking_link/features/user/domain/entities/vehicle_type_filter.dart';
import 'package:parking_link/features/user/presentation/widgets/parking_lot_marker.dart';

/// Vehicle-type helpers for static (surveying) lots.
abstract final class SurveyingLotVehicle {
  /// Static parking never appears under "Other" (reserved for EV/swap amenities).
  static bool supportsFilter(SurveyingLotEntity lot, String vehicleType) {
    if (isFutureAmenity(lot)) {
      return vehicleType == VehicleTypeFilter.all;
    }

    final car = supportsCar(lot);
    final moto = supportsMoto(lot);

    return switch (vehicleType) {
      VehicleTypeFilter.car => car,
      VehicleTypeFilter.moto => moto,
      VehicleTypeFilter.all => true,
      VehicleTypeFilter.other => false,
      _ => true,
    };
  }

  static bool supportsCar(SurveyingLotEntity lot) {
    if (lot.hasCar) return true;
    if (lot.vehicleTypes.isNotEmpty) return false;
    if ((lot.estimatedCarSlots ?? 0) > 0) return true;
    if (_explicitMotoOnly(lot)) return false;
    if (_textHintsCar(lot)) return true;
    if (_genericSurveyingLot(lot)) return true;
    return false;
  }

  static bool supportsMoto(SurveyingLotEntity lot) {
    if (lot.hasMoto) return true;
    if (lot.vehicleTypes.isNotEmpty) return false;
    if ((lot.estimatedMotoSlots ?? 0) > 0) return true;
    if (_explicitCarOnly(lot)) return false;
    if (_textHintsMoto(lot)) return true;
    if (_genericSurveyingLot(lot)) return true;
    return false;
  }

  /// Future amenities (charging, battery swap) — not static parking.
  static bool isFutureAmenity(SurveyingLotEntity lot) {
    final text = _haystack(lot);
    return text.contains('sạc') ||
        text.contains('charging') ||
        text.contains('ev ') ||
        text.contains('đổi pin') ||
        text.contains('battery') ||
        text.contains('swap');
  }

  static MarkerVehicleKind markerKind(SurveyingLotEntity lot) {
    if (supportsCar(lot) && !supportsMoto(lot)) {
      return MarkerVehicleKind.car;
    }
    if (supportsMoto(lot) && !supportsCar(lot)) {
      return MarkerVehicleKind.moto;
    }
    if (supportsMoto(lot)) return MarkerVehicleKind.moto;
    if (supportsCar(lot)) return MarkerVehicleKind.car;
    return MarkerVehicleKind.moto;
  }

  static bool _explicitCarOnly(SurveyingLotEntity lot) {
    return (lot.estimatedCarSlots ?? 0) > 0 && (lot.estimatedMotoSlots ?? 0) == 0;
  }

  static bool _explicitMotoOnly(SurveyingLotEntity lot) {
    return (lot.estimatedMotoSlots ?? 0) > 0 && (lot.estimatedCarSlots ?? 0) == 0;
  }

  /// Surveying lot with no vehicle-specific metadata — show under both car & moto.
  static bool _genericSurveyingLot(SurveyingLotEntity lot) {
    if (_explicitCarOnly(lot) || _explicitMotoOnly(lot)) return false;
    if (_textHintsCar(lot) || _textHintsMoto(lot)) return false;
    return lot.name.isNotEmpty;
  }

  static bool _textHintsCar(SurveyingLotEntity lot) {
    final text = _haystack(lot);
    return text.contains('ô tô') ||
        text.contains('oto') ||
        text.contains('xe hơi') ||
        text.contains('car') ||
        text.contains('4 bánh');
  }

  static bool _textHintsMoto(SurveyingLotEntity lot) {
    final text = _haystack(lot);
    return text.contains('xe máy') ||
        text.contains('moto') ||
        text.contains('motor') ||
        text.contains('2 bánh');
  }

  static String _haystack(SurveyingLotEntity lot) {
    return '${lot.name} ${lot.address} ${lot.notes}'.toLowerCase();
  }
}

/// Future amenity types on active lots (shown under "Other" chip only).
const futureVehicleTypes = {
  'ev_charging',
  'charging',
  'battery_swap',
  'swap',
  'other',
};

bool activeLotSupportsVehicleFilter(
  List<VehicleTypeEntity> vehicleTypes,
  String vehicleType,
) {
  return switch (vehicleType) {
    VehicleTypeFilter.car =>
      vehicleTypes.any((vt) => vt.type == VehicleTypeFilter.car),
    VehicleTypeFilter.moto =>
      vehicleTypes.any((vt) => vt.type == VehicleTypeFilter.moto),
    VehicleTypeFilter.all => true,
    VehicleTypeFilter.other => vehicleTypes.any(
        (vt) => futureVehicleTypes.contains(vt.type),
      ),
    _ => true,
  };
}
