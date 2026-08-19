import 'package:psgy/core/events/domain_event.dart';

typedef DomainEventListener<T extends DomainEvent> = void Function(T event);

/// Simple in-memory pub/sub bus for domain events.
///
/// Handlers subscribe by event type; command use cases publish after
/// persistence succeeds. Wiring lives in `core/di/event_providers.dart`.
class DomainEventBus {
  final Map<Type, List<void Function(DomainEvent)>> _listeners = {};

  void subscribe<T extends DomainEvent>(DomainEventListener<T> listener) {
    _listeners.putIfAbsent(T, () => []).add((event) {
      listener(event as T);
    });
  }

  void publish(DomainEvent event) {
    final listeners = _listeners[event.runtimeType];
    if (listeners == null) return;
    for (final listener in List<void Function(DomainEvent)>.from(listeners)) {
      listener(event);
    }
  }

  void clear() => _listeners.clear();
}
