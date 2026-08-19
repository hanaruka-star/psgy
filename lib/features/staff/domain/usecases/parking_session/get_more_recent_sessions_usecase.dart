import 'package:psgy/features/parking/domain/entities/parking_session_entity.dart';
import 'package:psgy/features/staff/domain/repositories/staff_repository.dart';

class GetMoreRecentSessionsUseCase {
  final StaffRepository repository;

  GetMoreRecentSessionsUseCase(this.repository);

  Future<List<ParkingSessionEntity>> call({
    required String lotId,
    required DateTime startAfterCheckedInAt,
    required String startAfterId,
    int limit = 50,
  }) {
    return repository.getMoreRecentSessions(
      lotId: lotId,
      startAfterCheckedInAt: startAfterCheckedInAt,
      startAfterId: startAfterId,
      limit: limit,
    );
  }
}
