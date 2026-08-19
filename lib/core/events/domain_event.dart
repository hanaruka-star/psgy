/// Base type for domain events emitted after successful command use cases.
abstract class DomainEvent {
  final DateTime occurredAt;

  DomainEvent({DateTime? occurredAt}) : occurredAt = occurredAt ?? DateTime.now();
}
