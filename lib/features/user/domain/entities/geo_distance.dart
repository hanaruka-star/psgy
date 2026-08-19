import 'package:parking_link/core/utils/geo_distance.dart' as core_geo;
import 'package:parking_link/features/user/domain/entities/geo_coordinate.dart';

class GeoDistance {
  const GeoDistance._();

  static double kmBetween({
    required GeoCoordinate from,
    required double toLat,
    required double toLng,
  }) {
    return kmBetweenCoordinates(
      from.latitude,
      from.longitude,
      toLat,
      toLng,
    );
  }

  static double kmBetweenCoordinates(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    return core_geo.GeoDistance.kmBetweenCoordinates(
      lat1,
      lng1,
      lat2,
      lng2,
    );
  }
}
