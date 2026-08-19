/// Minimal geohash helpers for Firestore range queries and local cache indexing.
class GeohashUtils {
  static const _base32 = '0123456789bcdefghjkmnpqrstuvwxyz';

  static String encode({
    required double latitude,
    required double longitude,
    int precision = 5,
  }) {
    var latRange = [-90.0, 90.0];
    var lngRange = [-180.0, 180.0];
    var hash = StringBuffer();
    var bit = 0;
    var ch = 0;
    var isLng = true;

    while (hash.length < precision) {
      if (isLng) {
        final mid = (lngRange[0] + lngRange[1]) / 2;
        if (longitude >= mid) {
          ch = ch * 2 + 1;
          lngRange[0] = mid;
        } else {
          ch = ch * 2;
          lngRange[1] = mid;
        }
      } else {
        final mid = (latRange[0] + latRange[1]) / 2;
        if (latitude >= mid) {
          ch = ch * 2 + 1;
          latRange[0] = mid;
        } else {
          ch = ch * 2;
          latRange[1] = mid;
        }
      }

      isLng = !isLng;
      bit++;

      if (bit == 5) {
        hash.write(_base32[ch]);
        bit = 0;
        ch = 0;
      }
    }

    return hash.toString();
  }

  static int precisionForRadiusKm(double radiusKm) {
    if (radiusKm <= 2.4) return 6;
    if (radiusKm <= 10) return 5;
    if (radiusKm <= 40) return 4;
    return 3;
  }

  static GeohashQueryRange queryRange({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) {
    final precision = precisionForRadiusKm(radiusKm);
    final centerHash = encode(
      latitude: latitude,
      longitude: longitude,
      precision: precision,
    );

    return GeohashQueryRange(
      start: centerHash,
      end: '$centerHash~',
      precision: precision,
    );
  }
}

class GeohashQueryRange {
  final String start;
  final String end;
  final int precision;

  const GeohashQueryRange({
    required this.start,
    required this.end,
    required this.precision,
  });
}
