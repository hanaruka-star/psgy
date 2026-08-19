import '../../entities/parking_lot_entity.dart';
import '../../repositories/parking_repository.dart';

class GetNearbyLotsUseCase {
  final ParkingRepository repository;

  GetNearbyLotsUseCase(this.repository);

  Future<List<ParkingLotEntity>> call(
    double lat,
    double lng,
    double radiusKm,
  ) async {
    return await repository.getNearbyLots(lat, lng, radiusKm);
  }
}
