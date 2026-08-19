import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:psgy/features/user/domain/entities/active_session_info.dart';

abstract class IMyParkingRemoteDatasource {
  Stream<ActiveSessionInfo?> watchActiveSession(String userId);
}

class MyParkingRemoteDatasourceImpl implements IMyParkingRemoteDatasource {
  const MyParkingRemoteDatasourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<ActiveSessionInfo?> watchActiveSession(String userId) {
    return _firestore
        .collection('parking_sessions')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .limit(1)
        .snapshots()
        .map((snapshot) {
      try {
        if (snapshot.docs.isEmpty) return null;
        final doc = snapshot.docs.first;
        final data = doc.data();
        final checkInTimestamp = data['checkInTime'];

        return ActiveSessionInfo(
          sessionId: doc.id,
          lotId: (data['lotId'] ?? '') as String,
          lotName: (data['lotName'] ?? '') as String,
          lotLatitude: ((data['lotLatitude'] ?? 0) as num).toDouble(),
          lotLongitude: ((data['lotLongitude'] ?? 0) as num).toDouble(),
          checkedInAt: checkInTimestamp is Timestamp
              ? checkInTimestamp.toDate()
              : DateTime.now(),
          vehiclePlate: (data['vehiclePlate'] ?? '') as String,
        );
      } catch (error, stackTrace) {
        log(
          'MyParkingRemoteDatasourceImpl.watchActiveSession mapping warning: $error',
          name: 'MyParkingRemoteDatasourceImpl',
          stackTrace: stackTrace,
        );
        return null;
      }
    });
  }
}
