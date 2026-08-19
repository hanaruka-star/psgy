import '../../entities/parking_session_entity.dart';
import '../../repositories/parking_repository.dart';

class WatchParkingSessionUseCase {
  final ParkingRepository repository;

  WatchParkingSessionUseCase(this.repository);

  Stream<ParkingSessionEntity?> call(String sessionId) {
    return repository.watchSession(sessionId);
  }
}
