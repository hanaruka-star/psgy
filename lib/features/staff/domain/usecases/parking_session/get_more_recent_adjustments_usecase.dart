import 'package:psgy/features/staff/domain/entities/manual_adjustment_entity.dart';
import 'package:psgy/features/staff/domain/repositories/staff_repository.dart';

class GetMoreRecentAdjustmentsUseCase {
  final StaffRepository repository;

  GetMoreRecentAdjustmentsUseCase(this.repository);

  Future<List<ManualAdjustmentEntity>> call({
    required String lotId,
    required DateTime startAfterCreatedAt,
    required String startAfterId,
    int limit = 20,
  }) {
    return repository.getMoreRecentAdjustments(
      lotId: lotId,
      startAfterCreatedAt: startAfterCreatedAt,
      startAfterId: startAfterId,
      limit: limit,
    );
  }
}
