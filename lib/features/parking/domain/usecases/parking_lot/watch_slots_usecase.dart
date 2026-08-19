import '../../entities/parking_slot_entity.dart';
import '../../repositories/parking_repository.dart';

class WatchSlotsUseCase {
  final ParkingRepository repository;

  WatchSlotsUseCase(this.repository);

  Stream<List<ParkingSlotEntity>> call(String lotId) {
    return repository.watchSlots(lotId);
  }
}
