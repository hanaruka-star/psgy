import 'package:psgy/features/user/domain/entities/geo_coordinate.dart';

abstract class UserLocationRepository {
  Future<GeoCoordinate?> getCurrentLocation();
}
