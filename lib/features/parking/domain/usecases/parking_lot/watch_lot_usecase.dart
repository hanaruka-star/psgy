import '../../entities/parking_lot_entity.dart';
import '../../repositories/parking_repository.dart';

class WatchLotUseCase {
  final ParkingRepository repository;

  WatchLotUseCase(this.repository);

  Stream<ParkingLotEntity> call(String lotId) {
    return repository.watchLot(lotId);
  }
}
