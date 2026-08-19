import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_link/features/user/domain/entities/map_lot_item.dart';
import 'package:parking_link/features/user/presentation/widgets/parking_lot_marker.dart';

class MapLotClusterItem {
  final MapLotItem item;
  final bool isSelected;
  final MarkerVehicleKind? markerVehicleKind;
  final int? activeAvailableSlots;

  MapLotClusterItem({
    required this.item,
    this.isSelected = false,
    this.markerVehicleKind,
    this.activeAvailableSlots,
  });

  String get mapKey => item.mapKey;

  LatLng get location => LatLng(item.lat, item.lng);

  bool get isSurveying => item.isSurveying;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MapLotClusterItem &&
            item == other.item &&
            isSelected == other.isSelected &&
            markerVehicleKind == other.markerVehicleKind &&
            activeAvailableSlots == other.activeAvailableSlots;
  }

  @override
  int get hashCode => Object.hash(
        item,
        isSelected,
        markerVehicleKind,
        activeAvailableSlots,
      );
}

typedef MapMarkersUpdated = void Function(Set<Marker> markers);

/// Lightweight viewport clustering for mixed active + surveying lots.
class ParkingClusterManager {
  static const stopClusteringZoom = 14.0;
  static const maxVisibleMarkers = 45;
  static const _midZoomClusterRadiusPx = 60.0;
  static const _lowZoomClusterRadiusPx = 100.0;

  List<MapLotClusterItem> _items = const [];
  double _zoom = 13;
  LatLngBounds? _bounds;
  LatLng? _cameraTarget;

  void setItems(List<MapLotClusterItem> items) {
    _items = items;
  }

  void onCameraMove(CameraPosition position) {
    _zoom = position.zoom;
    _cameraTarget = position.target;
  }

  void setVisibleBounds(LatLngBounds bounds) {
    _bounds = bounds;
  }

  Future<void> rebuild({
    required MapMarkersUpdated onMarkersUpdated,
    required void Function(String mapKey) onLotTap,
    Future<void> Function(LatLng target)? onClusterTap,
  }) async {
    final markers = await _buildMarkers(
      onLotTap: onLotTap,
      onClusterTap: onClusterTap,
    );
    onMarkersUpdated(markers);
  }

  Future<Set<Marker>> _buildMarkers({
    required void Function(String mapKey) onLotTap,
    Future<void> Function(LatLng target)? onClusterTap,
  }) async {
    final visibleItems = _sortedVisibleItems().take(maxVisibleMarkers).toList();
    if (visibleItems.isEmpty) return {};

    if (_zoom >= stopClusteringZoom) {
      return _buildIndividualMarkers(
        items: visibleItems,
        onLotTap: onLotTap,
      );
    }

    return _buildClusteredMarkers(
      items: visibleItems,
      onLotTap: onLotTap,
      onClusterTap: onClusterTap,
    );
  }

  Iterable<MapLotClusterItem> _visibleItems() {
    final bounds = _bounds;
    if (bounds == null) return _items;

    return _items.where((item) => bounds.contains(item.location));
  }

  Iterable<MapLotClusterItem> _sortedVisibleItems() {
    final visible = _visibleItems().toList(growable: false);
    final center = _cameraTarget;
    if (center == null || visible.length <= 1) return visible;

    visible.sort((a, b) {
      final da = _distanceMeters(
        a.location.latitude,
        a.location.longitude,
        center.latitude,
        center.longitude,
      );
      final db = _distanceMeters(
        b.location.latitude,
        b.location.longitude,
        center.latitude,
        center.longitude,
      );
      return da.compareTo(db);
    });
    return visible;
  }

