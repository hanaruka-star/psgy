import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:psgy/features/auth/data/models/staff_profile_model.dart';
import 'package:psgy/features/parking/data/models/parking_lot_model.dart';
import 'package:psgy/features/parking/data/models/vehicle_type_model.dart';

class OwnerFirestoreDataSource {
  final FirebaseFirestore _firestore;

  OwnerFirestoreDataSource(this._firestore);

  DocumentReference<Map<String, dynamic>> lotRef(String lotId) {
    return _firestore.collection('parking_lots').doc(lotId);
  }

  CollectionReference<Map<String, dynamic>> vehicleTypesRef(String lotId) {
    return lotRef(lotId).collection('vehicle_types');
  }

  CollectionReference<Map<String, dynamic>> get staffProfilesRef {
    return _firestore.collection('staff_profiles');
  }

  CollectionReference<Map<String, dynamic>> get pricingHistoryRef {
    return _firestore.collection('pricing_history');
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getLot(String lotId) {
    return lotRef(lotId).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchLot(String lotId) {
    return lotRef(lotId).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchVehicleTypes(String lotId) {
    return vehicleTypesRef(lotId).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchStaffProfilesByLot(
    String lotId,
  ) {
    return staffProfilesRef.where('lotId', isEqualTo: lotId).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getVehicleType({
    required String lotId,
    required String vehicleTypeId,
  }) {
    return vehicleTypesRef(lotId).doc(vehicleTypeId).get();
  }

  Future<void> updateLotStatus({
    required String lotId,
    required String status,
  }) {
    return lotRef(lotId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  WriteBatch batch() => _firestore.batch();

  DocumentReference<Map<String, dynamic>> newPricingHistoryRef() {
    return pricingHistoryRef.doc();
  }

  DocumentReference<Map<String, dynamic>> staffProfileRef(String uid) {
    return staffProfilesRef.doc(uid);
  }

  DocumentReference<Map<String, dynamic>> staffActivityLogRef(String uid) {
    return staffProfileRef(uid).collection('activity_log').doc();
  }

  ParkingLotModel parkingLotFromFirestore(DocumentSnapshot doc) {
    return ParkingLotModel.fromFirestore(doc);
  }

  VehicleTypeModel vehicleTypeFromFirestore(DocumentSnapshot doc) {
    return VehicleTypeModel.fromFirestore(doc);
  }

  StaffProfileModel staffProfileFromFirestore(DocumentSnapshot doc) {
    return StaffProfileModel.fromFirestore(doc);
  }
}
