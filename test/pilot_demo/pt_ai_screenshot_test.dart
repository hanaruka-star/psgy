import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:psgy/features/pilot_demo/data/mock_ai_exercises.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_user_streak.dart';
import 'package:psgy/features/pilot_demo/presentation/main_shell_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/pilot_map_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/pt_ai/pt_ai_complete_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/pt_ai/pt_ai_intro_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/pt_ai/pt_ai_picker_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/pt_ai/pt_ai_session_screen.dart';

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

  test('mock PT AI catalog has 6 basic exercises', () {
    expect(mockAiExercises, hasLength(6));
    expect(mockAiExercises.first.name, 'Squat');
    expect(mockAiExercises.first.durationSeconds, 45);
    expect(mockAiExercises.first.cues, isNotEmpty);
  });

  testWidgets('intro landing copy and start button', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const PtAiIntroScreen()));
    await tester.pumpAndSettle();

    expect(find.text(PtAiIntroScreen.title), findsOneWidget);
    expect(find.textContaining('Không cần đặt lịch'), findsOneWidget);
    expect(find.text('Bắt đầu'), findsOneWidget);

    await expectLater(
      find.byType(PtAiIntroScreen),
      matchesGoldenFile('goldens/pt_ai_intro.png'),
    );
  });

  testWidgets('picker lists six exercises', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const PtAiPickerScreen()));
    await tester.pump();
    await tester.runAsync(() async {
      final context = tester.element(find.byType(MaterialApp));
      for (final exercise in mockAiExercises) {
        await precacheImage(AssetImage(exercise.thumbnailAsset), context);
      }
    });
    await tester.pumpAndSettle();

    expect(find.text('Squat'), findsOneWidget);
    expect(find.text('Plank'), findsOneWidget);
    expect(find.text('Bắt đầu tập (1)'), findsOneWidget);

    await expectLater(
      find.byType(PtAiPickerScreen),
      matchesGoldenFile('goldens/pt_ai_picker.png'),
    );
  });

  testWidgets('session overlay shows timer and AI cue', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _wrap(PtAiSessionScreen(exercises: [mockAiExercises.first])),
    );
    await tester.pump();
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 80));
    });
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    expect(find.text('Squat'), findsOneWidget);
    expect(find.text('Bắt đầu! Hạ thấp từ từ'), findsOneWidget);
    expect(find.text('00:42'), findsOneWidget);

    await expectLater(
      find.byType(PtAiSessionScreen),
      matchesGoldenFile('goldens/pt_ai_session.png'),
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('complete screen updates streak and summarizes', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    MockUserSession.instance.userStreak = const UserStreak(userId: 'user_demo');

    await tester.pumpWidget(
      _wrap(
        const PtAiCompleteScreen(exerciseCount: 2, totalSeconds: 75),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Tuyệt vời'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('1 phút 15 giây'), findsOneWidget);
    expect(find.text('Xong'), findsOneWidget);
    expect(MockUserSession.instance.userStreak.currentStreak, 1);

    await expectLater(
      find.byType(PtAiCompleteScreen),
      matchesGoldenFile('goldens/pt_ai_complete.png'),
    );
  });

  testWidgets('map no longer shows the PT AI banner', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const PilotMapScreen()));
    await tester.pump();
    await tester.runAsync(() async {
      final context = tester.element(find.byType(MaterialApp));
      for (final coach in mockCoaches) {
        await precacheImage(AssetImage(coach.avatarAsset), context);
      }
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(const Key('map_chip_coach')), findsOneWidget);
    expect(find.text('AI đồng hành · Camera theo dõi · Tư thế chuẩn'), findsNothing);
    expect(find.byKey(const Key('nav_pt_ai')), findsNothing);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/pt_ai_map_no_banner.png'),
    );
  });

  testWidgets('center PT AI nav opens the intro screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const MainShellScreen()));
    await tester.pump();
    await tester.runAsync(() async {
      final context = tester.element(find.byType(MaterialApp));
      for (final coach in mockCoaches) {
        await precacheImage(AssetImage(coach.avatarAsset), context);
      }
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(const Key('nav_pt_ai')), findsOneWidget);
    expect(find.text('Bản đồ'), findsOneWidget);
    expect(find.text('Nhật ký'), findsOneWidget);
    expect(find.text('Cộng đồng'), findsOneWidget);
    expect(find.text('Lịch sử'), findsOneWidget);

    await expectLater(
      find.byType(MainShellScreen),
      matchesGoldenFile('goldens/pt_ai_nav_center.png'),
    );

    await tester.tap(find.byKey(const Key('nav_pt_ai')));
    await tester.pumpAndSettle();
    expect(find.text(PtAiIntroScreen.title), findsOneWidget);

    await expectLater(
      find.byType(PtAiIntroScreen),
      matchesGoldenFile('goldens/pt_ai_intro_from_nav.png'),
    );
  });
}

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
