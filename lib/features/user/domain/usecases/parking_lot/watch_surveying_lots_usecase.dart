import 'package:psgy/features/user/domain/entities/geo_coordinate.dart';
import 'package:psgy/features/user/domain/entities/user_geo_query_config.dart';
import 'package:psgy/features/user/domain/entities/user_surveying_lots_snapshot.dart';
import 'package:psgy/features/user/domain/repositories/user_repository.dart';

class WatchSurveyingLotsUseCase {
  final UserRepository repository;

  WatchSurveyingLotsUseCase(this.repository);

  Stream<UserSurveyingLotsSnapshot> call({
    required GeoCoordinate center,
    double radiusKm = UserGeoQueryConfig.defaultRadiusKm,
    int maxResults = UserGeoQueryConfig.maxSurveyingLots,
    bool enableCache = true,
    bool enableNetwork = true,
  }) {
    return repository.watchSurveyingLots(
      center: center,
      radiusKm: radiusKm,
      maxResults: maxResults,
      enableCache: enableCache,
      enableNetwork: enableNetwork,
    );
  }

  Future<UserSurveyingLotsSnapshot> sync({
    required GeoCoordinate center,
    double radiusKm = UserGeoQueryConfig.defaultRadiusKm,
    int maxResults = UserGeoQueryConfig.maxSurveyingLots,
  }) {
    return repository.syncSurveyingLots(
      center: center,
      radiusKm: radiusKm,
      maxResults: maxResults,
    );
  }
}
