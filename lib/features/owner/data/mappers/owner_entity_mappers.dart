import 'package:psgy/features/auth/data/mappers/staff_profile_mapper.dart';
import 'package:psgy/features/auth/data/models/staff_profile_model.dart';
import 'package:psgy/features/auth/domain/entities/staff_profile_entity.dart';
import 'package:psgy/features/parking/data/mappers/parking_lot_mapper.dart';
import 'package:psgy/features/parking/data/mappers/vehicle_type_mapper.dart';
import 'package:psgy/features/parking/data/models/parking_lot_model.dart';
import 'package:psgy/features/parking/data/models/vehicle_type_model.dart';
import 'package:psgy/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:psgy/features/parking/domain/entities/vehicle_type_entity.dart';

class OwnerLotMapper {
  const OwnerLotMapper._();

  static ParkingLotEntity toEntity(ParkingLotModel model) {
    return ParkingLotMapper.toEntity(model);
  }
}

class OwnerVehicleTypeMapper {
  const OwnerVehicleTypeMapper._();

  static VehicleTypeEntity toEntity(VehicleTypeModel model) {
    return VehicleTypeMapper.toEntity(model);
  }
}

class OwnerStaffProfileMapper {
  const OwnerStaffProfileMapper._();

  static StaffProfileEntity toEntity(StaffProfileModel model) {
    return StaffProfileMapper.toEntity(model);
  }
}
