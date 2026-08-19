import '../../repositories/parking_repository.dart';

class CheckOutUseCase {
  final ParkingRepository repository;

  CheckOutUseCase(this.repository);

  Future<void> call({
    required String lotId,
    required String sessionId,
    required String vehicleType,
    required String staffId,
  }) async {
    await repository.checkOut(
      lotId: lotId,
      sessionId: sessionId,
      vehicleType: vehicleType,
      staffId: staffId,
    );
  }
}
