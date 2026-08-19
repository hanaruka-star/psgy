import 'package:psgy/features/user/domain/entities/geo_coordinate.dart';
import 'package:psgy/features/user/domain/repositories/user_location_repository.dart';

class GetUserLocationUseCase {
  final UserLocationRepository repository;

  GetUserLocationUseCase(this.repository);

  Future<GeoCoordinate?> call() {
    return repository.getCurrentLocation();
  }
}
