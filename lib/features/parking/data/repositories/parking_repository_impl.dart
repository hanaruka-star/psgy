import 'dart:async';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:psgy/core/error/app_exception.dart';
import 'package:psgy/core/error/error_mapper.dart';
import 'package:psgy/core/network/connectivity_service.dart';
import 'package:psgy/core/services/monitoring_service.dart';
import 'package:psgy/features/parking/data/datasources/parking_local_datasource.dart';
import 'package:psgy/features/parking/data/mappers/parking_lot_mapper.dart';
import 'package:psgy/features/parking/data/mappers/parking_session_mapper.dart';
import 'package:psgy/features/parking/data/mappers/vehicle_type_mapper.dart';
import 'package:psgy/features/parking/data/models/parking_lot_model.dart';
import 'package:psgy/features/parking/data/models/parking_session_model.dart';
import 'package:psgy/features/parking/data/models/parking_slot_model.dart';
import 'package:psgy/features/parking/data/models/vehicle_type_model.dart';
import 'package:psgy/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:psgy/features/parking/domain/entities/parking_session_entity.dart';
import 'package:psgy/features/parking/domain/entities/parking_slot_entity.dart';
import 'package:psgy/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:psgy/features/parking/domain/repositories/parking_repository.dart';

class ParkingRepositoryImpl implements ParkingRepository {
  final FirebaseFirestore _firestore;
  final ParkingLocalDataSource? _local;
  final ConnectivityService? _connectivity;
  final MonitoringService? _monitoring;

  ParkingRepositoryImpl(
    this._firestore, {
    ParkingLocalDataSource? localDataSource,
    ConnectivityService? connectivityService,
    MonitoringService? monitoring,
  })  : _local = localDataSource,
        _connectivity = connectivityService,
        _monitoring = monitoring;

  bool get _isOnline => _connectivity?.currentStatus ?? true;

