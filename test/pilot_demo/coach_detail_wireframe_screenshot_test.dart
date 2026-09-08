import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/models/mock_training_location.dart';
import 'package:psgy/features/pilot_demo/presentation/coach_detail_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/student_result_detail_screen.dart';

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

  setUpAll(_loadScreenshotFonts);

  test('all 6 coaches have wireframe profile fields', () {
    expect(mockCoaches, hasLength(6));
    for (final coach in mockCoaches) {
      expect(coach.photoUrls, hasLength(5), reason: coach.id);
      expect(coach.bio.length, inInclusiveRange(500, 800), reason: coach.id);
      expect(coach.totalBookings, greaterThan(0), reason: coach.id);
      expect(coach.goals, isNotEmpty, reason: coach.id);
      expect(coach.targetAudience, isNotEmpty, reason: coach.id);
      expect(coach.trainingFormats, isNotEmpty, reason: coach.id);
      expect(coach.trainingLocations.length, greaterThanOrEqualTo(2),
          reason: coach.id);
      expect(
        coach.trainingLocations
            .any((item) => item.type == MockTrainingLocation.typeNearby),
        isTrue,
        reason: coach.id,
      );
      expect(
        coach.trainingLocations
            .any((item) => item.type == MockTrainingLocation.typePartnerGym),
        isTrue,
        reason: coach.id,
      );
      expect(coach.studentResults, isNotEmpty, reason: coach.id);
      expect(coach.weeklyAvailability, isNotEmpty, reason: coach.id);
      expect(
        coach.services.where((item) => item.promoLabel != null).length,
        inInclusiveRange(1, 2),
        reason: coach.id,
      );
      expect(coach.certifications, isNotEmpty, reason: coach.id);
      expect(coach.bookingCancellationPolicy, isNotEmpty, reason: coach.id);
    }
  });

  for (final spec in [
    (file: '01', coach: mockCoaches[0]),
    (file: '02', coach: mockCoaches[1]),
  ]) {
    testWidgets('coach_detail ${spec.coach.id} top / services / reviews', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_wrap(CoachDetailScreen(coach: spec.coach)));
      await tester.pump();
      await tester.runAsync(() async {
        final context = tester.element(find.byType(MaterialApp));
        for (final url in spec.coach.photoUrls.toSet()) {
          await precacheImage(AssetImage(url), context);
        }
      });
      await tester.pumpAndSettle();

      expect(find.text(spec.coach.name), findsWidgets);
      expect(find.text('Về tôi'), findsOneWidget);
      expect(find.text('1/5'), findsOneWidget);

      await expectLater(
        find.byType(CoachDetailScreen),
        matchesGoldenFile('goldens/coach_detail_${spec.file}_top.png'),
      );

      await tester.scrollUntilVisible(
        find.text('Mục tiêu'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CoachDetailScreen),
        matchesGoldenFile('goldens/coach_detail_${spec.file}_mid.png'),
      );
      expect(find.text('Chọn HLV'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Lịch trống'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CoachDetailScreen),
        matchesGoldenFile('goldens/coach_detail_${spec.file}_week.png'),
      );

      await tester.scrollUntilVisible(
        find.text('Chọn dịch vụ'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CoachDetailScreen),
        matchesGoldenFile('goldens/coach_detail_${spec.file}_services.png'),
      );
      expect(find.text('Chọn HLV'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Kết quả học viên'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CoachDetailScreen),
        matchesGoldenFile('goldens/coach_detail_${spec.file}_results.png'),
      );

      await tester.scrollUntilVisible(
        find.text('Chính sách booking/cancellation'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CoachDetailScreen),
        matchesGoldenFile('goldens/coach_detail_${spec.file}_reviews.png'),
      );
      expect(find.text('Chọn HLV'), findsOneWidget);
    });
  }

  testWidgets('student result detail and certificate viewer', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final coach = mockCoaches.first;
    await tester.pumpWidget(_wrap(CoachDetailScreen(coach: coach)));
    await tester.pump();
    await tester.runAsync(() async {
      final context = tester.element(find.byType(MaterialApp));
      for (final url in {
        ...coach.photoUrls,
        for (final result in coach.studentResults) ...[
          result.beforeImageUrl,
          result.afterImageUrl,
        ],
        ...mockCertificatePhotos,
      }) {
        await precacheImage(AssetImage(url), context);
      }
    });
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Xem chi tiết').first,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xem chi tiết').first);
    await tester.pumpAndSettle();
    expect(find.text('Nhật ký tiến độ'), findsOneWidget);
    await expectLater(
      find.byType(StudentResultDetailScreen),
      matchesGoldenFile('goldens/student_result_detail.png'),
    );

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('ACE Personal Trainer'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('ACE Personal Trainer'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(Dialog),
      matchesGoldenFile('goldens/certificate_viewer.png'),
    );
  });
}
