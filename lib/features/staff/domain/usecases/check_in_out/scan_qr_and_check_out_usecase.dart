import 'package:parking_link/core/error/app_exception.dart';
import 'package:parking_link/features/staff/domain/repositories/staff_repository.dart';
import 'package:parking_link/core/contracts/i_qr_token_repository.dart';

class ScanQrAndCheckOutResult {
  final String sessionId;
  final String plate;
  final String lotName;
  final int estimatedFee;
  final Duration parkingDuration;

  const ScanQrAndCheckOutResult({
    required this.sessionId,
    required this.plate,
    required this.lotName,
    required this.estimatedFee,
    required this.parkingDuration,
  });
}

class ScanQrAndCheckOutUseCase {
  const ScanQrAndCheckOutUseCase({
    required IQrTokenRepository qrTokenRepo,
    required StaffRepository staffRepo,
  })  : _qrTokenRepo = qrTokenRepo,
        _staffRepo = staffRepo;

  final IQrTokenRepository _qrTokenRepo;
  final StaffRepository _staffRepo;

  /// Flow:
  /// 1. Load checkout_qr_tokens/{tokenId}
  /// 2. Validate: !used && !isExpired
  /// 3. Check out the session with checkOutMethod='qr', checkOutTokenId=tokenId
  /// 4. Mark the token used (used=true, usedAt, checkOutStaffId)
  Future<ScanQrAndCheckOutResult> call({
    required String tokenId,
    required String lotId,
    required String staffId,
    required String vehicleType,
  }) async {
    final token = await _qrTokenRepo.getCheckoutQrToken(tokenId.trim());
    if (token == null) {
      throw const AppException('Mã QR không hợp lệ', code: 'not-found');
    }
    if (token.used) {
      throw const AppException('Mã QR đã được dùng', code: 'used');
    }
    if (token.isExpired) {
      throw const AppException('Mã QR đã hết hạn', code: 'expired');
    }

    await _staffRepo.checkOut(
      lotId: lotId,
      sessionId: token.sessionId,
      vehicleType: vehicleType,
      staffId: staffId,
      checkOutMethod: 'qr',
      checkOutTokenId: tokenId,
    );

    await _qrTokenRepo.completeCheckoutQrToken(
      tokenId: tokenId,
      checkOutStaffId: staffId,
    );

    return ScanQrAndCheckOutResult(
      sessionId: token.sessionId,
      plate: token.plate,
      lotName: token.lotName,
      estimatedFee: token.estimatedFee,
      parkingDuration: token.parkingDuration,
    );
  }
}
