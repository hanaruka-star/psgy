import 'package:psgy/features/user/domain/entities/active_session_info.dart';
import 'package:psgy/features/user/domain/repositories/i_my_parking_repository.dart';

class WatchActiveSessionUseCase {
  const WatchActiveSessionUseCase(this._repository);

  final IMyParkingRepository _repository;

  Stream<ActiveSessionInfo?> call(String userId) =>
      _repository.watchActiveSession(userId);
}
