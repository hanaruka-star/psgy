import '../../entities/history_item_entity.dart';
import '../../repositories/parking_repository.dart';

class GetHistoryUseCase {
  final ParkingRepository repository;

  GetHistoryUseCase(this.repository);

  Future<List<HistoryItemEntity>> call(String lotId) async {
    if (lotId.trim().isEmpty) {
      throw ArgumentError('lotId must not be empty');
    }

    final sessions = await repository.getSessions(lotId);
    final manualAdjustments = await repository.getManualAdjustments(lotId);

    final items = <HistoryItemEntity>[];

    for (final session in sessions) {
      items.add(
        HistoryItemEntity(
          id: '${session.id}_check_in',
          action: HistoryActionEntity.checkIn,
          vehiclePlate: session.vehiclePlate,
          vehicleType: session.vehicleType,
          timestamp: session.checkedInAt,
          delta: null,
          reason: null,
        ),
      );

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
    }

    for (final adjustment in manualAdjustments) {
      final createdAt = _parseDateTime(adjustment['createdAt']);
      if (createdAt == null) continue;

      items.add(
        HistoryItemEntity(
          id: (adjustment['id'] as String?) ?? createdAt.toIso8601String(),
          action: HistoryActionEntity.manual,
          vehiclePlate: null,
          vehicleType: (adjustment['vehicleType'] as String?) ?? '',
          timestamp: createdAt,
          delta: (adjustment['delta'] as num?)?.toInt(),
          reason: adjustment['reason'] as String?,
        ),
      );
    }

    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return items;
  }

  DateTime? _parseDateTime(Object? value) {
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
