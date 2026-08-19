import 'package:parking_link/features/parking/domain/entities/parking_session_entity.dart';
import 'package:parking_link/features/staff/domain/repositories/staff_repository.dart';

class WatchStaffActiveSessionsUseCase {
  final StaffRepository repository;

  WatchStaffActiveSessionsUseCase(this.repository);

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
