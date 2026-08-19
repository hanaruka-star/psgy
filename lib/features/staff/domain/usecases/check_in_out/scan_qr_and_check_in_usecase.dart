import 'package:parking_link/core/error/app_exception.dart';
import 'package:parking_link/features/staff/domain/entities/scan_qr_result.dart';
import 'package:parking_link/features/staff/domain/repositories/staff_repository.dart';
import 'package:parking_link/core/contracts/i_qr_token_repository.dart';

class ScanQrAndCheckInUseCase {
  const ScanQrAndCheckInUseCase({
    required IQrTokenRepository qrTokenRepo,
    required StaffRepository staffRepo,
  })  : _qrTokenRepo = qrTokenRepo,
        _staffRepo = staffRepo;

  final IQrTokenRepository _qrTokenRepo;
  final StaffRepository _staffRepo;

  Future<ScanQrResult> call({
    required String tokenId,
    required String lotId,
    required String staffId,
    required String vehicleType,
  }) async {
    final token = await _qrTokenRepo.getQrToken(tokenId);
    if (token == null) {
      throw const AppException('Mã QR không hợp lệ', code: 'not-found');
    }
    if (token.used) {
      throw const AppException('Mã QR đã được dùng', code: 'used');
    }
    if (token.isExpired) {
      throw const AppException('Mã QR đã hết hạn', code: 'expired');
    }

    final sessionId = await _staffRepo.checkIn(
      lotId: lotId,
      vehicleType: vehicleType,
      vehiclePlate: token.plate,
      staffId: staffId,
      userId: token.userId,
      vehicleId: token.vehicleId,
      vehiclePhotoUrl: token.vehiclePhotoUrl,
      checkInMethod: 'qr',
    );

    await _qrTokenRepo.completeQrToken(
      tokenId: tokenId,
      sessionId: sessionId,
    );

    return ScanQrResult(
      sessionId: sessionId,
      plate: token.plate,
      vehiclePhotoUrl: token.vehiclePhotoUrl,
      userPhone: token.userPhone,
    );
  }
}
