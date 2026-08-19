import 'package:parking_link/features/parking/domain/entities/parking_lot_entity.dart';

enum UserNearbyLotsQueryMode {
  cache,
  geohash,
  clientSide,
  fallbackAll,
}

class UserNearbyLotsSnapshot {
  final List<ParkingLotEntity> lots;
  final UserNearbyLotsQueryMode mode;

  const UserNearbyLotsSnapshot({
    required this.lots,
    required this.mode,
  });
}
