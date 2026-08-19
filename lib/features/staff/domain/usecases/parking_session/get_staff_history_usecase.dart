import 'dart:async';

import 'package:parking_link/features/parking/domain/entities/history_item_entity.dart';
import 'package:parking_link/features/parking/domain/entities/parking_session_entity.dart';
import 'package:parking_link/features/staff/domain/entities/manual_adjustment_entity.dart';
import 'package:parking_link/features/staff/domain/repositories/staff_repository.dart';

class GetStaffHistoryUseCase {
  final StaffRepository _repository;

  GetStaffHistoryUseCase(this._repository);

  Stream<List<HistoryItemEntity>> call(
    String lotId, {
    int sessionLimit = 50,
    int adjustmentLimit = 20,
  }) {
    return Stream.multi((controller) {
      List<ParkingSessionEntity> latestSessions = const [];
      List<ManualAdjustmentEntity> latestAdjustments = const [];

      void emitMerged() {
        controller.add(
          mergeHistoryItems(
            sessions: latestSessions,
            adjustments: latestAdjustments,
          ),
        );
      }

      final sessionSub = _repository
          .watchRecentSessions(
            lotId: lotId,
            limit: sessionLimit,
          )
          .listen(
            (sessions) {
              latestSessions = sessions;
              emitMerged();
            },
            onError: controller.addError,
          );

      final adjustmentSub = _repository
          .watchRecentAdjustments(
            lotId: lotId,
            limit: adjustmentLimit,
          )
          .listen(
            (adjustments) {
              latestAdjustments = adjustments;
              emitMerged();
            },
            onError: controller.addError,
          );

      controller.onCancel = () async {
        await sessionSub.cancel();
        await adjustmentSub.cancel();
      };
    });
  }

  List<HistoryItemEntity> mergeHistoryItems({
    required List<ParkingSessionEntity> sessions,
    required List<ManualAdjustmentEntity> adjustments,
  }) {
    final items = <HistoryItemEntity>[
      ..._sessionEventsToHistoryItems(sessions),
      ..._adjustmentsToHistoryItems(adjustments),
    ];
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return items;
  }

  List<HistoryItemEntity> _sessionEventsToHistoryItems(
    List<ParkingSessionEntity> sessions,
  ) {
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

      if (session.checkedOutAt != null) {
        items.add(
          HistoryItemEntity(
            id: '${session.id}_check_out',
            action: HistoryActionEntity.checkOut,
            vehiclePlate: session.vehiclePlate,
            vehicleType: session.vehicleType,
            timestamp: session.checkedOutAt!,
            delta: null,
            reason: null,
          ),
        );
      }
    }
    return items;
  }

  List<HistoryItemEntity> _adjustmentsToHistoryItems(
    List<ManualAdjustmentEntity> adjustments,
  ) {
    return adjustments
        .map(
          (adjustment) => HistoryItemEntity(
            id: adjustment.id,
            action: HistoryActionEntity.manual,
            vehiclePlate: null,
            vehicleType: adjustment.vehicleType,
            timestamp: adjustment.createdAt,
            delta: adjustment.delta,
            reason: adjustment.reason,
          ),
        )
        .toList(growable: false);
  }
}
