import 'package:psgy/core/events/domain_event_bus.dart';
import 'package:psgy/core/events/watchlist_lot_opened_event.dart';

/// Publishes [WatchlistLotOpenedEvent] when a followed surveying lot opens.
///
/// Side effects (local notification, badge) are handled by subscribed
/// listeners — see `registerWatchlistEventHandlers`.
class NotifyWatchlistLotOpenedUseCase {
  final DomainEventBus eventBus;

  NotifyWatchlistLotOpenedUseCase(this.eventBus);

  void call({
    required String lotId,
    required String lotName,
  }) {
    eventBus.publish(
      WatchlistLotOpenedEvent(
        lotId: lotId,
        lotName: lotName,
      ),
    );
  }
}
