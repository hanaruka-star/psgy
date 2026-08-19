import 'package:parking_link/core/events/domain_event.dart';

/// Emitted when a surveying lot the user follows becomes active.
class WatchlistLotOpenedEvent extends DomainEvent {
  final String lotId;
  final String lotName;

  WatchlistLotOpenedEvent({
    required this.lotId,
    required this.lotName,
    super.occurredAt,
  });
}
