import 'package:psgy/features/staff/domain/entities/manual_adjustment_entity.dart';
import 'package:psgy/features/staff/domain/repositories/staff_repository.dart';

class WatchRecentAdjustmentsUseCase {
  final StaffRepository repository;

  WatchRecentAdjustmentsUseCase(this.repository);

  Stream<List<ManualAdjustmentEntity>> call({
    required String lotId,
    int limit = 20,
  }) {
    return repository.watchRecentAdjustments(
      lotId: lotId,
      limit: limit,
    );
  }
}
