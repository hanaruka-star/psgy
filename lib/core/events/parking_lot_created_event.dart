import 'package:parking_link/core/events/domain_event.dart';

/// Emitted when a new parking lot is registered in the system.
class ParkingLotCreatedEvent extends DomainEvent {
  final String lotId;
  final String lotName;
  final bool isRealtime;

  ParkingLotCreatedEvent({
    required this.lotId,
    required this.lotName,
    this.isRealtime = false,
    super.occurredAt,
  });
}
