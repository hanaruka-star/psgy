import 'dart:math' as math;

/// Grid clustering helpers for map markers (kept from the clone's map pattern).
///
/// Use when rendering gym/coach markers: group points that fall within
/// [clusterRadiusMetersForZoom] of each other, then collapse to one marker.
abstract final class MarkerCluster {
  static const stopClusteringZoom = 16.0;

  static double clusterRadiusMetersForZoom({
    required double zoom,
    required double latitude,
    double midZoomClusterRadiusPx = 56,
    double lowZoomClusterRadiusPx = 72,
  }) {
    if (zoom >= stopClusteringZoom) return 0;
    final radiusPx =
        zoom >= 12 ? midZoomClusterRadiusPx : lowZoomClusterRadiusPx;
    return pixelsToMeters(radiusPx, zoom, latitude);
  }

  static double pixelsToMeters(double pixels, double zoom, double latitude) {
    final latRad = latitude * (math.pi / 180.0);
    final metersPerPixel =
        (156543.03392 * math.cos(latRad)) / math.pow(2, zoom);
    return metersPerPixel * pixels;
  }
}
