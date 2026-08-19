import 'package:psgy/core/events/domain_event_bus.dart';
import 'package:psgy/core/events/session_checked_in_event.dart';
import 'package:psgy/features/staff/domain/repositories/staff_repository.dart';

class StaffCheckInUseCase {
  static final RegExp _plateAllowedRegex = RegExp(r'^[A-Z0-9\-]{6,12}$');
  static const String _invalidPlateMessage =
      'Biển số không hợp lệ. VD: 51A-12345 hoặc 51A123.45';

  final StaffRepository repository;
  final DomainEventBus? eventBus;

  StaffCheckInUseCase(this.repository, {this.eventBus});

  Future<String> call({
    required String lotId,
    required String vehicleType,
    required String vehiclePlate,
    required String staffId,
    String? userId,
    String? vehicleId,
    String? vehiclePhotoUrl,
    String? checkInMethod,
  }) async {
    final normalizedPlate = vehiclePlate.trim().toUpperCase();
    if (normalizedPlate.isEmpty) {
      throw ArgumentError('vehiclePlate must not be empty');
    }
    if (!_plateAllowedRegex.hasMatch(normalizedPlate)) {
      throw ArgumentError(_invalidPlateMessage);
    }

    final sessionId = await repository.checkIn(
      lotId: lotId,
      vehicleType: vehicleType,
      vehiclePlate: normalizedPlate,
      staffId: staffId,
      userId: userId,
      vehicleId: vehicleId,
      vehiclePhotoUrl: vehiclePhotoUrl,
      checkInMethod: checkInMethod,
    );

    eventBus?.publish(
      SessionCheckedInEvent(
        lotId: lotId,
        vehicleType: vehicleType,
        vehiclePlate: normalizedPlate,
        staffId: staffId,
      ),
    );

    return sessionId;
  }
}
