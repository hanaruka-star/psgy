import 'package:flutter_test/flutter_test.dart';
import 'package:parking_link/features/user/domain/entities/qr_token.dart';

QrToken _token({
  required DateTime expiresAt,
  bool used = false,
}) {
  return QrToken(
    tokenId: 'token-1',
    userId: 'user-1',
    vehicleId: 'vehicle-1',
    plate: '51A-12345',
    vehiclePhotoUrl: 'https://example.com/photo.jpg',
    userPhone: '090***1234',
    createdAt: DateTime.now(),
    expiresAt: expiresAt,
    used: used,
  );
}

void main() {
  group('QrToken', () {
    test('expiresAt in the past means isExpired is true', () {
      final token = _token(
        expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
      );

      expect(token.isExpired, isTrue);
    });

    test('expiresAt in the future means isExpired is false', () {
      final token = _token(
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );

      expect(token.isExpired, isFalse);
    });

    test('unused and not expired means isValid is true', () {
      final token = _token(
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        used: false,
      );

      expect(token.isValid, isTrue);
    });

    test('used token means isValid is false', () {
      final token = _token(
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        used: true,
      );

      expect(token.isValid, isFalse);
    });
  });
}
