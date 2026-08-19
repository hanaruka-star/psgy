import '../../repositories/parking_repository.dart';

class ManualAdjustUseCase {
  final ParkingRepository repository;

  ManualAdjustUseCase(this.repository);

  Future<void> call({
    required String lotId,
    required String vehicleType,
    required int delta,
    required String staffId,
    String? reason,
  }) async {
    if (lotId.trim().isEmpty) {
      throw ArgumentError('lotId must not be empty');
    }
    if (vehicleType.trim().isEmpty) {
      throw ArgumentError('vehicleType must not be empty');
    }
    if (delta != 1 && delta != -1) {
      throw ArgumentError('delta must be +1 or -1');
    }
    if (staffId.trim().isEmpty) {
      throw ArgumentError('staffId must not be empty');
    }

    await repository.manualAdjust(
      lotId: lotId,
      vehicleType: vehicleType,
      delta: delta,
      staffId: staffId,
      reason: reason,
    );
  }
}
