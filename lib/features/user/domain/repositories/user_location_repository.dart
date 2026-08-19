import 'package:parking_link/features/user/domain/entities/geo_coordinate.dart';

abstract class UserLocationRepository {
  Future<GeoCoordinate?> getCurrentLocation();
}
