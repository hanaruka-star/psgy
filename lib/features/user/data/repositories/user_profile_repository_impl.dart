import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:psgy/core/error/app_exception.dart';
import 'package:psgy/features/user/data/datasources/user_profile_remote_datasource.dart';
import 'package:psgy/features/user/data/datasources/vehicle_photo_datasource.dart';
import 'package:psgy/features/user/domain/entities/checkout_qr_token.dart';
import 'package:psgy/features/user/domain/entities/qr_token.dart';
import 'package:psgy/features/user/domain/entities/user_profile.dart';
import 'package:psgy/features/user/domain/entities/user_vehicle.dart';
import 'package:psgy/core/contracts/i_qr_token_repository.dart';
import 'package:psgy/features/user/domain/repositories/i_user_profile_repository.dart';
import 'package:uuid/uuid.dart';

class UserProfileRepositoryImpl
    implements IUserProfileRepository, IQrTokenRepository {
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

  @override
  Future<QrToken> createQrToken({
    required String userId,
    required UserVehicle vehicle,
    required String maskedPhone,
  }) async {
    final tokenId = const Uuid().v4();
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(minutes: 3));
    final data = {
      'tokenId': tokenId,
      'userId': userId,
      'vehicleId': vehicle.vehicleId,
      'plate': vehicle.plate,
      'vehiclePhotoUrl': vehicle.photoUrl,
      'userPhone': maskedPhone,
      'lotId': null,
      'createdAt': Timestamp.fromDate(now),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'used': false,
      'usedAt': null,
      'sessionId': null,
    };
    await _remoteDatasource.createQrToken(data);
    return QrToken(
      tokenId: tokenId,
      userId: userId,
      vehicleId: vehicle.vehicleId,
      plate: vehicle.plate,
      vehiclePhotoUrl: vehicle.photoUrl,
      userPhone: maskedPhone,
      createdAt: now,
      expiresAt: expiresAt,
      used: false,
    );
  }

  @override
  Stream<QrToken?> watchQrToken(String tokenId) {
    return _remoteDatasource.watchQrToken(tokenId).map((data) {
      if (data == null) return null;
      return _mapQrToken(data, tokenId);
    });
  }

  @override
  Future<void> cancelQrToken(String tokenId) async {
    await _remoteDatasource.updateQrToken(tokenId, {
      'used': true,
      'usedAt': Timestamp.now(),
      'cancelledByUser': true,
    });
  }

  @override
  Future<QrToken?> getQrToken(String tokenId) async {
    final data = await _remoteDatasource.getQrToken(tokenId);
    if (data == null) return null;
    return _mapQrToken(data, tokenId);
  }

  @override
  Future<void> completeQrToken({
    required String tokenId,
    required String sessionId,
  }) async {
    await _remoteDatasource.completeQrToken(tokenId, sessionId);
  }

  // ── Check-out QR tokens (MOD-12b-4) ────────────────────────────────────────

  @override
  Future<CheckoutQrToken> createCheckoutQrToken({
    required String sessionId,
    required String userId,
    required int estimatedFee,
  }) async {
    final session = await _remoteDatasource.getParkingSession(sessionId);
    if (session == null) {
      throw const AppException('Phiên gửi xe không tồn tại', code: 'not-found');
    }

    final lotId = (session['lotId'] as String?) ?? '';
    final vehicleType = (session['vehicleType'] as String?) ?? '';
    final plate = (session['vehiclePlate'] as String?) ?? '';
    final checkedInRaw = session['checkedInAt'];
    final checkedInTs =
        checkedInRaw is Timestamp ? checkedInRaw : Timestamp.now();

    final lot = await _remoteDatasource.getParkingLot(lotId);
    final lotName = (lot?['name'] as String?) ?? '';

    final tokenId = const Uuid().v4();
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(minutes: 10));

    final data = <String, dynamic>{
      'tokenId': tokenId,
      'sessionId': sessionId,
      'userId': userId,
      'plate': plate,
      'lotId': lotId,
      'lotName': lotName,
      'vehicleType': vehicleType,
      'estimatedFee': estimatedFee,
      'checkedInAt': checkedInTs,
      'createdAt': Timestamp.fromDate(now),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'used': false,
      'usedAt': null,
      'checkOutStaffId': null,
    };

    await _remoteDatasource.createCheckoutQrToken(tokenId, data);

    return CheckoutQrToken(
      tokenId: tokenId,
      sessionId: sessionId,
      userId: userId,
      plate: plate,
      lotId: lotId,
      lotName: lotName,
      vehicleType: vehicleType,
      estimatedFee: estimatedFee,
      checkedInAt: checkedInTs.toDate(),
      createdAt: now,
      expiresAt: expiresAt,
      used: false,
    );
  }

  @override
  Future<CheckoutQrToken?> getCheckoutQrToken(String tokenId) async {
    final data = await _remoteDatasource.getCheckoutQrToken(tokenId);
    if (data == null) return null;
    return _mapCheckoutQrToken(data, tokenId);
  }

  @override
  Stream<CheckoutQrToken?> watchCheckoutQrToken(String tokenId) {
    return _remoteDatasource.watchCheckoutQrToken(tokenId).map((data) {
      if (data == null) return null;
      return _mapCheckoutQrToken(data, tokenId);
    });
  }

  @override
  Future<void> cancelCheckoutQrToken(String tokenId) async {
    await _remoteDatasource.updateCheckoutQrToken(tokenId, {
      'used': true,
      'usedAt': Timestamp.now(),
      'cancelledByUser': true,
    });
  }

  @override
  Future<void> completeCheckoutQrToken({
    required String tokenId,
    required String checkOutStaffId,
  }) async {
    await _remoteDatasource.updateCheckoutQrToken(tokenId, {
      'used': true,
      'usedAt': FieldValue.serverTimestamp(),
      'checkOutStaffId': checkOutStaffId,
    });
  }

  CheckoutQrToken _mapCheckoutQrToken(
    Map<String, dynamic> data,
    String tokenId,
  ) {
    final checkedInAt = data['checkedInAt'];
    final createdAt = data['createdAt'];
    final expiresAt = data['expiresAt'];
    final usedAt = data['usedAt'];
    return CheckoutQrToken(
      tokenId: (data['tokenId'] as String?) ?? tokenId,
      sessionId: (data['sessionId'] as String?) ?? '',
      userId: (data['userId'] as String?) ?? '',
      plate: (data['plate'] as String?) ?? '',
      lotId: (data['lotId'] as String?) ?? '',
      lotName: (data['lotName'] as String?) ?? '',
      vehicleType: (data['vehicleType'] as String?) ?? '',
      estimatedFee: (data['estimatedFee'] as num?)?.toInt() ?? 0,
      checkedInAt:
          checkedInAt is Timestamp ? checkedInAt.toDate() : DateTime.now(),
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
      expiresAt: expiresAt is Timestamp ? expiresAt.toDate() : DateTime.now(),
      used: data['used'] as bool? ?? false,
      usedAt: usedAt is Timestamp ? usedAt.toDate() : null,
      checkOutStaffId: data['checkOutStaffId'] as String?,
    );
  }

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
      createdAt: createdAt is Timestamp
          ? createdAt.toDate()
          : DateTime.now(),
    );
  }

  QrToken? _mapQrToken(Map<String, dynamic> data, String tokenId) {
    final createdAt = data['createdAt'];
    final expiresAt = data['expiresAt'];
    final usedAt = data['usedAt'];
    return QrToken(
      tokenId: (data['tokenId'] as String?) ?? tokenId,
      userId: (data['userId'] as String?) ?? '',
      vehicleId: (data['vehicleId'] as String?) ?? '',
      plate: (data['plate'] as String?) ?? '',
      vehiclePhotoUrl: (data['vehiclePhotoUrl'] as String?) ?? '',
      userPhone: (data['userPhone'] as String?) ?? '',
      lotId: data['lotId'] as String?,
      createdAt:
          createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
      expiresAt:
          expiresAt is Timestamp ? expiresAt.toDate() : DateTime.now(),
      used: data['used'] as bool? ?? false,
      usedAt: usedAt is Timestamp ? usedAt.toDate() : null,
      sessionId: data['sessionId'] as String?,
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
      createdAt:
          createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
      updatedAt:
          updatedAt is Timestamp ? updatedAt.toDate() : DateTime.now(),
    );
  }
}
