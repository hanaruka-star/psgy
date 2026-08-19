// TODO(DEBT-017 Phase 2): Move QrToken + CheckoutQrToken to core/entities.
import 'package:parking_link/features/user/domain/entities/checkout_qr_token.dart';
import 'package:parking_link/features/user/domain/entities/qr_token.dart';

/// Staff-facing QR token port (check-in + check-out scan flows).
abstract class IQrTokenRepository {
  Future<QrToken?> getQrToken(String tokenId);

  Future<void> completeQrToken({
    required String tokenId,
    required String sessionId,
  });

  Future<CheckoutQrToken?> getCheckoutQrToken(String tokenId);

  Future<void> completeCheckoutQrToken({
    required String tokenId,
    required String checkOutStaffId,
  });
}
