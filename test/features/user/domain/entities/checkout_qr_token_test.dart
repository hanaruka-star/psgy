import 'package:flutter_test/flutter_test.dart';
import 'package:psgy/features/user/domain/entities/checkout_qr_token.dart';

CheckoutQrToken _token({
  required DateTime expiresAt,
  required DateTime checkedInAt,
  bool used = false,
}) {
  return CheckoutQrToken(
    tokenId: 'checkout-token-1',
    sessionId: 'session-1',
    userId: 'user-1',
    plate: '51A-12345',
    lotId: 'lot-1',
    lotName: 'CC Dragon',
    vehicleType: 'moto',
    estimatedFee: 5000,
    checkedInAt: checkedInAt,
    createdAt: DateTime.now(),
    expiresAt: expiresAt,
    used: used,
  );
}

void main() {
  group('CheckoutQrToken', () {
    test('expiresAt in the past means isExpired is true', () {
      final token = _token(
        expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
        checkedInAt: DateTime.now().subtract(const Duration(hours: 2)),
      );

      expect(token.isExpired, isTrue);
    });

    test('expiresAt in the future means isExpired is false', () {
      final token = _token(
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        checkedInAt: DateTime.now().subtract(const Duration(hours: 2)),
      );

      expect(token.isExpired, isFalse);
    });

    test('unused and not expired means isValid is true', () {
      final token = _token(
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        checkedInAt: DateTime.now().subtract(const Duration(hours: 2)),
        used: false,
      );

      expect(token.isValid, isTrue);
    });

    test('used token means isValid is false', () {
      final token = _token(
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        checkedInAt: DateTime.now().subtract(const Duration(hours: 2)),
        used: true,
      );

      expect(token.isValid, isFalse);
    });

    test('parkingDuration reflects minutes since checkedInAt', () {
      const minutesAgo = 30;
      final checkedInAt = DateTime.now().subtract(
        const Duration(minutes: minutesAgo),
      );
      final token = _token(
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        checkedInAt: checkedInAt,
      );

      expect(
        token.parkingDuration.inMinutes,
        closeTo(minutesAgo, 1),
      );
    });
  });
}
