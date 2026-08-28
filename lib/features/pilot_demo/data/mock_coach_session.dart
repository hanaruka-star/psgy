import 'package:flutter/foundation.dart';
import 'package:psgy/features/pilot_demo/models/mock_booking_request.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach_profile.dart';
import 'package:psgy/features/pilot_demo/models/mock_message.dart';
import 'package:psgy/features/pilot_demo/models/mock_service.dart';

/// In-memory coach session for the 22/08 pilot. Not persisted.
class MockCoachSession extends ChangeNotifier {
  MockCoachSession._()
      : profile = _seedProfile,
        bookings = List<MockBookingRequest>.of(_seedBookings),
        services = List<MockService>.of(_seedServices),
        messages = {
          for (final entry in _seedMessages.entries)
            entry.key: List<MockMessage>.of(entry.value),
        };

  static final MockCoachSession instance = MockCoachSession._();

  static const _locationCycle = [
    'Quận 2, TP.HCM',
    'Quận 1, TP.HCM',
    'Quận 7, TP.HCM',
    'Thủ Đức, TP.HCM',
  ];

  MockCoachProfile profile;
  List<MockBookingRequest> bookings;
  List<MockService> services;
  final Map<String, List<MockMessage>> messages;

  List<MockBookingRequest> get pendingBookings => bookings
      .where((booking) => booking.status == MockBookingStatus.pending)
      .toList();

  List<MockBookingRequest> get activeBookings =>
      bookings.where((booking) => booking.isActive).toList();

  MockBookingRequest? bookingById(String id) {
    for (final booking in bookings) {
      if (booking.id == id) return booking;
    }
    return null;
  }

  List<MockMessage> messagesFor(String bookingId) {
    return List<MockMessage>.unmodifiable(messages[bookingId] ?? const []);
  }

  void setAvailable(bool value) {
    profile = profile.copyWith(isAvailableNow: value);
    notifyListeners();
  }

  void cycleLocation() {
    final current = _locationCycle.indexOf(profile.currentLocationLabel);
    final next = _locationCycle[(current + 1) % _locationCycle.length];
    profile = profile.copyWith(currentLocationLabel: next);
    notifyListeners();
  }

  void updateBookingStatus(
    String bookingId,
    MockBookingStatus status, {
    String? cancelReason,
  }) {
    bookings = [
      for (final booking in bookings)
        if (booking.id == bookingId)
          booking.copyWith(status: status, cancelReason: cancelReason)
        else
          booking,
    ];
    notifyListeners();
  }

  void addCoachMessage(String bookingId, String text) {
    final now = DateTime.now();
    final label =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final next = MockMessage(
      id: 'msg_${now.microsecondsSinceEpoch}',
      senderRole: MockSenderRole.coach,
      text: text,
      sentAtLabel: label,
    );
    messages[bookingId] = [...messagesFor(bookingId), next];
    notifyListeners();
  }

  void upsertService(MockService service) {
    final index = services.indexWhere((item) => item.id == service.id);
    if (index < 0) {
      services = [...services, service];
    } else {
      services = [
        for (var i = 0; i < services.length; i++)
          if (i == index) service else services[i],
      ];
    }
    notifyListeners();
  }

  void removeService(String id) {
    services = services.where((item) => item.id != id).toList();
    notifyListeners();
  }
}

const _seedProfile = MockCoachProfile(
  id: 'coach_01',
  name: 'Nguyễn Văn Long',
  avatarInitials: 'NL',
  bio:
      'HLV thể hình, tập trung tăng cơ và giảm mỡ. Từng làm việc tại California Fitness.',
  yearsExperience: 8,
  ratingAvg: 4.8,
  ratingCount: 126,
  isAvailableNow: true,
  availableFrom: '17:00',
  availableUntil: '20:00',
  currentLocationLabel: 'Quận 2, TP.HCM',
);

const _seedServices = [
  MockService(
    id: 'svc_personal_60',
    name: 'Tập cá nhân 60 phút',
    priceVnd: 300000,
    durationMinutes: 60,
  ),
  MockService(
    id: 'svc_duo_60',
    name: 'Tập cặp đôi 60 phút',
    priceVnd: 500000,
    durationMinutes: 60,
  ),
  MockService(
    id: 'svc_nutrition',
    name: 'Tư vấn dinh dưỡng',
    priceVnd: 150000,
    durationMinutes: 45,
  ),
];

const _seedBookings = [
  MockBookingRequest(
    id: 'bk_pending',
    userName: 'Trần Minh Anh',
    userAvatarInitials: 'TA',
    serviceName: 'Tập cá nhân 60 phút',
    priceVnd: 300000,
    requestedTimeLabel: 'Hôm nay, 18:00',
    locationLabel: 'Vincom Đồng Khởi, Quận 1',
    status: MockBookingStatus.pending,
  ),
  MockBookingRequest(
    id: 'bk_confirmed',
    userName: 'Lê Thị Hương',
    userAvatarInitials: 'LH',
    serviceName: 'Tư vấn dinh dưỡng',
    priceVnd: 150000,
    requestedTimeLabel: 'Hôm nay, 19:30',
    locationLabel: 'The Vista, Quận 2',
    status: MockBookingStatus.confirmed,
  ),
  MockBookingRequest(
    id: 'bk_in_progress',
    userName: 'Phạm Quốc Bảo',
    userAvatarInitials: 'PB',
    serviceName: 'Tập cặp đôi 60 phút',
    priceVnd: 500000,
    requestedTimeLabel: 'Hôm nay, 17:00',
    locationLabel: 'Masteri Thảo Điền, Quận 2',
    status: MockBookingStatus.inProgress,
  ),
];

const _seedMessages = {
  'bk_pending': [
    MockMessage(
      id: 'msg_p1',
      senderRole: MockSenderRole.user,
      text: 'Chào coach, em muốn tập buổi tối nay được không ạ?',
      sentAtLabel: '16:40',
    ),
  ],
  'bk_confirmed': [
    MockMessage(
      id: 'msg_c1',
      senderRole: MockSenderRole.user,
      text: 'Chào coach, em book buổi 19h30 ạ.',
      sentAtLabel: '15:10',
    ),
    MockMessage(
      id: 'msg_c2',
      senderRole: MockSenderRole.coach,
      text: 'Ok em, anh sẽ đến đúng giờ.',
      sentAtLabel: '15:12',
    ),
  ],
  'bk_in_progress': [
    MockMessage(
      id: 'msg_i1',
      senderRole: MockSenderRole.user,
      text: 'Coach ơi, em đang ở sảnh tầng 1.',
      sentAtLabel: '16:55',
    ),
    MockMessage(
      id: 'msg_i2',
      senderRole: MockSenderRole.coach,
      text: 'Ok anh, em xuống ngay.',
      sentAtLabel: '16:56',
    ),
    MockMessage(
      id: 'msg_i3',
      senderRole: MockSenderRole.user,
      text: 'Em mặc áo xanh ạ.',
      sentAtLabel: '16:57',
    ),
  ],
};
