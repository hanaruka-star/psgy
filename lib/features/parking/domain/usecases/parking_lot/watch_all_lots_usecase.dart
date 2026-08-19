import '../../entities/parking_lot_entity.dart';
import '../../repositories/parking_repository.dart';

class WatchAllLotsUseCase {
  final ParkingRepository repository;

  WatchAllLotsUseCase(this.repository);

  Stream<List<ParkingLotEntity>> call() {
    return repository.watchAllLots();
  }
}
