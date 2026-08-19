import 'package:psgy/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:psgy/features/user/domain/entities/geo_coordinate.dart';
import 'package:psgy/features/user/domain/entities/geo_distance.dart';

class SortParkingLotsUseCase {
  List<ParkingLotEntity> call({
    required List<ParkingLotEntity> lots,
    GeoCoordinate? userLocation,
  }) {
    final sortedLots = List<ParkingLotEntity>.from(lots);

    if (userLocation == null) {
      sortedLots.sort((a, b) => a.name.compareTo(b.name));
      return sortedLots;
    }

    sortedLots.sort((a, b) {
      final distanceA = GeoDistance.kmBetween(
        from: userLocation,
        toLat: a.lat,
        toLng: a.lng,
      );
      final distanceB = GeoDistance.kmBetween(
        from: userLocation,
        toLat: b.lat,
        toLng: b.lng,
      );
      return distanceA.compareTo(distanceB);
    });

    return sortedLots;
  }
}
