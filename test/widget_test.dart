import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psgy/core/config/app_mode.dart';
import 'package:psgy/core/config/flavor.dart';
import 'package:psgy/core/theme/app_theme.dart';
import 'package:psgy/features/common/presentation/screens/app_root_screen.dart';

void main() {
  testWidgets('ModeSwitcherScreen builds for user flavor', (tester) async {
    FlavorConfig.initialize(AppFlavor.user);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appModeProvider.overrideWith((ref) => AppModeController()),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ModeSwitcherScreen(),
        ),
      ),
    );

    expect(find.byType(ModeSwitcherScreen), findsOneWidget);
  });
}
