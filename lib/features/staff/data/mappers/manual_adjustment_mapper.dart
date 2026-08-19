import 'package:parking_link/features/staff/data/models/manual_adjustment_model.dart';
import 'package:parking_link/features/staff/domain/entities/manual_adjustment_entity.dart';

class ManualAdjustmentMapper {
  const ManualAdjustmentMapper._();

  static ManualAdjustmentEntity toEntity(ManualAdjustmentModel model) {
    return ManualAdjustmentEntity(
      id: model.id,
      lotId: model.lotId,
      vehicleType: model.vehicleType,
      delta: model.delta,
      reason: model.reason,
      staffId: model.staffId,
      createdAt: model.createdAt,
    );
  }
}
