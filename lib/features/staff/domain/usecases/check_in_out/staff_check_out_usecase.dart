import 'package:parking_link/features/staff/domain/repositories/staff_repository.dart';

class StaffCheckOutUseCase {
  final StaffRepository repository;

  StaffCheckOutUseCase(this.repository);

  Future<void> call({
    required String lotId,
    required String sessionId,
    required String vehicleType,
    required String staffId,
    String? checkOutMethod,
    String? checkOutTokenId,
  }) {
    return repository.checkOut(
      lotId: lotId,
      sessionId: sessionId,
      vehicleType: vehicleType,
      staffId: staffId,
      checkOutMethod: checkOutMethod,
      checkOutTokenId: checkOutTokenId,
    );
  }
}
