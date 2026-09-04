import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/coach_services_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/coach_detail_screen.dart';

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

class _FourTabShell extends StatelessWidget {
  const _FourTabShell();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: const Center(child: Text('Bản đồ')),
      bottomNavigationBar: NavigationBar(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Bản đồ',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories),
            label: 'Nhật ký',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Cộng đồng',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Lịch sử',
          ),
        ],
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(_loadScreenshotFonts);

  testWidgets('coach_services_screen has Dịch vụ and Gói tabs', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_wrap(const CoachServicesScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Dịch vụ'), findsWidgets);
    expect(find.text('Gói'), findsOneWidget);
    expect(find.text('Tập cá nhân 60 phút'), findsOneWidget);

    await expectLater(
      find.byType(CoachServicesScreen),
      matchesGoldenFile('goldens/coach_services_tab_services.png'),
    );

    await tester.tap(find.text('Gói'));
    await tester.pumpAndSettle();
    expect(find.text('Gói 10 buổi'), findsOneWidget);

    await expectLater(
      find.byType(CoachServicesScreen),
      matchesGoldenFile('goldens/coach_services_tab_packages.png'),
    );
  });

  testWidgets('coach_detail_screen Gói tab shows that coach packages', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_wrap(CoachDetailScreen(coach: mockCoaches.first)));
    await tester.pumpAndSettle();

    expect(find.text('Dịch vụ'), findsWidgets);
    expect(find.text('Gói'), findsOneWidget);

    await tester.tap(find.text('Gói'));
    await tester.pumpAndSettle();
    expect(find.text('Gói 10 buổi'), findsOneWidget);
    expect(find.text('Mua'), findsWidgets);

    await expectLater(
      find.byType(CoachDetailScreen),
      matchesGoldenFile('goldens/coach_detail_tab_packages.png'),
    );
  });

  testWidgets('bottom bar has 4 tabs without Ví', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_wrap(const _FourTabShell()));
    await tester.pumpAndSettle();

    expect(find.text('Bản đồ'), findsWidgets);
    expect(find.text('Nhật ký'), findsOneWidget);
    expect(find.text('Cộng đồng'), findsOneWidget);
    expect(find.text('Lịch sử'), findsOneWidget);
    expect(find.text('Ví'), findsNothing);

    await expectLater(
      find.byType(_FourTabShell),
      matchesGoldenFile('goldens/user_bottom_bar_4_tabs.png'),
    );
  });
}
