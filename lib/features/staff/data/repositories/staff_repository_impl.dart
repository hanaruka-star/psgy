import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_link/features/parking/data/mappers/parking_session_mapper.dart';
import 'package:parking_link/features/parking/data/models/parking_session_model.dart';
import 'package:parking_link/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:parking_link/features/parking/domain/entities/parking_session_entity.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:parking_link/features/parking/domain/repositories/parking_repository.dart';
import 'package:parking_link/features/staff/data/mappers/manual_adjustment_mapper.dart';
import 'package:parking_link/features/staff/data/models/manual_adjustment_model.dart';
import 'package:parking_link/features/staff/domain/entities/manual_adjustment_entity.dart';
import 'package:parking_link/features/staff/domain/entities/staff_today_stats_entity.dart';
import 'package:parking_link/features/staff/domain/repositories/staff_repository.dart';

class StaffRepositoryImpl implements StaffRepository {
  final ParkingRepository _parkingRepository;
  final FirebaseFirestore _firestore;

  StaffRepositoryImpl(
    this._parkingRepository, {
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<ParkingLotEntity> watchLot(String lotId) {
    return _parkingRepository.watchLot(lotId);
  }

  @override
  Stream<List<VehicleTypeEntity>> watchVehicleTypes(String lotId) {
    return _parkingRepository.watchVehicleTypes(lotId);
  }

  @override
  Stream<List<ParkingSessionEntity>> watchActiveSessions({
    required String lotId,
    required String vehicleType,
  }) {
    return _parkingRepository.watchActiveSessions(
      lotId: lotId,
      vehicleType: vehicleType,
    );
  }

  @override
  Stream<List<ParkingSessionEntity>> watchRecentSessions({
    required String lotId,
    int limit = 50,
  }) {
    return _firestore
        .collection('parking_sessions')
        .where('lotId', isEqualTo: lotId)
        .where('status', whereIn: const ['active', 'completed'])
        .orderBy('checkedInAt', descending: true)
        .orderBy(FieldPath.documentId, descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ParkingSessionMapper.toEntity(
                  ParkingSessionModel.fromFirestore(doc),
                ),
              )
              .toList(growable: false),
        );
  }

  @override
  Stream<StaffTodayStatsEntity> watchTodayStats({
    required String lotId,
    required DateTime dayStart,
  }) {
    return Stream.multi((controller) {
      var checkIns = 0;
      var checkOuts = 0;
      var hasCheckInSnapshot = false;
      var hasCheckOutSnapshot = false;

      void emitIfReady() {
        if (!hasCheckInSnapshot || !hasCheckOutSnapshot) return;
        controller.add(
          StaffTodayStatsEntity(
            checkIns: checkIns,
            checkOuts: checkOuts,
          ),
        );
      }

      final checkInSub = _firestore
          .collection('parking_sessions')
          .where('lotId', isEqualTo: lotId)
          .where(
            'checkedInAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart),
          )
          .orderBy('checkedInAt', descending: true)
          .snapshots()
          .listen(
        (snapshot) {
          checkIns = snapshot.docs.length;
          hasCheckInSnapshot = true;
          emitIfReady();
        },
        onError: controller.addError,
      );

      final checkOutSub = _firestore
          .collection('parking_sessions')
          .where('lotId', isEqualTo: lotId)
          .where('status', isEqualTo: 'completed')
          .where(
            'checkedOutAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart),
          )
          .orderBy('checkedOutAt', descending: true)
          .snapshots()
          .listen(
        (snapshot) {
          checkOuts = snapshot.docs.length;
          hasCheckOutSnapshot = true;
          emitIfReady();
        },
        onError: controller.addError,
      );

      controller.onCancel = () async {
        await checkInSub.cancel();
        await checkOutSub.cancel();
      };
    });
  }

  @override
  Stream<List<ManualAdjustmentEntity>> watchRecentAdjustments({
    required String lotId,
    int limit = 20,
  }) {
    return _firestore
        .collection('parking_lots')
        .doc(lotId)
        .collection('manual_adjustments')
        .orderBy('createdAt', descending: true)
        .orderBy(FieldPath.documentId, descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ManualAdjustmentMapper.toEntity(
                  ManualAdjustmentModel.fromFirestore(doc, lotId),
                ),
              )
              .toList(growable: false),
        );
  }

  @override
  Future<List<ParkingSessionEntity>> getMoreRecentSessions({
    required String lotId,
    required DateTime startAfterCheckedInAt,
    required String startAfterId,
    int limit = 50,
  }) async {
    final snapshot = await _firestore
        .collection('parking_sessions')
        .where('lotId', isEqualTo: lotId)
        .where('status', whereIn: const ['active', 'completed'])
        .orderBy('checkedInAt', descending: true)
        .orderBy(FieldPath.documentId, descending: true)
        .startAfter([
          Timestamp.fromDate(startAfterCheckedInAt),
          startAfterId,
        ])
        .limit(limit)
        .get();

    return snapshot.docs
        .map(
          (doc) => ParkingSessionMapper.toEntity(
            ParkingSessionModel.fromFirestore(doc),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<List<ManualAdjustmentEntity>> getMoreRecentAdjustments({
    required String lotId,
    required DateTime startAfterCreatedAt,
    required String startAfterId,
    int limit = 20,
  }) async {
    final snapshot = await _firestore
        .collection('parking_lots')
        .doc(lotId)
        .collection('manual_adjustments')
        .orderBy('createdAt', descending: true)
        .orderBy(FieldPath.documentId, descending: true)
        .startAfter([
          Timestamp.fromDate(startAfterCreatedAt),
          startAfterId,
        ])
        .limit(limit)
        .get();

    return snapshot.docs
        .map(
          (doc) => ManualAdjustmentMapper.toEntity(
            ManualAdjustmentModel.fromFirestore(doc, lotId),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<String> checkIn({
    required String lotId,
    required String vehicleType,
    required String vehiclePlate,
    required String staffId,
    String? userId,
    String? vehicleId,
    String? vehiclePhotoUrl,
    String? checkInMethod,
  }) {
    return _parkingRepository.checkIn(
      lotId: lotId,
      vehicleType: vehicleType,
      vehiclePlate: vehiclePlate,
      staffId: staffId,
      userId: userId,
      vehicleId: vehicleId,
      vehiclePhotoUrl: vehiclePhotoUrl,
      checkInMethod: checkInMethod,
    );
  }

  @override
  Future<void> checkOut({
    required String lotId,
    required String sessionId,
    required String vehicleType,
    required String staffId,
    String? checkOutMethod,
    String? checkOutTokenId,
  }) {
    return _parkingRepository.checkOut(
      lotId: lotId,
      sessionId: sessionId,
      vehicleType: vehicleType,
      staffId: staffId,
      checkOutMethod: checkOutMethod,
      checkOutTokenId: checkOutTokenId,
    );
  }

  @override
  Future<void> manualAdjust({
    required String lotId,
    required String vehicleType,
    required int delta,
    required String staffId,
    String? reason,
  }) {
    return _parkingRepository.manualAdjust(
      lotId: lotId,
      vehicleType: vehicleType,
      delta: delta,
      staffId: staffId,
      reason: reason,
    );
  }
}
