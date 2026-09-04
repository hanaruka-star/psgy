import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:psgy/features/user/data/datasources/user_profile_remote_datasource.dart';
import 'package:psgy/features/user/data/datasources/vehicle_photo_datasource.dart';
import 'package:psgy/features/user/domain/entities/user_profile.dart';
import 'package:psgy/features/user/domain/entities/user_vehicle.dart';
import 'package:psgy/features/user/domain/repositories/i_user_profile_repository.dart';

class UserProfileRepositoryImpl implements IUserProfileRepository {
  const UserProfileRepositoryImpl({
    required IUserProfileRemoteDatasource remoteDatasource,
    required IVehiclePhotoDatasource photoDatasource,
  })  : _remoteDatasource = remoteDatasource,
        _photoDatasource = photoDatasource;

  final IUserProfileRemoteDatasource _remoteDatasource;
  final IVehiclePhotoDatasource _photoDatasource;

  @override
  Future<void> sendOtp(String phoneNumber) =>
      _remoteDatasource.sendOtp(phoneNumber);

  @override
  Future<String> verifyOtp(String smsCode) =>
      _remoteDatasource.verifyOtp(smsCode);

  @override
  Future<bool> isProfileExists(String userId) =>
      _remoteDatasource.isProfileExists(userId);

  @override
  Future<void> createProfile(UserProfile profile) async {
    await _remoteDatasource.createProfile(
      {
        'userId': profile.userId,
        'phoneNumber': profile.phoneNumber,
        'displayName': profile.displayName,
        'createdAt': Timestamp.fromDate(profile.createdAt),
      },
      profile.userId,
    );
  }

  @override
  Future<UserProfile?> getProfile(String userId) async {
    final data = await _remoteDatasource.getProfile(userId);
    if (data == null) return null;
    return _mapProfile(data, userId);
  }

  @override
  Future<void> addVehicle(UserVehicle vehicle) async {
    var photoUrl = vehicle.photoUrl;
    if (!_isRemoteUrl(photoUrl)) {
      photoUrl = await uploadVehiclePhoto(
        userId: vehicle.userId,
        localPath: photoUrl,
      );
    }

    final normalized = _normalizePlate(vehicle.plate);
    final now = DateTime.now();
    await _remoteDatasource.addVehicle({
      'userId': vehicle.userId,
      'plate': vehicle.plate.trim().toUpperCase(),
      'plateNormalized': normalized,
      'photoUrl': photoUrl,
      'isPersonal': vehicle.isPersonal,
      'isDefault': vehicle.isDefault,
      'createdAt': Timestamp.fromDate(vehicle.createdAt),
      'updatedAt': Timestamp.fromDate(now),
    });
  }

  @override
  Future<List<UserVehicle>> getVehicles(String userId) async {
    final rows = await _remoteDatasource.getVehicles(userId);
    final vehicles = rows.map(_mapVehicle).toList();
    vehicles.sort((a, b) {
      if (a.isDefault == b.isDefault) {
        return b.createdAt.compareTo(a.createdAt);
      }
      return a.isDefault ? -1 : 1;
    });
    return vehicles;
  }

  @override
  Future<void> updateVehicle(UserVehicle vehicle) async {
    var photoUrl = vehicle.photoUrl;
    if (!_isRemoteUrl(photoUrl)) {
      photoUrl = await uploadVehiclePhoto(
        userId: vehicle.userId,
        localPath: photoUrl,
      );
    }

    await _remoteDatasource.updateVehicle(
      vehicle.vehicleId,
      {
        'plate': vehicle.plate.trim().toUpperCase(),
        'plateNormalized': _normalizePlate(vehicle.plate),
        'photoUrl': photoUrl,
        'isPersonal': vehicle.isPersonal,
        'isDefault': vehicle.isDefault,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
    );
  }

  @override
  Future<String> uploadVehiclePhoto({
    required String userId,
    required String localPath,
  }) =>
      _photoDatasource.uploadPhoto(userId: userId, localPath: localPath);

  String _normalizePlate(String plate) =>
      plate.trim().toUpperCase().replaceAll(RegExp(r'[\s\.\-]'), '');

  bool _isRemoteUrl(String value) =>
      value.startsWith('http://') || value.startsWith('https://');

  UserProfile _mapProfile(Map<String, dynamic> data, String userId) {
    final createdAt = data['createdAt'];
    return UserProfile(
      userId: (data['userId'] as String?) ?? userId,
      phoneNumber: (data['phoneNumber'] as String?) ?? '',
      displayName: data['displayName'] as String?,
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
    );
  }

  UserVehicle _mapVehicle(Map<String, dynamic> data) {
    final createdAt = data['createdAt'];
    final updatedAt = data['updatedAt'];
    return UserVehicle(
      vehicleId: (data['vehicleId'] as String?) ?? '',
      userId: (data['userId'] as String?) ?? '',
      plate: (data['plate'] as String?) ?? '',
      plateNormalized: (data['plateNormalized'] as String?) ?? '',
      photoUrl: (data['photoUrl'] as String?) ?? '',
      isPersonal: data['isPersonal'] as bool? ?? true,
      isDefault: data['isDefault'] as bool? ?? false,
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
      updatedAt: updatedAt is Timestamp ? updatedAt.toDate() : DateTime.now(),
    );
  }
}
