import 'package:parking_link/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:parking_link/features/parking/domain/entities/parking_session_entity.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:parking_link/features/staff/domain/entities/manual_adjustment_entity.dart';
import 'package:parking_link/features/staff/domain/entities/staff_today_stats_entity.dart';

abstract class StaffRepository {
  Stream<ParkingLotEntity> watchLot(String lotId);

  Stream<List<VehicleTypeEntity>> watchVehicleTypes(String lotId);

  Stream<List<ParkingSessionEntity>> watchActiveSessions({
    required String lotId,
    required String vehicleType,
  });

  Stream<List<ParkingSessionEntity>> watchRecentSessions({
    required String lotId,
    int limit = 50,
  });

  Stream<StaffTodayStatsEntity> watchTodayStats({
    required String lotId,
    required DateTime dayStart,
  });

  Stream<List<ManualAdjustmentEntity>> watchRecentAdjustments({
    required String lotId,
    int limit = 20,
  });

  Future<List<ParkingSessionEntity>> getMoreRecentSessions({
    required String lotId,
    required DateTime startAfterCheckedInAt,
    required String startAfterId,
    int limit = 50,
  });

  Future<List<ManualAdjustmentEntity>> getMoreRecentAdjustments({
    required String lotId,
    required DateTime startAfterCreatedAt,
    required String startAfterId,
    int limit = 20,
  });

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

  Future<void> checkOut({
    required String lotId,
    required String sessionId,
    required String vehicleType,
    required String staffId,
    String? checkOutMethod,
    String? checkOutTokenId,
  });

  Future<void> manualAdjust({
    required String lotId,
    required String vehicleType,
    required int delta,
    required String staffId,
    String? reason,
  });
}
