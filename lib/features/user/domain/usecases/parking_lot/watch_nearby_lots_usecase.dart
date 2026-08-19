import 'package:psgy/features/user/domain/entities/geo_coordinate.dart';
import 'package:psgy/features/user/domain/entities/user_geo_query_config.dart';
import 'package:psgy/features/user/domain/entities/user_nearby_lots_snapshot.dart';
import 'package:psgy/features/user/domain/repositories/user_repository.dart';

class WatchNearbyLotsUseCase {
  final UserRepository repository;

  WatchNearbyLotsUseCase(this.repository);

  Stream<UserNearbyLotsSnapshot> call({
    required GeoCoordinate center,
    double radiusKm = UserGeoQueryConfig.defaultRadiusKm,
    int maxResults = UserGeoQueryConfig.maxNearbyLots,
    bool enableCache = true,
    bool enableNetwork = true,
  }) {
    return repository.watchNearbyLots(
      center: center,
      radiusKm: radiusKm,
      maxResults: maxResults,
      enableCache: enableCache,
      enableNetwork: enableNetwork,
    );
  }

  Future<UserNearbyLotsSnapshot> sync({
    required GeoCoordinate center,
    double radiusKm = UserGeoQueryConfig.defaultRadiusKm,
    int maxResults = UserGeoQueryConfig.maxNearbyLots,
  }) {
    return repository.syncNearbyLots(
      center: center,
      radiusKm: radiusKm,
      maxResults: maxResults,
    );
  }
}
