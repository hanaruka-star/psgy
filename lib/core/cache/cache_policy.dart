class CachePolicy {
  const CachePolicy._();

  static const nearbyLotsTtl = Duration(minutes: 30);
  static const vehicleTypesTtl = Duration(minutes: 30);
  static const backgroundSyncInterval = Duration(minutes: 4);
  static const manualSyncDebounce = Duration(seconds: 2);
  static const maxVehicleTypesLotsPerSync = 20;
}
