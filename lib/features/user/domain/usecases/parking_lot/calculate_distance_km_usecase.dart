import 'package:psgy/features/user/domain/entities/geo_coordinate.dart';
import 'package:psgy/features/user/domain/entities/geo_distance.dart';

class CalculateDistanceKmUseCase {
  double call({
    required GeoCoordinate from,
    required double toLat,
    required double toLng,
  }) {
    return GeoDistance.kmBetween(
      from: from,
      toLat: toLat,
      toLng: toLng,
    );
  }
}
