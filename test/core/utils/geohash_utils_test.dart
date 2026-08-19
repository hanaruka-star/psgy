import 'package:flutter_test/flutter_test.dart';
import 'package:parking_link/core/utils/geohash_utils.dart';

void main() {
  group('GeohashUtils.encode', () {
    test('encode(lat, lng, 7) returns a 7-character string', () {
      final hash = GeohashUtils.encode(
        latitude: 10.762215,
        longitude: 106.758809,
        precision: 7,
      );

      expect(hash.length, 7);
      expect(hash, matches(RegExp(r'^[0-9bcdefghjkmnpqrstuvwxyz]{7}$')));
    });
  });

  group('GeohashUtils.precisionForRadiusKm', () {
    test('2.0 km maps to precision 6', () {
      expect(GeohashUtils.precisionForRadiusKm(2.0), 6);
    });

    test('8.0 km maps to precision 5', () {
      expect(GeohashUtils.precisionForRadiusKm(8.0), 5);
    });

    test('30.0 km maps to precision 4', () {
      expect(GeohashUtils.precisionForRadiusKm(30.0), 4);
    });

    test('50.0 km maps to precision 3', () {
      expect(GeohashUtils.precisionForRadiusKm(50.0), 3);
    });
  });

  group('GeohashUtils.queryRange', () {
    test('queryRange returns start lexicographically before end', () {
      final range = GeohashUtils.queryRange(
        latitude: 10.762215,
        longitude: 106.758809,
        radiusKm: 5.0,
      );

      expect(range.start.compareTo(range.end), lessThan(0));
      expect(range.end, '${range.start}~');
    });
  });

  group('GeohashUtils nearby points', () {
    test('two nearby points share a geohash prefix at precision 7', () {
      const lat1 = 10.762215;
      const lng1 = 106.758809;
      const lat2 = 10.762220;
      const lng2 = 106.758810;

      final hash1 = GeohashUtils.encode(
        latitude: lat1,
        longitude: lng1,
        precision: 7,
      );
      final hash2 = GeohashUtils.encode(
        latitude: lat2,
        longitude: lng2,
        precision: 7,
      );

      expect(hash1.substring(0, 6), hash2.substring(0, 6));
    });
  });
}
