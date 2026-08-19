import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_link/core/cache/cache_sync_state.dart';
import 'package:parking_link/core/debug/debug_logger.dart';
import 'package:parking_link/core/di/debug_providers.dart';
import 'package:parking_link/core/di/firebase_providers.dart';
import 'package:parking_link/core/di/sync_providers.dart';
import 'package:parking_link/core/di/user_providers.dart';
import 'package:parking_link/core/di/watchlist_providers.dart';
import 'package:parking_link/core/error/app_error_handler.dart';
import 'package:parking_link/core/monitoring/performance_metrics.dart';
import 'package:parking_link/features/user/domain/entities/geo_distance.dart';
import 'package:parking_link/features/user/domain/entities/map_lot_item.dart';
import 'package:parking_link/features/user/domain/entities/user_map_filter.dart';
import 'package:parking_link/features/user/domain/entities/geo_coordinate.dart';
import 'package:parking_link/features/user/domain/entities/user_nearby_lots_snapshot.dart';
import 'package:parking_link/features/user/presentation/providers/user_providers.dart';
import 'package:parking_link/features/user/presentation/widgets/map_header_bar.dart';
import 'package:parking_link/features/user/presentation/widgets/map_lot_info_overlay.dart';
import 'package:parking_link/features/user/presentation/widgets/map_lot_sheet_card.dart';
import 'package:parking_link/features/common/presentation/widgets/debug_menu_host.dart';
import 'package:parking_link/features/user/presentation/providers/watchlist_notification_providers.dart';
import 'package:parking_link/features/user/presentation/widgets/clustered_user_map.dart';
import 'package:parking_link/features/user/presentation/widgets/map_legend.dart';
import 'package:parking_link/features/user/presentation/widgets/survey_loading_shimmer.dart';
import 'package:parking_link/core/theme/app_spacing.dart';
import 'package:parking_link/shared/widgets/cache_status_banner.dart';
import 'package:parking_link/shared/widgets/empty_state.dart';
import 'package:parking_link/shared/widgets/app_error_view.dart';
import 'package:parking_link/shared/widgets/error_display.dart';
import 'package:parking_link/shared/widgets/micro_interactions.dart';
import 'package:parking_link/shared/widgets/modern_card.dart';
import 'package:parking_link/core/services/fcm_notification_service.dart';
import 'package:parking_link/shared/widgets/ui_polish_widgets.dart';

class UserMapScreen extends ConsumerStatefulWidget {
  const UserMapScreen({super.key});

  @override
  ConsumerState<UserMapScreen> createState() => _UserMapScreenState();
}

class _UserMapScreenState extends ConsumerState<UserMapScreen> {
  static const _hcmcCoordinate = GeoCoordinate(
    latitude: 10.7769,
    longitude: 106.7009,
  );
  static const _selectedZoom = 16.0;
  static const _sheetExpandedSize = 0.48;

