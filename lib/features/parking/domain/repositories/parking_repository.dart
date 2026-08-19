import '../entities/parking_lot_entity.dart';
import '../entities/parking_session_entity.dart';
import '../entities/parking_slot_entity.dart';
import '../entities/vehicle_type_entity.dart';

abstract class ParkingRepository {
  // Lay danh sach bai xe gan vi tri (mot lan)
  Future<List<ParkingLotEntity>> getNearbyLots(
    double lat,
    double lng,
    double radiusKm,
  );

  // Lang nghe realtime 1 bai xe cu the
  Stream<ParkingLotEntity> watchLot(String lotId);

  // Lang nghe realtime tat ca bai xe
  Stream<List<ParkingLotEntity>> watchAllLots();

  // Lang nghe realtime slots cua 1 bai
  Stream<List<ParkingSlotEntity>> watchSlots(String lotId);

  // Lang nghe realtime vehicle types cua 1 bai
  Stream<List<VehicleTypeEntity>> watchVehicleTypes(String lotId);

  // Lay vehicle types mot lan (background sync)
  Future<List<VehicleTypeEntity>> fetchVehicleTypes(String lotId);

  // Lang nghe sessions dang active theo loai xe
  Stream<List<ParkingSessionEntity>> watchActiveSessions({
    required String lotId,
    required String vehicleType,
  });

  // Lang nghe realtime 1 session theo id (ParkCard, checkout flow)
  Stream<ParkingSessionEntity?> watchSession(String sessionId);

  // Lay sessions gan nhat cho man hinh lich su
  Future<List<ParkingSessionEntity>> getSessions(
    String lotId, {
    int limit = 50,
  });

  // Lay audit trail dieu chinh thu cong gan nhat
  Future<List<Map<String, dynamic>>> getManualAdjustments(
    String lotId, {
    int limit = 20,
  });

  // Check-in xe theo loai xe
  Future<String> checkIn({
    required String lotId,
    required String vehicleType,
    required String vehiclePlate,
    required String staffId,
    String? userId,
    String? vehicleId,
    String? vehiclePhotoUrl,
    String? checkInMethod,
  });

  // Check-out session dang active
  Future<void> checkOut({
    required String lotId,
    required String sessionId,
    required String vehicleType,
    required String staffId,
    String? checkOutMethod,
    String? checkOutTokenId,
  });

  // Dieu chinh slot thu cong co audit trail
  Future<void> manualAdjust({
    required String lotId,
    required String vehicleType,
    required int delta,
    required String staffId,
    String? reason,
  });

  // Cap nhat so cho trong cho 1 loai xe
  Future<void> updateVehicleTypeSlots({
    required String lotId,
    required String vehicleTypeId,
    required int delta,
  });
}
