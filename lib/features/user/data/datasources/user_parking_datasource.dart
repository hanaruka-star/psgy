import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_link/features/parking/data/mappers/parking_lot_mapper.dart';
import 'package:parking_link/features/parking/data/models/parking_lot_model.dart';
import 'package:parking_link/features/parking/domain/entities/parking_lot_entity.dart';
import 'package:parking_link/core/utils/geohash_utils.dart';
import 'package:parking_link/features/user/domain/entities/geo_coordinate.dart';
import 'package:parking_link/features/user/domain/entities/geo_distance.dart';
import 'package:parking_link/features/user/domain/entities/user_geo_query_config.dart';

class UserParkingDataSource {
  final FirebaseFirestore _firestore;

  UserParkingDataSource(this._firestore);

  Stream<List<ParkingLotEntity>> watchGeohashNearbyLots({
    required GeoCoordinate center,
    required double radiusKm,
    required int maxResults,
  }) {
    final range = GeohashUtils.queryRange(
      latitude: center.latitude,
      longitude: center.longitude,
      radiusKm: radiusKm,
    );

    return _firestore
        .collection('parking_lots')
        .orderBy('geohash')
        .startAt([range.start])
        .endAt([range.end])
        .limit(UserGeoQueryConfig.fallbackQueryLimit)
        .snapshots()
        .map(
          (snapshot) => _filterAndSortByDistance(
            docs: snapshot.docs,
            center: center,
            radiusKm: radiusKm,
            maxResults: maxResults,
          ),
        );
  }

  Stream<List<ParkingLotEntity>> watchClientSideNearbyLots({
    required GeoCoordinate center,
    required double radiusKm,
    required int maxResults,
  }) {
    return _firestore
        .collection('parking_lots')
        .limit(UserGeoQueryConfig.fallbackQueryLimit)
        .snapshots()
        .map(
          (snapshot) => _filterAndSortByDistance(
            docs: snapshot.docs,
            center: center,
            radiusKm: radiusKm,
            maxResults: maxResults,
          ),
        );
  }

  Stream<List<ParkingLotEntity>> watchAllLotsLimited({
    required int maxResults,
  }) {
    return _firestore.collection('parking_lots').limit(maxResults).snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ParkingLotMapper.toEntity(
                  ParkingLotModel.fromFirestore(doc),
                ),
              )
              .toList(growable: false),
        );
  }

  Future<List<ParkingLotEntity>> fetchClientSideNearbyLotsOnce({
    required GeoCoordinate center,
    required double radiusKm,
    required int maxResults,
  }) async {
    final snapshot = await _firestore
        .collection('parking_lots')
        .limit(UserGeoQueryConfig.fallbackQueryLimit)
        .get();

    return _filterAndSortByDistance(
      docs: snapshot.docs,
      center: center,
      radiusKm: radiusKm,
      maxResults: maxResults,
    );
  }

  Future<List<ParkingLotEntity>> fetchAllLotsLimitedOnce({
    required int maxResults,
  }) async {
    final snapshot = await _firestore
        .collection('parking_lots')
        .limit(maxResults)
        .get();

    return snapshot.docs
        .map(
          (doc) => ParkingLotMapper.toEntity(
            ParkingLotModel.fromFirestore(doc),
          ),
        )
        .toList(growable: false);
  }

  List<ParkingLotEntity> _filterAndSortByDistance({
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    required GeoCoordinate center,
    required double radiusKm,
    required int maxResults,
  }) {
    final lotsWithDistance = docs
        .map((doc) {
          final model = ParkingLotModel.fromFirestore(doc);
          final entity = ParkingLotMapper.toEntity(model);
          final distanceKm = GeoDistance.kmBetweenCoordinates(
            center.latitude,
            center.longitude,
            entity.lat,
            entity.lng,
          );
          return (entity: entity, distanceKm: distanceKm);
        })
        .where((item) => item.distanceKm <= radiusKm)
        .toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    return lotsWithDistance
        .take(maxResults)
        .map((item) => item.entity)
        .toList(growable: false);
  }
}
