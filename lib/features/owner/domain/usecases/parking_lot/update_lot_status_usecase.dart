import 'package:psgy/core/events/domain_event_bus.dart';
import 'package:psgy/core/events/lot_status_changed_event.dart';
import 'package:psgy/core/events/parking_lot_created_event.dart';
import 'package:psgy/features/owner/domain/entities/lot_status.dart';
import 'package:psgy/features/owner/domain/repositories/owner_repository.dart';

class UpdateLotStatusUseCase {
  final OwnerRepository repository;
  final DomainEventBus? eventBus;

  UpdateLotStatusUseCase(this.repository, {this.eventBus});

  Future<void> call({
    required String lotId,
    required String status,
  }) async {
    if (lotId.trim().isEmpty) {
      throw ArgumentError('lotId must not be empty');
    }
    if (!LotStatus.isValid(status)) {
      throw ArgumentError('status must be open or closed');
    }

    final lot = await repository.getLot(lotId);
    final previousStatus = lot.status;

    await repository.updateLotStatus(
      lotId: lotId,
      status: status,
    );

    eventBus?.publish(
      LotStatusChangedEvent(
        lotId: lotId,
        previousStatus: previousStatus,
        newStatus: status,
      ),
    );

    if (previousStatus != LotStatus.open && status == LotStatus.open) {
      eventBus?.publish(
        ParkingLotCreatedEvent(
          lotId: lotId,
          lotName: lot.name,
        ),
      );
    }
  }
}
