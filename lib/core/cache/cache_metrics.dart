class CacheMetrics {
  final int lotsCount;
  final int vehicleTypesCount;
  final int sessionsCount;
  final DateTime? latestLotsCachedAt;
  final DateTime? latestVehicleTypesCachedAt;

  const CacheMetrics({
    required this.lotsCount,
    required this.vehicleTypesCount,
    required this.sessionsCount,
    required this.latestLotsCachedAt,
    required this.latestVehicleTypesCachedAt,
  });

  static const empty = CacheMetrics(
    lotsCount: 0,
    vehicleTypesCount: 0,
    sessionsCount: 0,
    latestLotsCachedAt: null,
    latestVehicleTypesCachedAt: null,
  );
}
