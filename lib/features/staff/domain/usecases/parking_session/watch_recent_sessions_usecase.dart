import 'package:parking_link/features/parking/domain/entities/parking_session_entity.dart';
import 'package:parking_link/features/staff/domain/repositories/staff_repository.dart';

class WatchRecentSessionsUseCase {
  final StaffRepository repository;

  WatchRecentSessionsUseCase(this.repository);

  Stream<List<ParkingSessionEntity>> call({
    required String lotId,
    int limit = 50,
  }) {
    return repository.watchRecentSessions(
      lotId: lotId,
      limit: limit,
    );
  }
}
