import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:psgy/core/utils/geohash_utils.dart';
import 'package:psgy/features/parking/data/mappers/surveying_lot_mapper.dart';
import 'package:psgy/features/parking/data/models/surveying_lot_model.dart';
import 'package:psgy/features/parking/domain/entities/surveying_lot_entity.dart';
import 'package:psgy/features/user/domain/entities/geo_coordinate.dart';
import 'package:psgy/features/user/domain/entities/geo_distance.dart';

class UserSurveyingDataSource {
  final FirebaseFirestore _firestore;
  static const _surveyingQueryLimit = 50;

  UserSurveyingDataSource(this._firestore);

  Stream<List<SurveyingLotEntity>> watchGeohashNearbyLots({
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
        .collection('surveying_lots')
        .where('status', isEqualTo: 'surveying')
        .orderBy('geohash')
        .startAt([range.start])
        .endAt([range.end])
        .limit(_surveyingQueryLimit)
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

  Stream<List<SurveyingLotEntity>> watchClientSideNearbyLots({
    required GeoCoordinate center,
    required double radiusKm,
    required int maxResults,
  }) {
    return _firestore
        .collection('surveying_lots')
        .where('status', isEqualTo: 'surveying')
        .limit(_surveyingQueryLimit)
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

  Future<List<SurveyingLotEntity>> fetchClientSideNearbyLotsOnce({
    required GeoCoordinate center,
    required double radiusKm,
    required int maxResults,
  }) async {
    final snapshot = await _firestore
        .collection('surveying_lots')
        .where('status', isEqualTo: 'surveying')
        .limit(_surveyingQueryLimit)
        .get();

    return _filterAndSortByDistance(
      docs: snapshot.docs,
      center: center,
      radiusKm: radiusKm,
      maxResults: maxResults,
    );
  }

  List<SurveyingLotEntity> _filterAndSortByDistance({
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    required GeoCoordinate center,
    required double radiusKm,
    required int maxResults,
  }) {
    final lotsWithDistance = docs
        .map((doc) {
          final model = SurveyingLotModel.fromFirestore(doc);
          final entity = SurveyingLotMapper.toEntity(model);
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
