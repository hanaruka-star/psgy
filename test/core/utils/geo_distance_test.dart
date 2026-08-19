import 'package:flutter_test/flutter_test.dart';
import 'package:psgy/core/utils/geo_distance.dart';

void main() {
  group('GeoDistance.kmBetweenCoordinates', () {
    test('distance between the same point is 0', () {
      const lat = 10.762215;
      const lng = 106.758809;

      final distance = GeoDistance.kmBetweenCoordinates(lat, lng, lat, lng);

      expect(distance, 0);
    });

    test('one degree longitude at equator is approximately 111.2 km', () {
      final distance = GeoDistance.kmBetweenCoordinates(0, 0, 0, 1);

      expect(distance, closeTo(111.195, 0.1));
    });
  });
}
