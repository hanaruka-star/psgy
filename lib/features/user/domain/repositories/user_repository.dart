import 'package:psgy/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:psgy/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:psgy/features/user/domain/entities/geo_coordinate.dart';
import 'package:psgy/features/user/domain/entities/user_nearby_lots_snapshot.dart';
import 'package:psgy/features/user/domain/entities/user_surveying_lots_snapshot.dart';

abstract class UserRepository {
  Stream<List<ParkingLotEntity>> watchAllLots();

  Stream<UserNearbyLotsSnapshot> watchNearbyLots({
    required GeoCoordinate center,
    double radiusKm,
    int maxResults,
    bool enableCache = true,
    bool enableNetwork = true,
  });

  Future<UserNearbyLotsSnapshot> syncNearbyLots({
    required GeoCoordinate center,
    double radiusKm,
    int maxResults,
  });

  Stream<UserSurveyingLotsSnapshot> watchSurveyingLots({
    required GeoCoordinate center,
    double radiusKm,
    int maxResults,
    bool enableCache = true,
    bool enableNetwork = true,
  });

  Future<UserSurveyingLotsSnapshot> syncSurveyingLots({
    required GeoCoordinate center,
    double radiusKm,
    int maxResults,
  });

  Stream<List<VehicleTypeEntity>> watchVehicleTypes(String lotId);
}
