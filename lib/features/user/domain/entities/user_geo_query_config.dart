class UserGeoQueryConfig {
  const UserGeoQueryConfig._();

  static const defaultRadiusKm = 15.0;
  static const minRadiusKm = 10.0;
  static const maxRadiusKm = 20.0;
  static const maxNearbyLots = 100;
  static const maxSurveyingLots = 80;
  static const fallbackQueryLimit = 200;
}
