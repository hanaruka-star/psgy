import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:parking_link/core/error/app_exception.dart';
import 'package:parking_link/core/error/error_mapper.dart';
import 'package:parking_link/features/auth/domain/entities/staff_profile_entity.dart';
import 'package:parking_link/features/owner/data/datasources/owner_firestore_datasource.dart';
import 'package:parking_link/features/owner/data/mappers/owner_entity_mappers.dart';
import 'package:parking_link/features/owner/domain/entities/create_lot_input.dart';
import 'package:parking_link/features/owner/domain/entities/owner_vehicle_type_edit.dart';
import 'package:parking_link/features/owner/domain/repositories/owner_repository.dart';
import 'package:parking_link/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';

class OwnerRepositoryImpl implements OwnerRepository {
  final OwnerFirestoreDataSource _dataSource;
  final FirebaseAuth _firebaseAuth;

  OwnerRepositoryImpl(
    FirebaseFirestore firestore, [
    FirebaseAuth? firebaseAuth,
    OwnerFirestoreDataSource? dataSource,
  ])  : _dataSource = dataSource ?? OwnerFirestoreDataSource(firestore),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<ParkingLotEntity> getLot(String lotId) async {
    try {
      final doc = await _dataSource.getLot(lotId);
      if (!doc.exists) {
        throw UnknownException('Parking lot "$lotId" was not found');
      }

      return OwnerLotMapper.toEntity(_dataSource.parkingLotFromFirestore(doc));
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Stream<ParkingLotEntity> watchLot(String lotId) {
    try {
      return _dataSource.watchLot(lotId).map((doc) {
        try {
          if (!doc.exists) {
            throw UnknownException('Parking lot "$lotId" was not found');
          }
          return OwnerLotMapper.toEntity(
              _dataSource.parkingLotFromFirestore(doc));
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
    try {
      return _dataSource.watchVehicleTypes(lotId).map(
        (snapshot) {
          try {
            return snapshot.docs
                .map(
                  (doc) => OwnerVehicleTypeMapper.toEntity(
                    _dataSource.vehicleTypeFromFirestore(doc),
                  ),
                )
                .toList();
          } catch (e) {
            throw mapFirebaseException(e);
          }
        },
      );
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Stream<List<StaffProfileEntity>> watchStaffList(String lotId) {
    try {
      return _dataSource.watchStaffProfilesByLot(lotId).map((snapshot) {
        try {
          return snapshot.docs
              .map(
                (doc) => OwnerStaffProfileMapper.toEntity(
                  _dataSource.staffProfileFromFirestore(doc),
                ),
              )
              .where((profile) => !profile.isOwner)
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
  Future<void> updateLotStatus({
    required String lotId,
    required String status,
  }) async {
    try {
      await _dataSource.updateLotStatus(lotId: lotId, status: status);
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Future<void> updateVehicleType({
    required String lotId,
    required String vehicleTypeId,
    required int totalSlots,
    required String pricingModel,
    required int priceAmount,
    required String changedBy,
  }) async {
    try {
      final vehicleTypeSnapshot = await _dataSource.getVehicleType(
        lotId: lotId,
        vehicleTypeId: vehicleTypeId,
      );

      if (!vehicleTypeSnapshot.exists) {
        throw UnknownException(
          'Vehicle type "$vehicleTypeId" in lot "$lotId" was not found',
        );
      }

      final data = vehicleTypeSnapshot.data() ?? {};
      final oldTotalSlots = (data['totalSlots'] as num?)?.toInt() ?? 0;
      final oldAvailableSlots = (data['availableSlots'] as num?)?.toInt() ?? 0;
      final oldPrice = (data['priceAmount'] as num?)?.toInt() ?? 0;
      final occupiedSlots = math.max(0, oldTotalSlots - oldAvailableSlots);
      final nextAvailableSlots = math.max(0, totalSlots - occupiedSlots);

      final historyRef = _dataSource.newPricingHistoryRef();
      final batch = _dataSource.batch();
      final timestamp = FieldValue.serverTimestamp();
      final vehicleTypeRef =
          _dataSource.vehicleTypesRef(lotId).doc(vehicleTypeId);

      batch.update(vehicleTypeRef, {
        'totalSlots': totalSlots,
        'availableSlots': nextAvailableSlots,
        'pricingModel': pricingModel,
        'priceAmount': priceAmount,
        'updatedAt': timestamp,
      });

      batch.set(historyRef, {
        'lotId': lotId,
        'vehicleTypeId': vehicleTypeId,
        'oldPrice': oldPrice,
        'newPrice': priceAmount,
        'pricingModel': pricingModel,
        'changedBy': changedBy,
        'changedAt': timestamp,
        'createdAt': timestamp,
        'updatedAt': timestamp,
      });

      await batch.commit();
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Future<void> saveLotEdits({
    required String lotId,
    required String status,
    required List<OwnerVehicleTypeEdit> edits,
    required String changedBy,
  }) async {
    try {
      final batch = _dataSource.batch();
      final timestamp = FieldValue.serverTimestamp();

      batch.update(_dataSource.lotRef(lotId), {
        'status': status,
        'updatedAt': timestamp,
      });

      for (final edit in edits) {
        final vehicleTypeSnapshot = await _dataSource.getVehicleType(
          lotId: lotId,
          vehicleTypeId: edit.vehicleTypeId,
        );

        if (!vehicleTypeSnapshot.exists) {
          throw UnknownException(
            'Vehicle type "${edit.vehicleTypeId}" in lot "$lotId" was not found',
          );
        }

        final data = vehicleTypeSnapshot.data() ?? {};
        final oldTotalSlots = (data['totalSlots'] as num?)?.toInt() ?? 0;
        final oldAvailableSlots =
            (data['availableSlots'] as num?)?.toInt() ?? 0;
        final oldPrice = (data['priceAmount'] as num?)?.toInt() ?? 0;
        final occupiedSlots = math.max(0, oldTotalSlots - oldAvailableSlots);
        final nextAvailableSlots = math.max(0, edit.totalSlots - occupiedSlots);

        final vehicleTypeRef =
            _dataSource.vehicleTypesRef(lotId).doc(edit.vehicleTypeId);
        batch.update(vehicleTypeRef, {
          'totalSlots': edit.totalSlots,
          'availableSlots': nextAvailableSlots,
          'pricingModel': edit.pricingModel,
          'priceAmount': edit.priceAmount,
          'updatedAt': timestamp,
        });

        final historyRef = _dataSource.newPricingHistoryRef();
        batch.set(historyRef, {
          'lotId': lotId,
          'vehicleTypeId': edit.vehicleTypeId,
          'oldPrice': oldPrice,
          'newPrice': edit.priceAmount,
          'pricingModel': edit.pricingModel,
          'changedBy': changedBy,
          'changedAt': timestamp,
          'createdAt': timestamp,
          'updatedAt': timestamp,
        });
      }

      await batch.commit();
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Future<void> toggleStaffActive({
    required String uid,
    required bool isActive,
  }) async {
    try {
      final changedBy = _firebaseAuth.currentUser?.uid;
      if (changedBy == null || changedBy.isEmpty) {
        throw const AuthException('Owner user is not signed in');
      }

      final profileRef = _dataSource.staffProfileRef(uid);
      final activityLogRef = _dataSource.staffActivityLogRef(uid);
      final batch = _dataSource.batch();
      final timestamp = FieldValue.serverTimestamp();

      batch.update(profileRef, {
        'isActive': isActive,
        'updatedAt': timestamp,
      });

      batch.set(activityLogRef, {
        'action': isActive ? 'unlocked' : 'locked',
        'changedBy': changedBy,
        'changedAt': timestamp,
        'createdAt': timestamp,
        'updatedAt': timestamp,
      });

      await batch.commit();
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  @override
  Future<void> addStaff({
    required String lotId,
    required String name,
    required String email,
    required String password,
  }) async {
    final appName = 'owner-add-staff-${DateTime.now().microsecondsSinceEpoch}';
    FirebaseApp? secondaryApp;
    User? createdUser;

    try {
      secondaryApp = await Firebase.initializeApp(
        name: appName,
        options: Firebase.app().options,
      );
      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
      final credential = await secondaryAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      createdUser = credential.user;
      if (createdUser == null) {
        throw const AuthException(
          'Staff account was created but user is missing.',
        );
      }

      try {
        final timestamp = FieldValue.serverTimestamp();
        await _dataSource.staffProfileRef(createdUser.uid).set({
          'uid': createdUser.uid,
          'name': name.trim(),
          'email': email.trim(),
          'role': 'staff',
          'lotId': lotId,
          'isActive': true,
          'createdAt': timestamp,
          'updatedAt': timestamp,
        });
      } catch (e) {
        try {
          await createdUser.delete();
        } catch (deleteError) {
          debugPrint(
            'Failed to delete orphan staff auth user after profile create '
            'error: $deleteError',
          );
        }
        throw mapFirebaseException(e);
      }
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseException(e);
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw mapFirebaseException(e);
    } finally {
      if (secondaryApp != null) {
        try {
          await FirebaseAuth.instanceFor(app: secondaryApp).signOut();
          await secondaryApp.delete();
        } catch (e) {
          debugPrint('Failed to dispose secondary staff auth app: $e');
        }
      }
    }
  }

  @override
  Future<String> createLot({
    required CreateLotInput input,
    required String ownerUid,
  }) async {
    try {
      final slug = _slugify(input.name);
      final ts = DateTime.now().millisecondsSinceEpoch;
      final lotId = 'lot_${slug}_$ts';
      final batch1 = _dataSource.batch();
      final timestamp = FieldValue.serverTimestamp();

      final lotRef = _dataSource.lotRef(lotId);
      batch1.set(lotRef, {
        'id': lotId,
        'name': input.name.trim(),
        'address': input.address.trim(),
        'lat': input.lat,
        'lng': input.lng,
        'status': 'open',
        'ownerId': ownerUid,
        'createdAt': timestamp,
        'updatedAt': timestamp,
      });

      for (final vehicleType in input.vehicleTypes) {
        final vehicleTypeRef =
            _dataSource.vehicleTypesRef(lotId).doc(vehicleType.type);
        batch1.set(vehicleTypeRef, {
          'id': vehicleType.type,
          'type': vehicleType.type,
          'totalSlots': vehicleType.totalSlots,
          'availableSlots': vehicleType.totalSlots,
          'pricingModel': vehicleType.pricingModel,
          'priceAmount': vehicleType.priceAmount,
          'monthlyAmount': null,
          'createdAt': timestamp,
          'updatedAt': timestamp,
        });

        final pricingHistoryRef = _dataSource.newPricingHistoryRef();
        batch1.set(pricingHistoryRef, {
          'lotId': lotId,
          'vehicleTypeId': vehicleType.type,
          'oldPrice': 0,
          'newPrice': vehicleType.priceAmount,
          'pricingModel': vehicleType.pricingModel,
          'changedBy': ownerUid,
          'changedAt': timestamp,
          'createdAt': timestamp,
          'updatedAt': timestamp,
        });
      }

      batch1.update(_dataSource.staffProfileRef(ownerUid), {
        'lotId': lotId,
        'updatedAt': timestamp,
      });

      await batch1.commit();
      return lotId;
    } on FirebaseException catch (e) {
      throw mapFirebaseException(e);
    } catch (e) {
      throw mapFirebaseException(e);
    }
  }

  String _slugify(String value) {
    final compact = value.trim().toLowerCase().replaceAll(' ', '_');
    final normalized = compact.replaceAll(RegExp(r'[^a-z0-9_]'), '');
    if (normalized.isEmpty) return 'new_lot';
    return normalized;
  }
}