  @override
  Future<List<ParkingLotEntity>> getNearbyLots(
    double lat,
    double lng,
    double radiusKm,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('parking_lots')
          .where('status', isEqualTo: 'open')
          .get();

      final lotsWithDistance = snapshot.docs
          .map((doc) => ParkingLotModel.fromFirestore(doc))
          .map((model) {
            final distanceKm = _calculateDistanceKm(
              lat,
              lng,
              model.lat,
              model.lng,
            );
            return (model: model, distanceKm: distanceKm);
          })
          .where((item) => item.distanceKm <= radiusKm)
          .toList();

      lotsWithDistance.sort(
        (a, b) => a.distanceKm.compareTo(b.distanceKm),
      );

      return lotsWithDistance
          .map((item) => ParkingLotMapper.toEntity(item.model))
          .toList();
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Stream<List<ParkingLotEntity>> watchAllLots() {
    final local = _local;
    if (local == null) {
      return _watchAllLotsFromNetwork();
    }

    return Stream.multi((controller) async {
      StreamSubscription<List<ParkingLotEntity>>? subscription;

      try {
        final cached = await local.getAllLots();
        if (cached.isNotEmpty) {
          controller.add(cached);
        }
      } catch (_) {}

      if (!_isOnline) {
        await controller.close();
        return;
      }

      subscription = _watchAllLotsFromNetwork().listen(
        (lots) {
          unawaited(local.upsertLots(lots));
          controller.add(lots);
        },
        onError: controller.addError,
        onDone: controller.close,
        cancelOnError: false,
      );

      controller.onCancel = () => subscription?.cancel();
    });
  }

  Stream<List<ParkingLotEntity>> _watchAllLotsFromNetwork() {
    try {
      return _firestore.collection('parking_lots').snapshots().map((snapshot) {
        try {
          return snapshot.docs
              .map(
                (doc) => ParkingLotMapper.toEntity(
                  ParkingLotModel.fromFirestore(doc),
                ),
              )
              .toList();
        } catch (e) {
          throw mapFirebaseException(e);
        }
      });
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Stream<ParkingLotEntity> watchLot(String lotId) {
    try {
      return _firestore
          .collection('parking_lots')
          .doc(lotId)
          .snapshots()
          .map((doc) {
        try {
          if (!doc.exists) {
            throw UnknownException('Parking lot "$lotId" does not exist');
          }
          return ParkingLotMapper.toEntity(
            ParkingLotModel.fromFirestore(doc),
          );
        } catch (e) {
          throw mapFirebaseException(e);
        }
      });
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Stream<List<ParkingSlotEntity>> watchSlots(String lotId) {
    try {
      return _firestore
          .collection('parking_lots')
          .doc(lotId)
          .collection('slots')
          .snapshots()
          .map((snapshot) {
        try {
          return snapshot.docs
              .map((doc) => ParkingSlotModel.fromFirestore(doc).toEntity())
              .toList();
        } catch (e) {
          throw mapFirebaseException(e);
        }
      });
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Stream<List<VehicleTypeEntity>> watchVehicleTypes(String lotId) {
    final local = _local;
    if (local == null) {
      return _watchVehicleTypesFromNetwork(lotId);
    }

    return Stream.multi((controller) async {
      StreamSubscription<List<VehicleTypeEntity>>? subscription;

      try {
        final cached = await local.getVehicleTypes(lotId);
        if (cached.isNotEmpty) {
          controller.add(cached);
        }
      } catch (_) {}

      if (!_isOnline) {
        await controller.close();
        return;
      }

      subscription = _watchVehicleTypesFromNetwork(lotId).listen(
        (vehicleTypes) {
          unawaited(
            local.upsertVehicleTypes(
              lotId: lotId,
              vehicleTypes: vehicleTypes,
            ),
          );
          controller.add(vehicleTypes);
        },
        onError: controller.addError,
        onDone: controller.close,
        cancelOnError: false,
      );

      controller.onCancel = () => subscription?.cancel();
    });
  }

  Stream<List<VehicleTypeEntity>> _watchVehicleTypesFromNetwork(String lotId) {
    try {
      return _firestore
          .collection('parking_lots')
          .doc(lotId)
          .collection('vehicle_types')
          .snapshots()
          .map((snapshot) {
        try {
          return snapshot.docs
              .map(
                (doc) => VehicleTypeMapper.toEntity(
                  VehicleTypeModel.fromFirestore(doc),
                ),
              )
              .toList();
        } catch (e) {
          throw mapFirebaseException(e);
        }
      });
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Future<List<VehicleTypeEntity>> fetchVehicleTypes(String lotId) async {
    try {
      final snapshot = await _firestore
          .collection('parking_lots')
          .doc(lotId)
          .collection('vehicle_types')
          .get();

      final vehicleTypes = snapshot.docs
          .map(
            (doc) => VehicleTypeMapper.toEntity(
              VehicleTypeModel.fromFirestore(doc),
            ),
          )
          .toList(growable: false);

      final local = _local;
      if (local != null) {
        await local.upsertVehicleTypes(
          lotId: lotId,
          vehicleTypes: vehicleTypes,
        );
      }

      return vehicleTypes;
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Stream<List<ParkingSessionEntity>> watchActiveSessions({
    required String lotId,
    required String vehicleType,
  }) {
    final local = _local;
    if (local == null) {
      return _watchActiveSessionsFromNetwork(
        lotId: lotId,
        vehicleType: vehicleType,
      );
    }

    return Stream.multi((controller) async {
      StreamSubscription<List<ParkingSessionEntity>>? subscription;

      try {
        final cached = await local.getActiveSessions(
          lotId: lotId,
          vehicleType: vehicleType,
        );
        if (cached.isNotEmpty) {
          controller.add(cached);
        }
      } catch (_) {}

      if (!_isOnline) {
        await controller.close();
        return;
      }

      subscription = _watchActiveSessionsFromNetwork(
        lotId: lotId,
        vehicleType: vehicleType,
      ).listen(
        (sessions) {
          unawaited(local.upsertSessions(sessions));
          controller.add(sessions);
        },
        onError: controller.addError,
        onDone: controller.close,
        cancelOnError: false,
      );

      controller.onCancel = () => subscription?.cancel();
    });
  }

  Stream<List<ParkingSessionEntity>> _watchActiveSessionsFromNetwork({
    required String lotId,
    required String vehicleType,
  }) {
    try {
      return _firestore
          .collection('parking_sessions')
          .where('lotId', isEqualTo: lotId)
          .where('vehicleType', isEqualTo: vehicleType)
          .where('status', isEqualTo: 'active')
          .orderBy('checkedInAt', descending: true)
          .snapshots()
          .map((snapshot) {
        try {
          return snapshot.docs
              .map(
                (doc) => ParkingSessionMapper.toEntity(
                  ParkingSessionModel.fromFirestore(doc),
                ),
              )
              .toList();
        } catch (e) {
          throw mapFirebaseException(e);
        }
      });
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Stream<ParkingSessionEntity?> watchSession(String sessionId) {
    try {
      return _firestore
          .collection('parking_sessions')
          .doc(sessionId)
          .snapshots()
          .map((doc) {
        try {
          if (!doc.exists) return null;
          return ParkingSessionMapper.toEntity(
            ParkingSessionModel.fromFirestore(doc),
          );
        } catch (e) {
          throw mapFirebaseException(e);
        }
      });
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Future<List<ParkingSessionEntity>> getSessions(
    String lotId, {
    int limit = 50,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('parking_sessions')
          .where('lotId', isEqualTo: lotId)
          .orderBy('checkedInAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map(
            (doc) => ParkingSessionMapper.toEntity(
              ParkingSessionModel.fromFirestore(doc),
            ),
          )
          .toList();
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getManualAdjustments(
    String lotId, {
    int limit = 20,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('parking_lots')
          .doc(lotId)
          .collection('manual_adjustments')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    } catch (e) {
      throw mapFirebaseException(e);
    }
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
  }) async {
    await _monitoring?.startTrace('staff_checkin');
    _monitoring?.logBreadcrumb(
      'staff_checkin_started',
      params: {
        'lot_id': lotId,
        'vehicle_type': vehicleType,
      },
    );

    try {
      final lotRef = _firestore.collection('parking_lots').doc(lotId);
      final vehicleTypeRef =
          lotRef.collection('vehicle_types').doc(vehicleType);
      final sessionRef = _firestore.collection('parking_sessions').doc();
      final normalizedPlate = vehiclePlate.trim().toUpperCase();
      final duplicateActiveSessionSnapshot = await _firestore
          .collection('parking_sessions')
          .where('lotId', isEqualTo: lotId)
          .where('vehiclePlate', isEqualTo: normalizedPlate)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();
      if (duplicateActiveSessionSnapshot.docs.isNotEmpty) {
        throw Exception('Xe $normalizedPlate đang trong bãi');
      }

      await _firestore.runTransaction((transaction) async {
        final vehicleTypeSnapshot = await transaction.get(vehicleTypeRef);
        if (!vehicleTypeSnapshot.exists) {
          throw UnknownException(
              'Vehicle type "$vehicleType" in lot "$lotId" was not found');
        }

        final vehicleTypeData = vehicleTypeSnapshot.data() ?? {};
        final availableSlots =
            (vehicleTypeData['availableSlots'] as num?)?.toInt() ?? 0;
        if (availableSlots <= 0) {
          throw const SlotUnavailableException('Không còn slot');
        }

        final method = checkInMethod ?? 'manual';
        transaction.set(sessionRef, {
          'id': sessionRef.id,
          'lotId': lotId,
          'vehicleType': vehicleType,
          'vehiclePlate': normalizedPlate,
          'checkedInAt': FieldValue.serverTimestamp(),
          'status': 'active',
          'staffId': staffId,
          'checkInMethod': method,
          if (userId != null) 'userId': userId,
          if (vehicleId != null) 'vehicleId': vehicleId,
          if (vehiclePhotoUrl != null) 'vehiclePhotoUrl': vehiclePhotoUrl,
          'metadata': {
            'check_in_method': method,
            'check_in_by': 'staff_app',
          },
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        transaction.update(vehicleTypeRef, {
          'availableSlots': FieldValue.increment(-1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });

      _monitoring?.logBreadcrumb(
        'staff_checkin_completed',
        params: {'lot_id': lotId},
      );
      _monitoring?.logEvent('staff_checkin', {
        'lot_id': lotId,
        'vehicle_type': vehicleType,
      });
      return sessionRef.id;
    } catch (e) {
      throw mapFirebaseException(e);
    } finally {
      await _monitoring?.stopTrace('staff_checkin');
    }
  }

  @override
  Future<void> checkOut({
    required String lotId,
    required String sessionId,
    required String vehicleType,
    required String staffId,
    String? checkOutMethod,
    String? checkOutTokenId,
  }) async {
    await _monitoring?.startTrace('staff_checkout');
    _monitoring?.logBreadcrumb(
      'staff_checkout_started',
      params: {
        'lot_id': lotId,
        'session_id': sessionId,
      },
    );

    try {
      final lotRef = _firestore.collection('parking_lots').doc(lotId);
      final sessionRef =
          _firestore.collection('parking_sessions').doc(sessionId);
      final vehicleTypeRef =
          lotRef.collection('vehicle_types').doc(vehicleType);

      await _firestore.runTransaction((transaction) async {
        final sessionSnapshot = await transaction.get(sessionRef);
        if (!sessionSnapshot.exists) {
          throw UnknownException('Session "$sessionId" was not found');
        }
        final vehicleTypeSnapshot = await transaction.get(vehicleTypeRef);
        if (!vehicleTypeSnapshot.exists) {
          throw UnknownException(
              'Vehicle type "$vehicleType" in lot "$lotId" was not found');
        }

        final sessionData = sessionSnapshot.data() ?? {};
        final sessionLotId = (sessionData['lotId'] as String?) ?? '';
        final sessionVehicleType =
            (sessionData['vehicleType'] as String?) ?? '';
        final status = (sessionData['status'] as String?) ?? '';
        if (sessionLotId != lotId || sessionVehicleType != vehicleType) {
          throw UnknownException(
            'Session "$sessionId" does not match lot "$lotId" and vehicle type "$vehicleType"',
          );
        }
        if (status != 'active') {
          throw UnknownException('Session "$sessionId" is not active');
        }
        final vehicleTypeData = vehicleTypeSnapshot.data() ?? {};
        final currentAvailable =
            (vehicleTypeData['availableSlots'] as num?)?.toInt() ?? 0;
        final totalSlots = (vehicleTypeData['totalSlots'] as num?)?.toInt() ?? 0;
        final clampedAvailable = math.min(currentAvailable + 1, totalSlots);

        transaction.update(sessionRef, {
          'status': 'completed',
          'checkedOutAt': FieldValue.serverTimestamp(),
          'checkOutStaffId': staffId,
          'checkOutMethod': checkOutMethod ?? 'manual',
          if (checkOutTokenId != null) 'checkOutTokenId': checkOutTokenId,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        transaction.update(vehicleTypeRef, {
          'availableSlots': clampedAvailable,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });

      _monitoring?.logBreadcrumb(
        'staff_checkout_completed',
        params: {
          'lot_id': lotId,
          'session_id': sessionId,
        },
      );
      _monitoring?.logEvent('staff_checkout', {
        'lot_id': lotId,
        'session_id': sessionId,
      });
    } catch (e) {
      throw mapFirebaseException(e);
    } finally {
      await _monitoring?.stopTrace('staff_checkout');
    }
  }

  @override
  Future<void> manualAdjust({
    required String lotId,
    required String vehicleType,
    required int delta,
    required String staffId,
    String? reason,
  }) async {
    if (delta != 1 && delta != -1) {
      throw ArgumentError('delta must be +1 or -1');
    }

    try {
      final lotRef = _firestore.collection('parking_lots').doc(lotId);
      final vehicleTypeRef =
          lotRef.collection('vehicle_types').doc(vehicleType);
      final adjustmentRef = lotRef.collection('manual_adjustments').doc();
      final normalizedReason = reason?.trim();

      await _firestore.runTransaction((transaction) async {
        final vehicleTypeSnapshot = await transaction.get(vehicleTypeRef);
        if (!vehicleTypeSnapshot.exists) {
          throw UnknownException(
              'Vehicle type "$vehicleType" in lot "$lotId" was not found');
        }

        final vehicleTypeData = vehicleTypeSnapshot.data() ?? {};
        final availableSlots =
            (vehicleTypeData['availableSlots'] as num?)?.toInt() ?? 0;
        final totalSlots =
            (vehicleTypeData['totalSlots'] as num?)?.toInt() ?? 0;

        if (delta == -1 && availableSlots == 0) {
          throw const SlotUnavailableException(
            'Không thể bớt slot vì đã hết chỗ trống',
          );
        }
        if (delta == 1 && availableSlots == totalSlots) {
          throw const SlotUnavailableException(
            'Không thể thêm slot vì số chỗ trống đã tối đa',
          );
        }
        final newAvailable = delta == 1
            ? math.min(availableSlots + 1, totalSlots)
            : math.max(availableSlots - 1, 0);

        transaction.update(vehicleTypeRef, {
          'availableSlots': newAvailable,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        transaction.set<Map<String, dynamic>>(adjustmentRef, {
          'id': adjustmentRef.id,
          'vehicleType': vehicleType,
          'delta': delta,
          'reason': normalizedReason == null || normalizedReason.isEmpty
              ? null
              : normalizedReason,
          'staffId': staffId,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Future<void> updateVehicleTypeSlots({
    required String lotId,
    required String vehicleTypeId,
    required int delta,
  }) async {
    try {
      final vehicleTypeRef = _firestore
          .collection('parking_lots')
          .doc(lotId)
          .collection('vehicle_types')
          .doc(vehicleTypeId);

      await _firestore.runTransaction((transaction) async {
        final vehicleTypeSnapshot = await transaction.get(vehicleTypeRef);
        if (!vehicleTypeSnapshot.exists) {
          throw UnknownException(
              'Vehicle type "$vehicleTypeId" in lot "$lotId" was not found');
        }

        transaction.update(vehicleTypeRef, {
          'availableSlots': FieldValue.increment(delta),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  double _calculateDistanceKm(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const earthRadiusKm = 6371.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _toRadians(double degree) => degree * math.pi / 180;
}
