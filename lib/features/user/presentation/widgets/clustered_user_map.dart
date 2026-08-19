import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_link/core/cache/cache_sync_state.dart';
import 'package:parking_link/core/di/firebase_providers.dart';
import 'package:parking_link/core/di/sync_providers.dart';
import 'package:parking_link/core/di/user_providers.dart';
import 'package:parking_link/core/monitoring/performance_metrics.dart';
import 'package:parking_link/features/parking/domain/entities/vehicle_type_entity.dart';
import 'package:parking_link/features/user/domain/entities/geo_coordinate.dart';
import 'package:parking_link/features/user/domain/entities/map_lot_item.dart';
import 'package:parking_link/features/user/domain/entities/surveying_lot_vehicle.dart';
import 'package:parking_link/features/user/domain/entities/vehicle_type_filter.dart';
import 'package:parking_link/features/user/presentation/providers/user_providers.dart';
import 'package:parking_link/features/user/presentation/widgets/map_dark_style.dart';
import 'package:parking_link/features/user/presentation/widgets/parking_cluster_manager.dart';
import 'package:parking_link/features/user/presentation/widgets/parking_lot_marker.dart';

/// Map camera / sync tuning — keep in sync with product perf notes.
abstract final class MapPerformanceConfig {
  /// Fast cache re-query while the map is still settling.
  static const cacheCenterDebounceMs = 80;
  static const cacheCenterMoveThrottleMs = 120;
  static const minCacheCenterMoveMeters = 80.0;
  static const cameraIdleDebounceMs = 1200;
  static const markerRefreshAfterIdleMs = 40;
  static const markerRefreshDebounceMs = 140;
  static const zoomClusterRefreshDebounceMs = 300;
  static const zoomClusterSignificantDelta = 0.2;
  static const minPulseZoom = 14.5;
  static const pulsePeriod = Duration(seconds: 3);
  static const clusterHighlightDuration = Duration(milliseconds: 420);
}

class ClusteredUserMap extends ConsumerStatefulWidget {
  static const hcmcCenter = LatLng(10.7769, 106.7009);
  static const initialZoom = 13.0;

  static const cameraIdleDebounceMs = MapPerformanceConfig.cameraIdleDebounceMs;
  static const minPulseZoom = MapPerformanceConfig.minPulseZoom;

  final List<MapLotItem> items;
  final String? selectedMapLotKey;
  final bool myLocationEnabled;
  final LatLng? initialTarget;
  final ValueChanged<GoogleMapController>? onMapCreated;

  const ClusteredUserMap({
    super.key,
    required this.items,
    required this.selectedMapLotKey,
    required this.myLocationEnabled,
    this.initialTarget,
    this.onMapCreated,
  });

  @override
  ConsumerState<ClusteredUserMap> createState() => _ClusteredUserMapState();
}

