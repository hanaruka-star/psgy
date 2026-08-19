import 'package:parking_link/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:parking_link/features/staff/domain/repositories/staff_repository.dart';

class WatchStaffLotUseCase {
  final StaffRepository repository;

  WatchStaffLotUseCase(this.repository);

  Stream<ParkingLotEntity> call(String lotId) {
    return repository.watchLot(lotId);
  }
}
