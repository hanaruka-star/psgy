import 'package:parking_link/core/events/domain_event_bus.dart';
import 'package:parking_link/core/events/session_checked_in_event.dart';
import 'package:parking_link/features/parking/domain/repositories/parking_repository.dart';

class CheckInUseCase {
  final ParkingRepository repository;
  final DomainEventBus? eventBus;

  CheckInUseCase(this.repository, {this.eventBus});

  Future<void> call({
    required String lotId,
    required String vehicleType,
    required String vehiclePlate,
    required String staffId,
  }) async {
    if (vehiclePlate.trim().isEmpty) {
      throw ArgumentError('vehiclePlate must not be empty');
    }

    await repository.checkIn(
      lotId: lotId,
      vehicleType: vehicleType,
      vehiclePlate: vehiclePlate,
      staffId: staffId,
    );

    eventBus?.publish(
      SessionCheckedInEvent(
        lotId: lotId,
        vehicleType: vehicleType,
        vehiclePlate: vehiclePlate,
        staffId: staffId,
      ),
    );
  }
}
