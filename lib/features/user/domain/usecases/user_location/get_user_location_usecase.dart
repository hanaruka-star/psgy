import 'package:parking_link/features/user/domain/entities/geo_coordinate.dart';
import 'package:parking_link/features/user/domain/repositories/user_location_repository.dart';

class GetUserLocationUseCase {
  final UserLocationRepository repository;

  GetUserLocationUseCase(this.repository);

  Future<GeoCoordinate?> call() {
    return repository.getCurrentLocation();
  }
}
