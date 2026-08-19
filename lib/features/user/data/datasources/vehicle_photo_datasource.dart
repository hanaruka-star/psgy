import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class IVehiclePhotoDatasource {
  Future<String> uploadPhoto({
    required String userId,
    required String localPath,
  });
}

class VehiclePhotoDatasourceImpl implements IVehiclePhotoDatasource {
  VehiclePhotoDatasourceImpl({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  @override
  Future<String> uploadPhoto({
    required String userId,
    required String localPath,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage.ref('vehicle_photos/$userId/$timestamp.jpg');
    await ref.putFile(File(localPath));
    return ref.getDownloadURL();
  }
}
