import 'package:parking_link/core/events/domain_event.dart';

/// Emitted when an owner changes lot operational status.
class LotStatusChangedEvent extends DomainEvent {
  final String lotId;
  final String previousStatus;
  final String newStatus;

  LotStatusChangedEvent({
    required this.lotId,
    required this.previousStatus,
    required this.newStatus,
    super.occurredAt,
  });
}
