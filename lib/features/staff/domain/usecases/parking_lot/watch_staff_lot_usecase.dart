import 'package:psgy/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:psgy/features/staff/domain/repositories/staff_repository.dart';

class WatchStaffLotUseCase {
  final StaffRepository repository;

  WatchStaffLotUseCase(this.repository);

  Stream<ParkingLotEntity> call(String lotId) {
    return repository.watchLot(lotId);
  }
}