class _ClusteredUserMapState extends ConsumerState<ClusteredUserMap>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  late final ParkingClusterManager _clusterManager;
  late final AnimationController _pulseController;
  late final AnimationController _clusterHighlightController;

  Set<Marker> _markers = const {};
  Timer? _cacheCenterDebounce;
  Timer? _cameraIdleDebounce;
  Timer? _markerRefreshDebounce;
  CameraPosition? _lastCameraPosition;
  List<MapLotItem> _previousItems = const [];
  String? _previousSelectedKey;

  bool _isMapMoving = false;
  bool _pendingMarkerRefresh = false;
  bool _isRefreshingMarkers = false;
  double? _lastClusterRefreshZoom;
  LatLng? _clusterHighlightTarget;
  String? _lastRenderSignature;
  DateTime? _lastCacheCenterCommitAt;
  GeoCoordinate? _lastCommittedCacheCenter;
  ProviderSubscription<String>? _vehicleFilterSubscription;

  @override
  void initState() {
    super.initState();
    _clusterManager = ParkingClusterManager();
    _pulseController = AnimationController(
      vsync: this,
      duration: MapPerformanceConfig.pulsePeriod,
    );
    _clusterHighlightController = AnimationController(
      vsync: this,
      duration: MapPerformanceConfig.clusterHighlightDuration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          setState(() => _clusterHighlightTarget = null);
        }
      });
    _vehicleFilterSubscription = ref.listenManual<String>(
      vehicleTypeFilterProvider,
      (_, __) {
        if (_isMapMoving) {
          _pendingMarkerRefresh = true;
          return;
        }
        _scheduleMarkerRefresh();
      },
    );
    _syncPulseAnimation();
  }

  @override
  void didUpdateWidget(covariant ClusteredUserMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    final itemsChanged = !_areItemsEqual(widget.items, _previousItems);
    final selectionChanged = widget.selectedMapLotKey != _previousSelectedKey;

    if (itemsChanged || selectionChanged) {
      _previousItems = List<MapLotItem>.from(widget.items);
      _previousSelectedKey = widget.selectedMapLotKey;
      _syncPulseAnimation();
      if (_isMapMoving) {
        _pendingMarkerRefresh = true;
      } else {
        _scheduleMarkerRefresh();
      }
    }
  }

  @override
  void dispose() {
    _cacheCenterDebounce?.cancel();
    _cameraIdleDebounce?.cancel();
    _markerRefreshDebounce?.cancel();
    _pulseController.dispose();
    _clusterHighlightController.dispose();
    _vehicleFilterSubscription?.close();
    super.dispose();
  }

  bool get _shouldAnimatePulse {
    final zoom = _lastCameraPosition?.zoom ?? ClusteredUserMap.initialZoom;
    return !_isMapMoving &&
        zoom >= MapPerformanceConfig.minPulseZoom &&
        widget.items.any((item) => item.isSurveying);
  }

  void _syncPulseAnimation() {
    if (_shouldAnimatePulse) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat();
      }
      return;
    }
    if (_pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.value = 0;
    }
  }

  Set<Circle> _pulseCirclesFor(double phase) {
    if (!_shouldAnimatePulse) return const {};

    final circles = <Circle>{};
    final pulseAlpha = 0.08 + (1 - phase) * 0.14;
    const radius = 20.0;

    for (final item in widget.items) {
      if (!item.isSurveying) continue;
      if (item.mapKey == widget.selectedMapLotKey) continue;

      circles.add(
        Circle(
          circleId: CircleId('pulse_${item.mapKey}'),
          center: LatLng(item.lat, item.lng),
          radius: radius,
          fillColor: surveyingMarkerColor.withValues(alpha: pulseAlpha * 0.35),
          strokeColor: surveyingMarkerColor.withValues(alpha: pulseAlpha),
          strokeWidth: 1,
          zIndex: 0,
        ),
      );
    }
    return circles;
  }

  Set<Circle> _clusterHighlightCircles() {
    final target = _clusterHighlightTarget;
    if (target == null) return const {};

    final t = _clusterHighlightController.value;
    final alpha = (1 - t) * 0.3;
    final radius = 45.0 + (220.0 * t);
    return {
      Circle(
        circleId: const CircleId('cluster_tap_highlight'),
        center: target,
        radius: radius,
        fillColor: activeMarkerGreenDeep.withValues(alpha: alpha * 0.35),
        strokeColor: activeMarkerGreenDeep.withValues(alpha: alpha),
        strokeWidth: 2,
        zIndex: 3,
      ),
    };
  }

  void _onMarkersUpdated(Set<Marker> markers) {
    if (!mounted) return;
    setState(() => _markers = markers);
  }

  void _onLotTap(String mapKey) {
    if (mapKey.startsWith('surveying:')) {
      HapticFeedback.mediumImpact();
    }
    ref.read(selectedMapLotKeyProvider.notifier).state = mapKey;
  }

  Future<void> _onClusterTap(LatLng target) async {
    final controller = _mapController;
    if (controller == null) return;

    setState(() => _clusterHighlightTarget = target);
    unawaited(_clusterHighlightController.forward(from: 0));

    final currentZoom = await controller.getZoomLevel();
    final targetZoom = math.max(
      ParkingClusterManager.stopClusteringZoom + 0.2,
      currentZoom + 1.2,
    );
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        target,
        math.min(targetZoom, 18),
      ),
    );
  }

  List<MapLotClusterItem> _toClusterItems() {
    final vehicleFilter = ref.read(vehicleTypeFilterProvider);

    return widget.items
        .map(
          (item) => MapLotClusterItem(
            item: item,
            isSelected: item.mapKey == widget.selectedMapLotKey,
            markerVehicleKind: _resolveMarkerVehicleKind(
              item: item,
              vehicleFilter: vehicleFilter,
            ),
            activeAvailableSlots: _resolveActiveAvailableSlots(
              item: item,
              vehicleFilter: vehicleFilter,
            ),
          ),
        )
        .toList(growable: false);
  }

  MarkerVehicleKind? _resolveMarkerVehicleKind({
    required MapLotItem item,
    required String vehicleFilter,
  }) {
    if (vehicleFilter == VehicleTypeFilter.car ||
        vehicleFilter == VehicleTypeFilter.moto) {
      return ParkingLotMarkerIconCache.vehicleKindFromType(vehicleFilter);
    }

    if (vehicleFilter == VehicleTypeFilter.all) {
      if (item.isSurveying) {
        return SurveyingLotVehicle.markerKind(item.surveyingLot!);
      }
      final types =
          ref.read(lotVehicleTypesProvider(item.id)).valueOrNull ?? const [];
      return _primaryActiveKind(types);
    }

    if (item.isSurveying) {
      return SurveyingLotVehicle.markerKind(item.surveyingLot!);
    }

    final types =
        ref.read(lotVehicleTypesProvider(item.id)).valueOrNull ?? const [];
    if (types.any((type) => type.type == 'car')) {
      return MarkerVehicleKind.car;
    }
    if (types.any((type) => type.type == 'moto')) {
      return MarkerVehicleKind.moto;
    }
    if (types.any((type) => futureVehicleTypes.contains(type.type))) {
      return MarkerVehicleKind.other;
    }
    return MarkerVehicleKind.car;
  }

  MarkerVehicleKind _primaryActiveKind(List<VehicleTypeEntity> types) {
    if (types.isEmpty) return MarkerVehicleKind.car;
    VehicleTypeEntity? chosen;
    for (final type in types) {
      if (chosen == null) {
        chosen = type;
        continue;
      }
      final score = type.availableSlots * 1000 + type.totalSlots;
      final best = chosen.availableSlots * 1000 + chosen.totalSlots;
      if (score > best) {
        chosen = type;
      }
    }
    if (chosen == null) return MarkerVehicleKind.car;
    if (chosen.type == VehicleTypeFilter.car) return MarkerVehicleKind.car;
    if (chosen.type == VehicleTypeFilter.moto) return MarkerVehicleKind.moto;
    return MarkerVehicleKind.other;
  }

  int? _resolveActiveAvailableSlots({
    required MapLotItem item,
    required String vehicleFilter,
  }) {
    if (!item.isActive) return null;
    final types =
        ref.read(lotVehicleTypesProvider(item.id)).valueOrNull ?? const [];
    if (types.isEmpty) return null;
    if (vehicleFilter == VehicleTypeFilter.car) {
      return _availableByType(types, VehicleTypeFilter.car);
    }
    if (vehicleFilter == VehicleTypeFilter.moto) {
      return _availableByType(types, VehicleTypeFilter.moto);
    }
    return _sumAvailable(types);
  }

  int _availableByType(List<VehicleTypeEntity> types, String type) {
    for (final item in types) {
      if (item.type == type) return item.availableSlots;
    }
    return 0;
  }

  int _sumAvailable(List<VehicleTypeEntity> types) {
    var total = 0;
    for (final item in types) {
      total += item.availableSlots;
    }
    return total;
  }

  void _scheduleMarkerRefresh() {
    _markerRefreshDebounce?.cancel();
    _markerRefreshDebounce = Timer(
      const Duration(
          milliseconds: MapPerformanceConfig.markerRefreshDebounceMs),
      () {
        if (!mounted || _isMapMoving) {
          _pendingMarkerRefresh = true;
          return;
        }
        unawaited(_refreshMarkers());
      },
    );
  }

  Future<void> _refreshMarkers({bool allowWhileMoving = false}) async {
    if (_isRefreshingMarkers || (_isMapMoving && !allowWhileMoving)) {
      _pendingMarkerRefresh = true;
      return;
    }

    final controller = _mapController;
    if (controller == null) return;
    final signature = _currentRenderSignature();
    if (signature == _lastRenderSignature) return;

    _isRefreshingMarkers = true;
    final monitoring = ref.read(monitoringServiceProvider);
    final startedAt = DateTime.now();
    await monitoring.startTrace('map_render');

    try {
      final bounds = await controller.getVisibleRegion();
      _clusterManager.setItems(_toClusterItems());
      _clusterManager.setVisibleBounds(bounds);
      await _clusterManager.rebuild(
        onMarkersUpdated: _onMarkersUpdated,
        onLotTap: _onLotTap,
        onClusterTap: _onClusterTap,
      );
      _lastRenderSignature = signature;
      _lastClusterRefreshZoom = _lastCameraPosition?.zoom;

      final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
      monitoring.putTraceMetric('map_render', 'lot_count', widget.items.length);
      monitoring.putTraceMetric('map_render', 'duration_ms', durationMs);
      monitoring.logEvent(
        'map_render',
        PerformanceMetrics.fromMapRender(
          markerCount: _markers.length,
          lotCount: widget.items.length,
          durationMs: durationMs,
        ),
      );
    } finally {
      _isRefreshingMarkers = false;
      await monitoring.stopTrace('map_render');
    }
  }

  Future<void> _handleMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    widget.onMapCreated?.call(controller);
    _previousItems = List<MapLotItem>.from(widget.items);
    _previousSelectedKey = widget.selectedMapLotKey;
    await _refreshMarkers();
  }

  void _handleCameraMove(CameraPosition position) {
    _isMapMoving = true;
    _cameraIdleDebounce?.cancel();
    _markerRefreshDebounce?.cancel();

    _lastCameraPosition = position;
    _clusterManager.onCameraMove(position);
    _scheduleZoomBasedRefresh(position.zoom);
    _scheduleCacheCenterCommit(position, force: false);
    _syncPulseAnimation();
  }

  void _scheduleZoomBasedRefresh(double zoom) {
    final previous = _lastClusterRefreshZoom;
    if (previous != null &&
        (zoom - previous).abs() < MapPerformanceConfig.zoomClusterSignificantDelta) {
      return;
    }
    _markerRefreshDebounce?.cancel();
    _markerRefreshDebounce = Timer(
      const Duration(
        milliseconds: MapPerformanceConfig.zoomClusterRefreshDebounceMs,
      ),
      () {
        if (!mounted) return;
        unawaited(_refreshMarkers());
      },
    );
  }

  void _handleCameraIdle() {
    // Camera already settled for the user interaction. Keep 1200ms debounce
    // for network/sync, but allow cache + marker refresh much earlier.
    _isMapMoving = false;
    _syncPulseAnimation();

    _scheduleCacheCenterCommit(_lastCameraPosition, force: true);

    _markerRefreshDebounce?.cancel();
    _markerRefreshDebounce = Timer(
      const Duration(
          milliseconds: MapPerformanceConfig.markerRefreshAfterIdleMs),
      () {
        if (!mounted) return;
        unawaited(_refreshMarkers());
      },
    );

    _cameraIdleDebounce?.cancel();
    _cameraIdleDebounce = Timer(
      const Duration(milliseconds: MapPerformanceConfig.cameraIdleDebounceMs),
      _onCameraSettled,
    );
  }

  void _onCacheCenterSettled(GeoCoordinate center) {
    if (!mounted) return;
    _lastCommittedCacheCenter = center;
    _lastCacheCenterCommitAt = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(mapCacheCenterProvider.notifier).state = center;
    });
  }

  void _scheduleCacheCenterCommit(
    CameraPosition? position, {
    required bool force,
  }) {
    if (position == null) return;
    final center = GeoCoordinate(
      latitude: position.target.latitude,
      longitude: position.target.longitude,
    );

    if (!force) {
      final lastAt = _lastCacheCenterCommitAt;
      if (lastAt != null &&
          DateTime.now().difference(lastAt).inMilliseconds <
              MapPerformanceConfig.cacheCenterMoveThrottleMs) {
        return;
      }
      final previous = _lastCommittedCacheCenter;
      if (previous != null &&
          _distanceMeters(previous, center) <
              MapPerformanceConfig.minCacheCenterMoveMeters) {
        return;
      }
    }

    _cacheCenterDebounce?.cancel();
    final delay = force ? 0 : MapPerformanceConfig.cacheCenterDebounceMs;
    _cacheCenterDebounce = Timer(
      Duration(milliseconds: delay),
      () => _onCacheCenterSettled(center),
    );
  }

  String _currentRenderSignature() {
    final camera = _lastCameraPosition;
    final vehicleFilter = ref.read(vehicleTypeFilterProvider);
    var itemsHash = 17;
    for (final item in widget.items) {
      itemsHash = 0x1fffffff & (itemsHash * 31 + item.hashCode);
    }
    return [
      camera?.target.latitude.toStringAsFixed(4) ?? 'na',
      camera?.target.longitude.toStringAsFixed(4) ?? 'na',
      camera?.zoom.toStringAsFixed(2) ?? 'na',
      vehicleFilter,
      widget.selectedMapLotKey ?? 'none',
      widget.items.length.toString(),
      itemsHash.toString(),
    ].join('|');
  }

  double _distanceMeters(GeoCoordinate a, GeoCoordinate b) {
    const earthRadius = 6371000.0;
    final lat1 = a.latitude * (math.pi / 180.0);
    final lat2 = b.latitude * (math.pi / 180.0);
    final dLat = (b.latitude - a.latitude) * (math.pi / 180.0);
    final dLng = (b.longitude - a.longitude) * (math.pi / 180.0);
    final haversine = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(haversine), math.sqrt(1 - haversine));
    return earthRadius * c;
  }

  void _onCameraSettled() {
    if (!mounted) return;

    _isMapMoving = false;
    _syncPulseAnimation();

    final position = _lastCameraPosition;
    if (position == null) return;

    ref.read(monitoringServiceProvider).logBreadcrumb(
      'map_pan',
      params: {
        'lat': position.target.latitude,
        'lng': position.target.longitude,
        'zoom': position.zoom,
      },
    );

    final center = GeoCoordinate(
      latitude: position.target.latitude,
      longitude: position.target.longitude,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isMapMoving) return;

      ref.read(mapSearchCenterProvider.notifier).state = center;
      ref.read(mapQueryCenterProvider.notifier).state = center;
      ref.read(backgroundSyncServiceProvider).scheduleSync(
            trigger: SyncTrigger.mapIdle,
            center: center,
          );
    });

    if (_pendingMarkerRefresh) {
      _pendingMarkerRefresh = false;
      unawaited(_refreshMarkers());
    } else {
      _scheduleMarkerRefresh();
    }
  }

  bool _areItemsEqual(List<MapLotItem> a, List<MapLotItem> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final target = widget.initialTarget ?? ClusteredUserMap.hcmcCenter;
    final initialCamera = CameraPosition(
      target: target,
      zoom: ClusteredUserMap.initialZoom,
    );

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation:
            Listenable.merge([_pulseController, _clusterHighlightController]),
        builder: (context, child) {
          final circles = <Circle>{
            ..._pulseCirclesFor(_pulseController.value),
            ..._clusterHighlightCircles(),
          };
          return GoogleMap(
            initialCameraPosition: initialCamera,
            markers: _markers,
            circles: circles,
            onMapCreated: _handleMapCreated,
            onCameraMove: _handleCameraMove,
            onCameraIdle: _handleCameraIdle,
            myLocationEnabled: widget.myLocationEnabled,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            style: MapDarkStyle.json,
          );
        },
      ),
    );
  }
}
