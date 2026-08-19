import 'package:psgy/features/parking/data/models/parking_session_model.dart';
import 'package:psgy/features/parking/domain/entities/history_item_entity.dart';
import 'package:psgy/features/parking/domain/entities/parking_session_entity.dart';

import 'parking_session_mapper.dart';

class HistoryItemMapper {
  const HistoryItemMapper._();

  static List<HistoryItemEntity> fromSessionEntity(
    ParkingSessionEntity session,
  ) {
    final items = <HistoryItemEntity>[
      HistoryItemEntity(
        id: '${session.id}_check_in',
        action: HistoryActionEntity.checkIn,
        vehiclePlate: session.vehiclePlate,
        vehicleType: session.vehicleType,
        timestamp: session.checkedInAt,
        delta: null,
        reason: null,
      ),
    ];

    final checkedOutAt = session.checkedOutAt;
    if (checkedOutAt != null) {
      items.add(
        HistoryItemEntity(
          id: '${session.id}_check_out',
          action: HistoryActionEntity.checkOut,
          vehiclePlate: session.vehiclePlate,
          vehicleType: session.vehicleType,
          timestamp: checkedOutAt,
          delta: null,
          reason: null,
        ),
      );
    }

    return items;
  }

  static List<HistoryItemEntity> fromSessionModel(ParkingSessionModel model) {
    return fromSessionEntity(ParkingSessionMapper.toEntity(model));
  }

  static HistoryItemEntity fromManualAdjustmentMap(
    Map<String, dynamic> adjustment,
  ) {
    final createdAt = _parseDateTime(adjustment['createdAt']);
    if (createdAt == null) {
      throw ArgumentError('Manual adjustment is missing a valid createdAt');
    }

    return HistoryItemEntity(
      id: (adjustment['id'] as String?) ?? createdAt.toIso8601String(),
      action: HistoryActionEntity.manual,
      vehiclePlate: null,
      vehicleType: (adjustment['vehicleType'] as String?) ?? '',
      timestamp: createdAt,
      delta: (adjustment['delta'] as num?)?.toInt(),
      reason: adjustment['reason'] as String?,
    );
  }

  static DateTime? _parseDateTime(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;

    try {
      final dynamic timestamp = value;
      final dateTime = timestamp.toDate();
      if (dateTime is DateTime) {
        return dateTime;
      }
    } catch (_) {
      return null;
    }

    return null;
  }
}
