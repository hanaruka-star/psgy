import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_link/core/contracts/i_qr_token_repository.dart';
import 'package:parking_link/core/error/app_exception.dart';
import 'package:parking_link/features/staff/domain/repositories/staff_repository.dart';
import 'package:parking_link/features/staff/domain/usecases/check_in_out/scan_qr_and_check_in_usecase.dart';
import 'package:parking_link/features/user/domain/entities/qr_token.dart';

class MockQrTokenRepository extends Mock implements IQrTokenRepository {}

class MockStaffRepository extends Mock implements StaffRepository {}

QrToken _validToken({bool used = false}) {
  return QrToken(
    tokenId: 'token-1',
    userId: 'user-1',
    vehicleId: 'vehicle-1',
    plate: '51A-12345',
    vehiclePhotoUrl: 'https://example.com/photo.jpg',
    userPhone: '090***1234',
    createdAt: DateTime.now(),
    expiresAt: DateTime.now().add(const Duration(hours: 1)),
    used: used,
  );
}

void main() {
  late MockQrTokenRepository mockQrTokenRepo;
  late MockStaffRepository mockStaffRepo;
  late ScanQrAndCheckInUseCase useCase;

  setUp(() {
    mockQrTokenRepo = MockQrTokenRepository();
    mockStaffRepo = MockStaffRepository();
    useCase = ScanQrAndCheckInUseCase(
      qrTokenRepo: mockQrTokenRepo,
      staffRepo: mockStaffRepo,
    );
  });

  group('ScanQrAndCheckInUseCase', () {
    test('getQrToken returns null throws not-found AppException', () async {
      when(() => mockQrTokenRepo.getQrToken('token-1'))
          .thenAnswer((_) async => null);

      await expectLater(
        useCase.call(
          tokenId: 'token-1',
          lotId: 'lot-1',
          staffId: 'staff-1',
          vehicleType: 'moto',
        ),
        throwsA(
          isA<AppException>().having(
            (error) => error.code,
            'code',
            'not-found',
          ),
        ),
      );
    });

    test('getQrToken returns used token throws used AppException', () async {
      when(() => mockQrTokenRepo.getQrToken('token-1'))
          .thenAnswer((_) async => _validToken(used: true));

      await expectLater(
        useCase.call(
          tokenId: 'token-1',
          lotId: 'lot-1',
          staffId: 'staff-1',
          vehicleType: 'moto',
        ),
        throwsA(
          isA<AppException>().having(
            (error) => error.code,
            'code',
            'used',
          ),
        ),
      );
    });

    test('valid token completes QR token once after check-in', () async {
      const sessionId = 'session-123';
      final token = _validToken();

      when(() => mockQrTokenRepo.getQrToken('token-1'))
          .thenAnswer((_) async => token);
      when(
        () => mockStaffRepo.checkIn(
          lotId: any(named: 'lotId'),
          vehicleType: any(named: 'vehicleType'),
          vehiclePlate: any(named: 'vehiclePlate'),
          staffId: any(named: 'staffId'),
          userId: any(named: 'userId'),
          vehicleId: any(named: 'vehicleId'),
          vehiclePhotoUrl: any(named: 'vehiclePhotoUrl'),
          checkInMethod: any(named: 'checkInMethod'),
        ),
      ).thenAnswer((_) async => sessionId);
      when(
        () => mockQrTokenRepo.completeQrToken(
          tokenId: any(named: 'tokenId'),
          sessionId: any(named: 'sessionId'),
        ),
      ).thenAnswer((_) async {});

      final result = await useCase.call(
        tokenId: 'token-1',
        lotId: 'lot-1',
        staffId: 'staff-1',
        vehicleType: 'moto',
      );

      expect(result.sessionId, sessionId);
      verify(
        () => mockQrTokenRepo.completeQrToken(
          tokenId: 'token-1',
          sessionId: sessionId,
        ),
      ).called(1);
    });
  });
}