  Future<Set<Marker>> _buildClusteredMarkers({
    required List<MapLotClusterItem> items,
    required void Function(String mapKey) onLotTap,
    Future<void> Function(LatLng target)? onClusterTap,
  }) async {
    final clusterRadiusMeters = _clusterRadiusMetersForZoom(_zoom);
    if (clusterRadiusMeters <= 0) {
      return _buildIndividualMarkers(
        items: items,
        onLotTap: onLotTap,
      );
    }
    final groups = <String, List<MapLotClusterItem>>{};

    for (final item in items) {
      final key = _bucketKey(
        item: item,
        gridMeters: clusterRadiusMeters,
      );
      groups.putIfAbsent(key, () => []).add(item);
    }

    final markerFutures = <Future<Marker>>[];
    for (final group in groups.values) {
      if (group.length == 1) {
        final item = group.first;
        markerFutures.add(
          MapLotMarker.build(
            item: item.item,
            isSelected: item.isSelected,
            vehicleKind: item.markerVehicleKind,
            activeAvailableSlots: item.activeAvailableSlots,
            onTap: () => onLotTap(item.mapKey),
          ),
        );
        continue;
      }

      final center = _clusterCenter(group);
      if (!_shouldCluster(group, center, clusterRadiusMeters)) {
        markerFutures.addAll(
          group.map(
            (item) => MapLotMarker.build(
              item: item.item,
              isSelected: item.isSelected,
              vehicleKind: item.markerVehicleKind,
              activeAvailableSlots: item.activeAvailableSlots,
              onTap: () => onLotTap(item.mapKey),
            ),
          ),
        );
        continue;
      }

      final clusterId =
          'cluster_${center.latitude.toStringAsFixed(4)}_${center.longitude.toStringAsFixed(4)}';
      final hasSurveying = group.any((item) => item.isSurveying);
      final hasActive = group.any((item) => !item.isSurveying);
      final clusterKind = hasActive && hasSurveying
          ? MarkerClusterKind.mixed
          : hasSurveying
              ? MarkerClusterKind.survey
              : MarkerClusterKind.dynamic;

      markerFutures.add(
        () async {
          final icon = await ParkingLotMarkerIconCache.clusterIcon(
            group.length,
            clusterKind: clusterKind,
          );
          return Marker(
          markerId: MarkerId(clusterId),
          position: center,
          icon: icon,
          zIndexInt: hasActive ? 2 : 1,
          onTap: () async {
            await onClusterTap?.call(center);
          },
          );
        }(),
      );
    }

    return (await Future.wait(markerFutures)).toSet();
  }

  LatLng _clusterCenter(List<MapLotClusterItem> items) {
    final lat = items.fold<double>(
          0,
          (sum, item) => sum + item.location.latitude,
        ) /
        items.length;
    final lng = items.fold<double>(
          0,
          (sum, item) => sum + item.location.longitude,
        ) /
        items.length;
    return LatLng(lat, lng);
  }

  Future<Set<Marker>> _buildIndividualMarkers({
    required List<MapLotClusterItem> items,
    required void Function(String mapKey) onLotTap,
  }) async {
    final markers = await Future.wait(
      items.map(
        (item) => MapLotMarker.build(
          item: item.item,
          isSelected: item.isSelected,
          vehicleKind: item.markerVehicleKind,
          activeAvailableSlots: item.activeAvailableSlots,
          onTap: () => onLotTap(item.mapKey),
        ),
      ),
    );
    return markers.toSet();
  }

  String _bucketKey({
    required MapLotClusterItem item,
    required double gridMeters,
  }) {
    final lat = item.location.latitude;
    final lng = item.location.longitude;
    final latRad = lat * (math.pi / 180.0);
    final xMeters = lng * (111320.0 * math.cos(latRad));
    final yMeters = lat * 110540.0;
    final xBucket = (xMeters / gridMeters).floor();
    final yBucket = (yMeters / gridMeters).floor();
    final lotType = item.isSurveying ? 'survey' : 'active';
    final vehicleType = item.markerVehicleKind?.name ?? 'unknown';
    return '${xBucket}_$yBucket-$lotType-$vehicleType';
  }

  bool _shouldCluster(
    List<MapLotClusterItem> group,
    LatLng center,
    double radiusMeters,
  ) {
    if (group.length <= 1) return false;

    for (final item in group) {
      final distance = _distanceMeters(
        item.location.latitude,
        item.location.longitude,
        center.latitude,
        center.longitude,
      );
      if (distance > radiusMeters) return false;
    }

    final maxPairDistance = 2 * radiusMeters;
    for (var i = 0; i < group.length; i++) {
      final a = group[i].location;
      for (var j = i + 1; j < group.length; j++) {
        final b = group[j].location;
        final pairwise = _distanceMeters(
          a.latitude,
          a.longitude,
          b.latitude,
          b.longitude,
        );
        if (pairwise > maxPairDistance) return false;
      }
    }

    return true;
  }

  double _clusterRadiusMetersForZoom(double zoom) {
    if (zoom >= stopClusteringZoom) return 0;
    final radiusPx = zoom >= 12 ? _midZoomClusterRadiusPx : _lowZoomClusterRadiusPx;
    return _pixelsToMeters(radiusPx, zoom);
  }

  double _pixelsToMeters(double pixels, double zoom) {
    final latitude = _cameraTarget?.latitude ?? 10.7769;
    final latRad = latitude * (math.pi / 180.0);
    final metersPerPixel = (156543.03392 * math.cos(latRad)) / math.pow(2, zoom);
    return metersPerPixel * pixels;
  }

  double _distanceMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusMeters = 6371000.0;
    final dLat = (lat2 - lat1) * (math.pi / 180.0);
    final dLon = (lon2 - lon1) * (math.pi / 180.0);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * (math.pi / 180.0)) *
            math.cos(lat2 * (math.pi / 180.0)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusMeters * c;
  }
}

// Legacy alias
typedef ParkingLotClusterItem = MapLotClusterItem;
typedef ParkingMarkersUpdated = MapMarkersUpdated;
