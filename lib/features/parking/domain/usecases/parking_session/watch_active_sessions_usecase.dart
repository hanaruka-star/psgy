import '../../entities/parking_session_entity.dart';
import '../../repositories/parking_repository.dart';

class WatchActiveSessionsUseCase {
  final ParkingRepository repository;

  WatchActiveSessionsUseCase(this.repository);

  Stream<List<ParkingSessionEntity>> call({
    required String lotId,
    required String vehicleType,
  }) {
    return repository.watchActiveSessions(
      lotId: lotId,
      vehicleType: vehicleType,
    );
  }
}
