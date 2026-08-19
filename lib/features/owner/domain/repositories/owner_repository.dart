import 'package:parking_link/features/owner/domain/entities/create_lot_input.dart';
import 'package:parking_link/features/auth/domain/entities/staff_profile_entity.dart';
import 'package:parking_link/features/owner/domain/entities/owner_vehicle_type_edit.dart';
import 'package:parking_link/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';

abstract class OwnerRepository {
  Future<ParkingLotEntity> getLot(String lotId);

  Stream<ParkingLotEntity> watchLot(String lotId);

  Stream<List<VehicleTypeEntity>> watchVehicleTypes(String lotId);

  Stream<List<StaffProfileEntity>> watchStaffList(String lotId);

  Future<void> updateLotStatus({
    required String lotId,
    required String status,
  });

  Future<void> updateVehicleType({
    required String lotId,
    required String vehicleTypeId,
    required int totalSlots,
    required String pricingModel,
    required int priceAmount,
    required String changedBy,
  });

  Future<void> saveLotEdits({
    required String lotId,
    required String status,
    required List<OwnerVehicleTypeEdit> edits,
    required String changedBy,
  });

  Future<void> toggleStaffActive({
    required String uid,
    required bool isActive,
  });

  Future<void> addStaff({
    required String lotId,
    required String name,
    required String email,
    required String password,
  });

  Future<String> createLot({
    required CreateLotInput input,
    required String ownerUid,
  });
}
