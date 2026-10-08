import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psgy/core/config/app_config.dart';
import 'package:psgy/core/config/flavor.dart';
import 'package:psgy/core/routes/app_navigator.dart';
import 'package:psgy/core/theme/app_shapes.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/core/theme/app_text_styles.dart';
import 'package:psgy/core/theme/debug_theme_switcher.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/coach_home_screen.dart';

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

ThemeData _offlineLight() {
  const seed = Color(0xFF00A0E0);
  final scheme = ColorScheme.fromSeed(seedColor: seed);
  final textTheme = AppTextStyles.textTheme(isDark: false);
  final canvas = AppStatusColors.sheetBackground(Brightness.light);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Inter',
    textTheme: textTheme,
    scaffoldBackgroundColor: canvas,
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      backgroundColor: canvas,
      foregroundColor: scheme.onSurface,
      titleTextStyle: textTheme.titleLarge,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppStatusColors.cardBackground(
        isDark: false,
        surface: scheme.surface,
      ),
      surfaceTintColor: Colors.transparent,
      shape: AppShapes.rect(radius: AppSpacing.radiusMd),
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        elevation: 0,
        shape: AppShapes.rect(radius: AppSpacing.radiusMd),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppStatusColors.tagBackground(
        isDark: false,
        surface: scheme.surface,
      ),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      side: BorderSide.none,
      shape: AppShapes.rect(radius: AppSpacing.radiusSm),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: Colors.transparent,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: canvas,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: AppShapes.sheetTop(),
    ),
  );
}

Widget _wrap(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    navigatorKey: appNavigatorKey,
    theme: DebugThemeController.instance.themeData,
    themeMode: ThemeMode.light,
    builder: (context, appChild) {
      return DebugThemeStyles.wrap(appChild ?? const SizedBox.shrink());
    },
    home: child,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    DebugThemeController.debugBaseThemeOverride = _offlineLight();
    AppConfig.initialize();
    FlavorConfig.initialize(AppFlavor.coach);
    return _loadScreenshotFonts();
  });

  setUp(() {
    DebugThemeController.instance.setStyle(DebugThemeStyle.minimal);
  });

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const CoachHomeScreen()));
    await tester.pump();
    await tester.runAsync(() async {
      final context = tester.element(find.byType(MaterialApp));
      for (final coach in mockCoaches) {
        await precacheImage(AssetImage(coach.avatarAsset), context);
      }
    });
    await tester.pumpAndSettle();
  }

  testWidgets('minimal shows debug palette FAB', (tester) async {
    await pumpHome(tester);
    expect(find.byKey(const Key('debug_theme_fab')), findsOneWidget);
    expect(find.byIcon(Icons.palette_outlined), findsOneWidget);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/debug_theme_minimal.png'),
    );
  });

  testWidgets('dark / glass / neumorph change the same home screen', (
    tester,
  ) async {
    await pumpHome(tester);

    DebugThemeController.instance.setStyle(DebugThemeStyle.dark);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/debug_theme_dark.png'),
    );

    DebugThemeController.instance.setStyle(DebugThemeStyle.glass);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/debug_theme_glass.png'),
    );

    DebugThemeController.instance.setStyle(DebugThemeStyle.neumorph);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/debug_theme_neumorph.png'),
    );
  });

  testWidgets('palette FAB opens the 4-style sheet', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.byKey(const Key('debug_theme_fab')));
    await tester.pumpAndSettle();

    expect(find.text('Minimal (hiện tại)'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('Glass'), findsOneWidget);
    expect(find.text('Neumorph'), findsOneWidget);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/debug_theme_menu.png'),
    );
  });
}
