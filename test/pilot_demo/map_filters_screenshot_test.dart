import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/data/mock_gyms.dart';
import 'package:psgy/features/pilot_demo/models/mock_gym.dart';
import 'package:psgy/features/pilot_demo/presentation/pilot_map_screen.dart';

class _FakeGoogleMapsPlatform extends GoogleMapsFlutterPlatform {
  @override
  Future<void> init(int mapId) async {}

  @override
  Future<void> updateMapOptions(
    Map<String, dynamic> optionsUpdate, {
    required int mapId,
  }) async {}

  @override
  Future<void> updateMarkers(
    MarkerUpdates markerUpdates, {
    required int mapId,
  }) async {}

  @override
  Future<void> updateGroundOverlays(
    GroundOverlayUpdates groundOverlayUpdates, {
    required int mapId,
  }) async {}

  @override
  Future<void> updatePolygons(
    PolygonUpdates polygonUpdates, {
    required int mapId,
  }) async {}

  @override
  Future<void> updatePolylines(
    PolylineUpdates polylineUpdates, {
    required int mapId,
  }) async {}

  @override
  Future<void> updateCircles(
    CircleUpdates circleUpdates, {
    required int mapId,
  }) async {}

  @override
  Future<void> updateTileOverlays({
    required Set<TileOverlay> newTileOverlays,
    required int mapId,
  }) async {}

  @override
  Widget buildView(
    int creationId,
    PlatformViewCreatedCallback onPlatformViewCreated, {
    required CameraPosition initialCameraPosition,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
    Set<Marker> markers = const <Marker>{},
    Set<Polygon> polygons = const <Polygon>{},
    Set<Polyline> polylines = const <Polyline>{},
    Set<Circle> circles = const <Circle>{},
    Set<TileOverlay> tileOverlays = const <TileOverlay>{},
    Map<String, dynamic> mapOptions = const <String, dynamic>{},
  }) {
    return const ColoredBox(color: Color(0xFFE8EAED));
  }
}

Future<void> _loadFamily(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) return;
  final bytes = ByteData.sublistView(Uint8List.fromList(file.readAsBytesSync()));
  final loader = FontLoader(family)..addFont(Future.value(bytes));
  await loader.load();
}

Future<void> _loadScreenshotFonts() async {
  await _loadFamily(
    'Inter',
    '/Users/ruka/Library/Fonts/Inter_18pt-Regular.ttf',
  );
  await _loadFamily(
    'MaterialIcons',
    '/Users/ruka/developer/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
}

ThemeData _theme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00A0E0)),
  );
}

Widget _wrap(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: _theme(),
    home: child,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    GoogleMapsFlutterPlatform.instance = _FakeGoogleMapsPlatform();
    return _loadScreenshotFonts();
  });

  test('mock gyms seed both source types', () {
    expect(
      mockGyms.where((gym) => gym.gymSourceType == MockGym.sourcePartner),
      hasLength(5),
    );
    expect(
      mockGyms.where((gym) => gym.gymSourceType == MockGym.sourceCollected),
      hasLength(5),
    );
    final gym = mockGyms.first;
    expect(
      gym.directionsUri.toString(),
      'https://www.google.com/maps/dir/?api=1&destination=${gym.lat},${gym.lng}',
    );
  });

  testWidgets('map chips filter markers and swap the list panel', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_wrap(const PilotMapScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(const Key('map_chip_coach')), findsOneWidget);
    expect(find.byKey(const Key('map_chip_gym')), findsOneWidget);
    expect(find.text('Coach gần bạn'), findsOneWidget);
    expect(find.text('Hệ thống — đối tác PSgy'), findsNothing);
    expect(find.text('Chỉ đường'), findsNothing);
    expect(find.text(mockCoaches.first.name), findsWidgets);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/map_filters_chips.png'),
    );

    await tester.tap(find.byKey(const Key('map_chip_gym')));
    await tester.pumpAndSettle();
    expect(find.text('Phòng gym'), findsWidgets);
    expect(find.text('Coach gần bạn'), findsNothing);
    expect(find.text('Hệ thống — đối tác PSgy'), findsOneWidget);
    expect(find.text('Thu thập — chỉ tham khảo'), findsOneWidget);
    expect(find.text(mockGyms.first.name), findsOneWidget);
    expect(find.text('Chỉ đường'), findsWidgets);
    expect(find.text('hệ thống'), findsWidgets);
    expect(find.text('thu thập'), findsWidgets);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/map_filters_gym_layer.png'),
    );
  });
}
