import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/presentation/booking_summary_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/coach_detail_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/user_chat_screen.dart';

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

  testWidgets('coach_detail shows intro, rating bars, and comments', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_wrap(CoachDetailScreen(coach: mockCoaches.first)));
    await tester.pumpAndSettle();

    expect(find.text('Giới thiệu'), findsOneWidget);
    expect(find.textContaining('/5 ·'), findsOneWidget);
    expect(find.text('Bình luận khách hàng'), findsOneWidget);
    expect(find.text('Trần Minh Anh'), findsOneWidget);

    await expectLater(
      find.byType(CoachDetailScreen),
      matchesGoldenFile('goldens/coach_detail_intro_reviews.png'),
    );
  });

  testWidgets('booking_summary has address, chat, and promo cards', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final coach = mockCoaches.first;
    await tester.pumpWidget(
      _wrap(
        BookingSummaryScreen(
          coach: coach,
          service: coach.services.first,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Địa chỉ'), findsOneWidget);
    expect(find.text('Trao đổi với Coach'), findsOneWidget);
    expect(find.text('Mã giảm giá'), findsOneWidget);
    expect(find.text('Áp dụng'), findsOneWidget);

    await expectLater(
      find.byType(BookingSummaryScreen),
      matchesGoldenFile('goldens/booking_summary_address_promo.png'),
    );
  });

  testWidgets('pre-booking coach inquiry chat opens without booking', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _wrap(
        UserChatScreen(
          inquiryCoachId: mockCoaches.first.id,
          coachName: mockCoaches.first.name,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nguyễn Văn Long'), findsOneWidget);
    expect(find.text('Trao đổi trước khi đặt lịch'), findsOneWidget);
    expect(find.textContaining('địa chỉ và lịch tập'), findsOneWidget);

    await expectLater(
      find.byType(UserChatScreen),
      matchesGoldenFile('goldens/user_chat_pre_booking_inquiry.png'),
    );
  });
}
