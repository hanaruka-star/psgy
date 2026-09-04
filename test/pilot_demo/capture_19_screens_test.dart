import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/data/mock_coach_session.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';
import 'package:psgy/core/config/app_config.dart';
import 'package:psgy/features/pilot_demo/models/mock_booking_request.dart';
import 'package:psgy/features/pilot_demo/presentation/booking_pending_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/booking_summary_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/active_booking_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/booking_request_detail_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/coach_chat_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/coach_home_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/coach_student_journal_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/coach_detail_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/community_feed_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/create_journal_post_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/journal_post_detail_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/main_shell_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/mock_phone_auth_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/my_journal_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/pilot_list_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/user_booking_history_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/user_chat_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/user_profile_setup_screen.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

/// Fake GoogleMapsFlutterPlatform để widget test không crash khi IndexedStack
/// build cả tab Map (platform view không tồn tại trong môi trường test).
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
    // Widget test: không có platform view thật → render placeholder rỗng
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

/// Setup MockUserSession giống flow thật: profile + 1 booking + 1 journal post.
void _seedUserSession() {
  final session = MockUserSession.instance;
  session.createProfile(name: 'Minh Anh');
  final coach = mockCoaches.first;
  final service = coach.services.first;
  session.placeBooking(
    coachId: coach.id,
    coachName: coach.name,
    serviceName: service.name,
    priceVnd: service.priceVnd,
    requestedTimeLabel: 'Hôm nay 18:00',
    paymentMethod: MockPaymentMethod.cash,
  );
  // Đảm bảo journal post có sẵn để các màn Nhật ký không trống.
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    AppConfig.initialize();
    return _loadScreenshotFonts();
  });

  testWidgets('01 MockPhoneAuthScreen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const MockPhoneAuthScreen()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MockPhoneAuthScreen),
      matchesGoldenFile('goldens/01_mock_phone_auth.png'),
    );
  });

  testWidgets('02 UserProfileSetupScreen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const UserProfileSetupScreen()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(UserProfileSetupScreen),
      matchesGoldenFile('goldens/02_user_profile_setup.png'),
    );
  });

  testWidgets('03 PilotListScreen (danh sách coach)', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const PilotListScreen()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(PilotListScreen),
      matchesGoldenFile('goldens/03_pilot_list.png'),
    );
  });

  testWidgets('04 MainShellScreen (bottom bar 4 tab)', (tester) async {
    _seedUserSession();
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    // IndexedStack build cả tab Map (Google Maps platform view) dù ẩn
    // → fake GoogleMapsFlutterPlatform để không crash trong widget test
    GoogleMapsFlutterPlatform.instance = _FakeGoogleMapsPlatform();
    await tester.pumpWidget(_wrap(const MainShellScreen()));
    await tester.pumpAndSettle();
    // Chuyển sang tab "Nhật ký" để chụp shell + bottom bar sạch sẽ
    await tester.tap(find.text('Nhật ký'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MainShellScreen),
      matchesGoldenFile('goldens/04_main_shell.png'),
    );
  });

  testWidgets('05 CoachDetailScreen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _wrap(CoachDetailScreen(coach: mockCoaches.first)),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(CoachDetailScreen),
      matchesGoldenFile('goldens/05_coach_detail.png'),
    );
  });

  testWidgets('06 BookingSummaryScreen', (tester) async {
    final coach = mockCoaches.first;
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _wrap(
        BookingSummaryScreen(coach: coach, service: coach.services.first),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(BookingSummaryScreen),
      matchesGoldenFile('goldens/06_booking_summary.png'),
    );
  });

  testWidgets('07 BookingPendingScreen (theo dõi booking)', (tester) async {
    _seedUserSession();
    final coach = mockCoaches.first;
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    // readOnly: true → KHÔNG chạy _runDemoAdvance (timer 3s auto-advance)
    // tránh "Timer is still pending" khi kết thúc widget test
    await tester.pumpWidget(
      _wrap(
        BookingPendingScreen(
          coach: coach,
          service: coach.services.first,
          booking: MockUserSession.instance.bookings.last,
          readOnly: true,
        ),
      ),
    );
    // Màn có animation vô hạn (timeline/spinner) → không dùng pumpAndSettle
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    await expectLater(
      find.byType(BookingPendingScreen),
      matchesGoldenFile('goldens/07_booking_pending.png'),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('08 UserChatScreen (pre-booking)', (tester) async {
    final coach = mockCoaches.first;
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _wrap(
        UserChatScreen(
          inquiryCoachId: coach.id,
          coachName: coach.name,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(UserChatScreen),
      matchesGoldenFile('goldens/08_user_chat_pre_booking.png'),
    );
  });

  testWidgets('09 UserBookingHistoryScreen', (tester) async {
    _seedUserSession();
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const UserBookingHistoryScreen()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(UserBookingHistoryScreen),
      matchesGoldenFile('goldens/09_user_booking_history.png'),
    );
  });

  testWidgets('10 MyJournalScreen (nhật ký + streak + badge)', (tester) async {
    _seedUserSession();
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const MyJournalScreen()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MyJournalScreen),
      matchesGoldenFile('goldens/10_my_journal.png'),
    );
  });

  testWidgets('11 CommunityFeedScreen', (tester) async {
    _seedUserSession();
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const CommunityFeedScreen()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(CommunityFeedScreen),
      matchesGoldenFile('goldens/11_community_feed.png'),
    );
  });

  testWidgets('12 CreateJournalPostScreen', (tester) async {
    _seedUserSession();
    final coach = mockCoaches.first;
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _wrap(
        CreateJournalPostScreen(
          coach: coach,
          service: coach.services.first,
          booking: MockUserSession.instance.bookings.last,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(CreateJournalPostScreen),
      matchesGoldenFile('goldens/12_create_journal_post.png'),
    );
  });

  testWidgets('13 JournalPostDetailScreen', (tester) async {
    _seedUserSession();
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _wrap(
        JournalPostDetailScreen(
          postId: MockUserSession.instance.journalPosts.first.id,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(JournalPostDetailScreen),
      matchesGoldenFile('goldens/13_journal_post_detail.png'),
    );
  });

  testWidgets('14 CoachHomeScreen (dashboard)', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const CoachHomeScreen()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(CoachHomeScreen),
      matchesGoldenFile('goldens/14_coach_home.png'),
    );
  });

  testWidgets('15 BookingRequestDetailScreen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _wrap(
        BookingRequestDetailScreen(
          bookingId: MockCoachSession.instance.pendingBookings.first.id,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(BookingRequestDetailScreen),
      matchesGoldenFile('goldens/15_booking_request_detail.png'),
    );
  });

  testWidgets('16 ActiveBookingScreen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _wrap(
        ActiveBookingScreen(
          bookingId: MockCoachSession.instance.activeBookings.first.id,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(ActiveBookingScreen),
      matchesGoldenFile('goldens/16_active_booking.png'),
    );
  });

  testWidgets('17 CoachChatScreen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _wrap(
        CoachChatScreen(
          bookingId: MockCoachSession.instance.activeBookings.first.id,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(CoachChatScreen),
      matchesGoldenFile('goldens/17_coach_chat.png'),
    );
  });

  testWidgets('18 CoachStudentJournalScreen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const CoachStudentJournalScreen()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(CoachStudentJournalScreen),
      matchesGoldenFile('goldens/18_coach_student_journal.png'),
    );
  });

  testWidgets('19 UserBookingHistoryScreen (đã có booking)', (tester) async {
    _seedUserSession();
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const UserBookingHistoryScreen()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(UserBookingHistoryScreen),
      matchesGoldenFile('goldens/19_user_history_seeded.png'),
    );
  });
}
