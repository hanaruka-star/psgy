import 'package:psgy/features/user/data/datasources/user_location_datasource.dart';
import 'package:psgy/features/user/domain/entities/geo_coordinate.dart';
import 'package:psgy/features/user/domain/repositories/user_location_repository.dart';

class UserLocationRepositoryImpl implements UserLocationRepository {
  final UserLocationDataSource _dataSource;

  UserLocationRepositoryImpl([UserLocationDataSource? dataSource])
      : _dataSource = dataSource ?? UserLocationDataSource();

  @override
  Future<GeoCoordinate?> getCurrentLocation() {
    return _dataSource.getCurrentLocation();
  }
}