  GoogleMapController? _mapController;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  bool _hasCenteredOnUser = false;
  bool _showLocationPrompt = false;
  GeoCoordinate? _lastAppliedLocation;

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  /// Defers work until after the current frame — never mutate providers in build/sync listen.
  void _afterFrame(void Function() action) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      action();
    });
  }

  void _applyMapCenters(GeoCoordinate center) {
    ref.read(mapSearchCenterProvider.notifier).state = center;
    ref.read(mapCacheCenterProvider.notifier).state = center;
    ref.read(mapQueryCenterProvider.notifier).state = center;
  }

  void _onUserLocationAsyncUpdate(AsyncValue<GeoCoordinate?> next) {
    final position = next.valueOrNull;
    if (position != null) {
      final sameLocation = _lastAppliedLocation != null &&
          _lastAppliedLocation!.latitude == position.latitude &&
          _lastAppliedLocation!.longitude == position.longitude;
      if (!sameLocation) {
        _lastAppliedLocation = position;
        _applyMapCenters(position);
      }
      if (_showLocationPrompt) {
        setState(() => _showLocationPrompt = false);
      }
      if (!_hasCenteredOnUser && _mapController != null) {
        _hasCenteredOnUser = true;
        unawaited(
          _animateTo(
            LatLng(position.latitude, position.longitude),
            ClusteredUserMap.initialZoom,
          ),
        );
      }
      return;
    }

    if (!next.isLoading && !_showLocationPrompt) {
      setState(() => _showLocationPrompt = true);
    }
  }

  void _registerMapScreenListeners() {
    final logger = ref.read(debugLoggerProvider);
    ref.listen<AsyncValue<GeoCoordinate?>>(userLocationProvider, (_, next) {
      _afterFrame(() => _onUserLocationAsyncUpdate(next));
    });

    ref.listen<AsyncValue<UserNearbyLotsSnapshot>>(
      userNearbyLotsSnapshotProvider,
      (_, next) {
        next.whenData((snapshot) {
          _afterFrame(() {
            ref.read(monitoringServiceProvider).logEvent(
                  'user_map_nearby_query',
                  PerformanceMetrics.fromNearbyQuery(
                    lotCount: snapshot.lots.length,
                    mode: snapshot.mode.name,
                    durationMs: 0,
                  ),
                );
          });
        });
      },
    );

    ref.listen<CacheSyncState>(cacheSyncStateProvider, (previous, next) {
      if (previous?.metrics == next.metrics) return;
      _afterFrame(() {
        ref.read(monitoringServiceProvider).logEvent(
              'user_map_cache_metrics',
              PerformanceMetrics.fromCacheMetrics(next.metrics),
            );
      });
    });

    ref.listen(pendingWatchlistLotNavigationProvider, (previous, next) {
      if (next == null) return;
      _afterFrame(() => unawaited(_openLotFromNotification(next)));
    });

    ref.listen<List<MapLotItem>>(mapDisplayItemsProvider, (previous, next) {
      _afterFrame(() {
        final surveying = next.where((item) => item.isSurveying).length;
        logger.logIfChanged(
          'map_screen_display',
          '[Map] display=${next.length} active=${next.length - surveying} surveying=$surveying',
          minLevel: DebugLogLevel.normal,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final lotsAsync = ref.watch(filteredActiveLotsProvider);
    final sheetItemsAsync = ref.watch(sheetDisplayItemsProvider);
    final locationAsync = ref.watch(userLocationProvider);
    final selectedMapLotKey = ref.watch(selectedMapLotKeyProvider);
    final sheetItems = sheetItemsAsync.valueOrNull ?? const <MapLotItem>[];
    final userPosition = locationAsync.valueOrNull;
    final isLoading = locationAsync.isLoading ||
        (sheetItemsAsync.isLoading && sheetItems.isEmpty);
    _registerMapScreenListeners();

    final selectedItem = selectedMapLotKey == null
        ? null
        : sheetItems.cast<MapLotItem?>().firstWhere(
              (item) => item?.mapKey == selectedMapLotKey,
              orElse: () => null,
            );

    return Scaffold(
      body: Stack(
        children: [
          _UserMapLayer(
            key: const ValueKey('user_map_layer'),
            onMapCreated: (controller) {
              _mapController = controller;
              final position = locationAsync.valueOrNull;
              if (position != null && !_hasCenteredOnUser) {
                _hasCenteredOnUser = true;
                _animateTo(
                  LatLng(position.latitude, position.longitude),
                  ClusteredUserMap.initialZoom,
                );
              }
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MapHeaderBar(
                  watchlistBadgeCount:
                      ref.watch(watchlistBadgeCountProvider).valueOrNull ?? 0,
                  onLogoLongPress: () => openDebugMenuFromContext(context, ref),
                  onParkingListTap: _expandSheet,
                ),
                CacheStatusBanner(onRefresh: _handleRefresh),
              ],
            ),
          ),
          if (lotsAsync.hasError)
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: MediaQuery.sizeOf(context).height * 0.28 + AppSpacing.lg,
              child: AppErrorView.fromError(
                lotsAsync.error!,
                compact: true,
                onPrimaryAction: _handleRefresh,
              ),
            ),
          if (_showLocationPrompt &&
              userPosition == null &&
              !locationAsync.isLoading)
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              top: MediaQuery.paddingOf(context).top + 120,
              child: LocationErrorView(
                compact: true,
                serviceDisabled: false,
                onRetry: _centerToUserLocation,
                onManualLocation: _useManualMapCenter,
              ),
            ),
          if (selectedItem != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.sizeOf(context).height * 0.28,
              child: MapLotInfoOverlay(
                item: selectedItem,
                distanceKm: userPosition == null
                    ? null
                    : GeoDistance.kmBetweenCoordinates(
                        userPosition.latitude,
                        userPosition.longitude,
                        selectedItem.lat,
                        selectedItem.lng,
                      ),
                onClose: () {
                  ref.read(selectedMapLotKeyProvider.notifier).state = null;
                },
              ),
            ),
          Positioned(
            right: AppSpacing.md,
            top: MediaQuery.paddingOf(context).top + 154,
            child: MapActionFab(
              icon: Icons.my_location_rounded,
              tooltip: 'Vị trí của tôi',
              onPressed: _centerToUserLocation,
              isPrimary: true,
            ),
          ),
          Positioned(
            left: AppSpacing.md,
            bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.md,
            child: const MapLegend(),
          ),
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.25,
            minChildSize: 0.15,
            maxChildSize: 0.85,
            snap: true,
            snapSizes: const [0.25, 0.48, 0.85],
            builder: (context, scrollController) {
              return _ParkingLotsSheet(
                items: sheetItems,
                scrollController: scrollController,
                userLat: userPosition?.latitude,
                userLng: userPosition?.longitude,
                isLoading: isLoading,
                onItemTap: _selectItemFromList,
                onRefresh: _handleRefresh,
              );
            },
          ),
          if (isLoading && sheetItems.isEmpty)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.35),
                  child: Center(
                    child: ModernCard(
                      enableScaleTap: false,
                      child: SizedBox(
                        width: 280,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                              ),
                              child: SurveyLoadingShimmer(),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Đang tải bãi xe gần đây...',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openLotFromNotification(
    WatchlistNotificationPayload payload,
  ) async {
    ref.read(pendingWatchlistLotNavigationProvider.notifier).state = null;
    ref.read(userMapFilterProvider.notifier).state = UserMapFilter.all;

    await _handleRefresh();

    if (!mounted) return;

    final items = ref.read(sheetDisplayItemsProvider).valueOrNull ?? const [];
    MapLotItem? match;
    for (final item in items) {
      if (item.id == payload.lotId && item.isActive) {
        match = item;
        break;
      }
    }

    if (match != null) {
      await _selectItemFromList(match);
      return;
    }

    ref.read(selectedMapLotKeyProvider.notifier).state =
        'active:${payload.lotId}';
    await _expandSheet();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${payload.lotName} vừa mở cửa — đang cập nhật thông tin bãi.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _expandSheet() async {
    if (!_sheetController.isAttached) return;
    await _sheetController.animateTo(
      _sheetExpandedSize,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _handleRefresh() async {
    final location = ref.read(userLocationProvider).valueOrNull;
    final GeoCoordinate center = location ?? ref.read(mapSearchCenterProvider);

    try {
      await appErrorHandler.runWithRetry(
        action: () async {
          await triggerUserDataSync(
            ref,
            trigger: SyncTrigger.manual,
            center: center,
          );
          await ref
              .read(watchSurveyingLotsUseCaseProvider)
              .sync(center: center);
        },
        contextLabel: 'user_map_refresh',
      );
    } catch (error) {
      if (!mounted) return;
      showMappedErrorSnackBar(
        context,
        error,
        onRetry: _handleRefresh,
        keepExistingData: true,
      );
    }
  }

  Future<void> _useManualMapCenter() async {
    setState(() => _showLocationPrompt = false);
    _applyMapCenters(_hcmcCoordinate);
    await _animateTo(ClusteredUserMap.hcmcCenter, ClusteredUserMap.initialZoom);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Đang hiển thị khu vực TP.HCM. Kéo bản đồ để chọn vị trí khác.',
        ),
      ),
    );
  }

  Future<void> _selectItemFromList(MapLotItem item) async {
    ref.read(selectedMapLotKeyProvider.notifier).state = item.mapKey;
    await _animateTo(LatLng(item.lat, item.lng), _selectedZoom);
    await _expandSheet();
  }

  Future<void> _centerToUserLocation() async {
    try {
      final position = await ref.refresh(userLocationProvider.future);
      if (position == null) {
        if (!mounted) return;
        setState(() => _showLocationPrompt = true);
        await _animateTo(
          ClusteredUserMap.hcmcCenter,
          ClusteredUserMap.initialZoom,
        );
        return;
      }

      setState(() => _showLocationPrompt = false);
      _applyMapCenters(position);

      await _animateTo(
        LatLng(position.latitude, position.longitude),
        ClusteredUserMap.initialZoom,
      );
    } catch (error) {
      if (!mounted) return;
      showMappedErrorSnackBar(context, error, onRetry: _centerToUserLocation);
    }
  }

  Future<void> _animateTo(LatLng target, double zoom) async {
    final controller = _mapController;
    if (controller == null) return;

    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(target, zoom),
    );
  }
}

class _UserMapLayer extends ConsumerWidget {
  final ValueChanged<GoogleMapController> onMapCreated;

  const _UserMapLayer({
    super.key,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapItems = ref.watch(mapDisplayItemsProvider);
    final selectedMapLotKey = ref.watch(selectedMapLotKeyProvider);
    final userPosition = ref.watch(userLocationProvider).valueOrNull;

    return RepaintBoundary(
      child: ClusteredUserMap(
        key: const ValueKey('map_layer'),
        items: mapItems,
        selectedMapLotKey: selectedMapLotKey,
        myLocationEnabled: userPosition != null,
        initialTarget: userPosition == null
            ? ClusteredUserMap.hcmcCenter
            : LatLng(userPosition.latitude, userPosition.longitude),
        onMapCreated: onMapCreated,
      ),
    );
  }
}

class _ParkingLotsSheet extends ConsumerWidget {
  final List<MapLotItem> items;
  final ScrollController scrollController;
  final double? userLat;
  final double? userLng;
  final bool isLoading;
  final ValueChanged<MapLotItem> onItemTap;
  final Future<void> Function()? onRefresh;

  const _ParkingLotsSheet({
    required this.items,
    required this.scrollController,
    required this.userLat,
    required this.userLng,
    required this.isLoading,
    required this.onItemTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = ref.read(debugLoggerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final mapFilter = ref.watch(userMapFilterProvider);
    final counts = ref.watch(mapFilterCountsProvider);
    final mapMarkerCount = ref.watch(mapDisplayItemsProvider).length;

    logger.logIfChanged(
      'sheet_status',
      '[Sheet] items=${items.length} mapMarkers=$mapMarkerCount '
          'filter=$mapFilter loading=$isLoading '
          'surveyingNearby=${counts.surveyingNearby}',
      minLevel: DebugLogLevel.normal,
    );

    if (items.isEmpty && !isLoading) {
      return Material(
        color: colorScheme.surface,
        elevation: 0,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
        clipBehavior: Clip.antiAlias,
        child: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: AppSpacing.sm),
                child: DragSheetHandle(),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: _SheetEmptyState(
                mapFilter: mapFilter,
                surveyingNearby: counts.surveyingNearby,
                onRefresh: onRefresh,
                onShowSurveying: () {
                  ref.read(userMapFilterProvider.notifier).state =
                      UserMapFilter.surveying;
                },
              ),
            ),
          ],
        ),
      );
    }

    if (items.isEmpty && isLoading) {
      return Material(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
        clipBehavior: Clip.antiAlias,
        child: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: const [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      );
    }

    return Material(
      color: colorScheme.surface,
      elevation: 0,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusXl),
      ),
      clipBehavior: Clip.antiAlias,
      child: RefreshIndicator(
        onRefresh: onRefresh ?? () async {},
        child: ListView.builder(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          itemCount: items.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _SheetHeader(
                isLoading: isLoading,
              );
            }

            final item = items[index - 1];
            return FadeSlideIn(
              index: index - 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md - 4),
                child: MapLotSheetCard(
                  item: item,
                  distanceKm: _distanceFromUser(item),
                  isSelected: false,
                  onTap: () => onItemTap(item),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  double? _distanceFromUser(MapLotItem item) {
    if (userLat == null || userLng == null) return null;
    return GeoDistance.kmBetweenCoordinates(
      userLat!,
      userLng!,
      item.lat,
      item.lng,
    );
  }
}

class _SheetHeader extends ConsumerWidget {
  final bool isLoading;

  const _SheetHeader({
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapFilter = ref.watch(userMapFilterProvider);
    final counts = ref.watch(mapFilterCountsProvider);
    final surveyingOnlyArea = ref.watch(surveyingOnlyAreaProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DragSheetHandle(),
        const SizedBox(height: AppSpacing.sm),
        if (surveyingOnlyArea && mapFilter == UserMapFilter.all) ...[
          _PotentialOnlyBanner(count: counts.surveyingNearby),
          const SizedBox(height: AppSpacing.sm),
        ],
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.55),
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Icon(
                Icons.place_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(
              child: Text(
                'Các bãi gần đây',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            if (isLoading)
              SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md - 2),
      ],
    );
  }
}

class _PotentialOnlyBanner extends StatelessWidget {
  final int count;

  const _PotentialOnlyBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      color: const Color(0xFFFFB300).withValues(alpha: 0.12),
      enableScaleTap: false,
      padding: const EdgeInsets.all(AppSpacing.md - 2),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: Color(0xFFFF8F00),
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Chưa có bãi đang mở, nhưng có $count bãi tiềm năng gần đây',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8D6E00),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetEmptyState extends StatelessWidget {
  final UserMapFilter mapFilter;
  final int surveyingNearby;
  final Future<void> Function()? onRefresh;
  final VoidCallback onShowSurveying;

  const _SheetEmptyState({
    required this.mapFilter,
    required this.surveyingNearby,
    required this.onRefresh,
    required this.onShowSurveying,
  });

  @override
  Widget build(BuildContext context) {
    final hasSurveyingPotential = surveyingNearby > 0 &&
        (mapFilter == UserMapFilter.activeOpen ||
            mapFilter == UserMapFilter.availableOnly);

    if (hasSurveyingPotential) {
      return EmptyStateView(
        icon: Icons.construction_outlined,
        title: 'Chưa có bãi đang mở',
        subtitle:
            'Nhưng có $surveyingNearby bãi tiềm năng gần đây — khám phá và theo dõi để nhận thông báo khi mở cửa.',
        action: FilledButton.icon(
          onPressed: onShowSurveying,
          icon: const Icon(Icons.explore_rounded, size: 18),
          label: Text('Xem bãi khảo sát ($surveyingNearby)'),
        ),
      );
    }

    if (mapFilter == UserMapFilter.surveying) {
      return EmptyStateView(
        icon: Icons.construction_outlined,
        title: 'Không có bãi khảo sát gần đây',
        subtitle: 'Thử di chuyển bản đồ hoặc bật "Hiện tất cả bãi xe"',
        action: OutlinedButton.icon(
          onPressed: () => onRefresh?.call(),
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Làm mới'),
        ),
      );
    }

    return EmptyStateView(
      icon: Icons.local_parking_outlined,
      title: 'Không tìm thấy bãi xe',
      subtitle: 'Thử di chuyển bản đồ hoặc bật "Hiện tất cả bãi xe"',
      action: OutlinedButton.icon(
        onPressed: () => onRefresh?.call(),
        icon: const Icon(Icons.refresh_rounded, size: 18),
        label: const Text('Làm mới'),
      ),
    );
  }
}
