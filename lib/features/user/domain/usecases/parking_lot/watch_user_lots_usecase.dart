import 'package:psgy/features/user/domain/entities/geo_coordinate.dart';
import 'package:psgy/features/user/domain/entities/user_geo_query_config.dart';
import 'package:psgy/features/user/domain/entities/user_nearby_lots_snapshot.dart';
import 'package:psgy/features/user/domain/repositories/user_repository.dart';

class WatchUserLotsUseCase {
  final UserRepository repository;

  WatchUserLotsUseCase(this.repository);

  Stream<UserNearbyLotsSnapshot> call({
    GeoCoordinate? center,
    double radiusKm = UserGeoQueryConfig.defaultRadiusKm,
  }) {
    if (center != null) {
      return repository.watchNearbyLots(
        center: center,
        radiusKm: radiusKm,
      );
    }

    return repository.watchAllLots().map(
          (lots) => UserNearbyLotsSnapshot(
            lots: lots.take(UserGeoQueryConfig.maxNearbyLots).toList(
                  growable: false,
                ),
            mode: UserNearbyLotsQueryMode.fallbackAll,
          ),
        );
  }
}
