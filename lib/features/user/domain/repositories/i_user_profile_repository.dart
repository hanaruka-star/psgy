import 'package:psgy/features/user/domain/entities/checkout_qr_token.dart';
import 'package:psgy/features/user/domain/entities/qr_token.dart';
import 'package:psgy/features/user/domain/entities/user_profile.dart';
import 'package:psgy/features/user/domain/entities/user_vehicle.dart';

abstract class IUserProfileRepository {
  Future<void> sendOtp(String phoneNumber);
  Future<String> verifyOtp(String smsCode);

  Future<bool> isProfileExists(String userId);
  Future<void> createProfile(UserProfile profile);
  Future<UserProfile?> getProfile(String userId);

  Future<void> addVehicle(UserVehicle vehicle);
  Future<List<UserVehicle>> getVehicles(String userId);
  Future<void> updateVehicle(UserVehicle vehicle);

  Future<String> uploadVehiclePhoto({
    required String userId,
    required String localPath,
  });

  Future<QrToken> createQrToken({
    required String userId,
    required UserVehicle vehicle,
    required String maskedPhone,
  });

  Stream<QrToken?> watchQrToken(String tokenId);

  Future<void> cancelQrToken(String tokenId);

  Future<QrToken?> getQrToken(String tokenId);

  Future<void> completeQrToken({
    required String tokenId,
    required String sessionId,
  });

  // ── Check-out QR tokens (MOD-12b-4) ────────────────────────────────────────

  /// User creates a check-out token for an active session.
  Future<CheckoutQrToken> createCheckoutQrToken({
    required String sessionId,
    required String userId,
    required int estimatedFee,
  });

  /// Staff reads a check-out token to validate before scanning.
  Future<CheckoutQrToken?> getCheckoutQrToken(String tokenId);

  /// User watches the token to know when staff confirms the check-out.
  Stream<CheckoutQrToken?> watchCheckoutQrToken(String tokenId);

  /// User cancels a check-out token.
  Future<void> cancelCheckoutQrToken(String tokenId);

  /// Staff marks the check-out token as used after a successful check-out.
  Future<void> completeCheckoutQrToken({
    required String tokenId,
    required String checkOutStaffId,
  });
}
