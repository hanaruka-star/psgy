import 'package:parking_link/features/parking/domain/entities/history_item_entity.dart';
import 'package:parking_link/features/staff/presentation/models/history_item_ui_model.dart';

class HistoryItemUiMapper {
  const HistoryItemUiMapper._();

  static HistoryItemUiModel toUiModel(HistoryItemEntity entity) {
    return HistoryItemUiModel(
      id: entity.id,
      action: _toUiAction(entity.action),
      vehiclePlate: entity.vehiclePlate,
      vehicleType: entity.vehicleType,
      timestamp: entity.timestamp,
      delta: entity.delta,
      reason: entity.reason,
    );
  }

  static List<HistoryItemUiModel> toUiModels(List<HistoryItemEntity> entities) {
    return entities.map(toUiModel).toList();
  }

  static HistoryAction _toUiAction(HistoryActionEntity action) {
    switch (action) {
      case HistoryActionEntity.checkIn:
        return HistoryAction.checkIn;
      case HistoryActionEntity.checkOut:
        return HistoryAction.checkOut;
      case HistoryActionEntity.manual:
        return HistoryAction.manual;
    }
  }
}
