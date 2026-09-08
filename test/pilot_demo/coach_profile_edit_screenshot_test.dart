import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psgy/core/config/app_config.dart';
import 'package:psgy/features/pilot_demo/data/mock_coach_session.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach_profile.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/coach_home_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/coach_profile_edit_screen.dart';

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
    AppConfig.initialize();
    return _loadScreenshotFonts();
  });

  late MockCoachProfile originalProfile;

  setUp(() {
    originalProfile = MockCoachSession.instance.profile;
  });

  tearDown(() {
    MockCoachSession.instance.updateProfile(originalProfile);
  });

  test('coach_01 MockCoachProfile is a one-time copy of MockCoach', () {
    final public = mockCoaches.firstWhere((coach) => coach.id == 'coach_01');
    final profile = MockCoachSession.instance.profile;

    expect(profile.id, public.id);
    expect(profile.name, public.name);
    expect(profile.bio, public.bio);
    expect(profile.goals, public.goals);
    expect(profile.targetAudience, public.targetAudience);
    expect(profile.trainingFormats, public.trainingFormats);
    expect(profile.certifications, public.certifications);
    expect(profile.gymFeeIncluded, public.gymFeeIncluded);
    expect(profile.membershipFeeLabel, public.membershipFeeLabel);
    expect(
      profile.bookingCancellationPolicy,
      public.bookingCancellationPolicy,
    );
    expect(profile.trainingLocations.length, public.trainingLocations.length);
    expect(
      profile.weeklyAvailability.length,
      public.weeklyAvailability.length,
    );
    expect(
      identical(profile.goals, public.goals),
      isFalse,
      reason: 'copy 1 lần, không share list với MockCoach',
    );
  });

  testWidgets('edit screen pre-fills coach_01 public catalog values', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final public = mockCoaches.firstWhere((coach) => coach.id == 'coach_01');

    await tester.pumpWidget(_wrap(const CoachProfileEditScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Chỉnh sửa hồ sơ'), findsOneWidget);
    expect(find.text(public.name), findsOneWidget);
    expect(find.text(public.bio), findsOneWidget);
    expect(
      tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'Tăng cơ')).selected,
      isTrue,
    );
    expect(
      tester
          .widget<FilterChip>(find.widgetWithText(FilterChip, 'Phục hồi sau chấn thương'))
          .selected,
      isFalse,
    );
    expect(
      MockCoachSession.instance.profile.certifications,
      contains('ACE Personal Trainer'),
    );
    expect(
      MockCoachSession.instance.profile.trainingLocations.first.name,
      'Công viên Landmark 81',
    );

    await expectLater(
      find.byType(CoachProfileEditScreen),
      matchesGoldenFile('goldens/coach_profile_edit_initial.png'),
    );
  });

  testWidgets('save writes MockCoachProfile only and survives reopen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final publicBioBefore = mockCoaches
        .firstWhere((coach) => coach.id == 'coach_01')
        .bio;

    await tester.pumpWidget(_wrap(const CoachHomeScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chỉnh sửa hồ sơ'));
    await tester.pumpAndSettle();

    final bioField = find.byKey(const Key('coach_profile_bio'));
    await tester.enterText(
      bioField,
      'Bio đã sửa trong Coach app — không đụng MockCoach.',
    );
    await tester.tap(find.widgetWithText(FilterChip, 'Phục hồi sau chấn thương'));
    await tester.pump();

    await tester.tap(find.byKey(const Key('coach_profile_save')));
    await tester.pumpAndSettle();

    expect(MockCoachSession.instance.profile.bio,
        'Bio đã sửa trong Coach app — không đụng MockCoach.');
    expect(
      MockCoachSession.instance.profile.goals,
      contains('Phục hồi sau chấn thương'),
    );
    expect(
      mockCoaches.firstWhere((coach) => coach.id == 'coach_01').bio,
      publicBioBefore,
      reason: 'MockCoach / User catalog must stay untouched',
    );
    expect(
      mockCoaches.firstWhere((coach) => coach.id == 'coach_01').goals,
      isNot(contains('Phục hồi sau chấn thương')),
    );

    await tester.tap(find.text('Chỉnh sửa hồ sơ'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(
      find.text('Bio đã sửa trong Coach app — không đụng MockCoach.'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<FilterChip>(
            find.widgetWithText(FilterChip, 'Phục hồi sau chấn thương'),
          )
          .selected,
      isTrue,
    );

    await expectLater(
      find.byType(CoachProfileEditScreen),
      matchesGoldenFile('goldens/coach_profile_edit_after_save.png'),
    );
  });
}
