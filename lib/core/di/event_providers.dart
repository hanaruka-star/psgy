import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/events/domain_event_bus.dart';

final domainEventBusProvider = Provider<DomainEventBus>((ref) {
  final bus = DomainEventBus();
  ref.onDispose(bus.clear);
  return bus;
});
