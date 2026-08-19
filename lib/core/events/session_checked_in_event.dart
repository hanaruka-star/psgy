import 'package:parking_link/core/events/domain_event.dart';

/// Emitted after a vehicle is successfully checked in.
class SessionCheckedInEvent extends DomainEvent {
  final String lotId;
  final String vehicleType;
  final String vehiclePlate;
  final String staffId;

  SessionCheckedInEvent({
    required this.lotId,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.staffId,
    super.occurredAt,
  });
}
