import 'package:flutter/foundation.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/models/mock_booking_request.dart';
import 'package:psgy/features/pilot_demo/models/mock_message.dart';
import 'package:psgy/features/pilot_demo/models/mock_user_profile.dart';
import 'package:psgy/features/pilot_demo/models/mock_wallet_package.dart';

/// In-memory user session for the pilot. Not persisted across app restarts.
class MockUserSession extends ChangeNotifier {
  MockUserSession._();

  static final MockUserSession instance = MockUserSession._();

  MockUserProfile? profile;
  String? _verifiedPhone;
  List<MockWalletPackage> wallets = [];
  List<MockBookingRequest> bookings = [];
  final Map<String, List<MockMessage>> messages = {};

  List<MockWalletPackage> get usableWallets {
    final open = wallets.where((w) => w.remainingBalanceVnd > 0).toList();
    open.sort((a, b) => b.remainingBalanceVnd.compareTo(a.remainingBalanceVnd));
    return open;
  }

  void rememberVerifiedPhone(String? phone) {
    _verifiedPhone = phone;
  }

  void createProfile({required String name, String? avatarPath}) {
    profile = MockUserProfile(
      id: 'user_${DateTime.now().microsecondsSinceEpoch}',
      phone: _verifiedPhone ?? '',
      name: name.trim(),
      avatarPath: avatarPath,
      createdAt: DateTime.now(),
    );
    notifyListeners();
  }

  void purchasePackage(String packageId) {
    final package = mockSystemPackages.firstWhere((item) => item.id == packageId);
    wallets = [
      ...wallets,
      MockWalletPackage(
        id: 'wal_${DateTime.now().microsecondsSinceEpoch}',
        packageId: package.id,
        packageName: package.name,
        totalPriceVnd: package.totalPriceVnd,
        remainingBalanceVnd: package.totalPriceVnd,
        purchasedAt: DateTime.now(),
        validityDays: package.validityDays,
      ),
    ];
    notifyListeners();
  }

  MockBookingRequest placeBooking({
    required String coachId,
    required String coachName,
    required String serviceName,
    required int priceVnd,
    required String requestedTimeLabel,
    required MockPaymentMethod paymentMethod,
    String? walletId,
    required int topUpAmountVnd,
  }) {
    if (paymentMethod == MockPaymentMethod.wallet && walletId != null) {
      final deduct = priceVnd - topUpAmountVnd;
      wallets = [
        for (final wallet in wallets)
          if (wallet.id == walletId)
            wallet.copyWith(
              remainingBalanceVnd: wallet.remainingBalanceVnd - deduct,
            )
          else
            wallet,
      ];
    }

    final user = profile;
    final name = user?.name ?? 'Khách';
    final booking = MockBookingRequest(
      id: 'ubk_${DateTime.now().microsecondsSinceEpoch}',
      userName: name,
      userAvatarInitials: _initials(name),
      serviceName: serviceName,
      priceVnd: priceVnd,
      requestedTimeLabel: requestedTimeLabel,
      locationLabel: 'Coach đến chỗ bạn',
      status: MockBookingStatus.pending,
      paymentMethod: paymentMethod,
      topUpAmountVnd: topUpAmountVnd,
      coachId: coachId,
      coachName: coachName,
    );
    bookings = [...bookings, booking];
    messages[booking.id] = [
      MockMessage(
        id: 'msg_${booking.id}_welcome',
        senderRole: MockSenderRole.coach,
        text: 'Chào bạn, mình đã nhận lịch. Nhắn mình nếu cần đổi giờ nhé.',
        sentAtLabel: 'Bây giờ',
      ),
    ];
    notifyListeners();
    return booking;
  }

  MockBookingRequest? bookingById(String id) {
    for (final booking in bookings) {
      if (booking.id == id) return booking;
    }
    return null;
  }

  List<MockMessage> messagesFor(String bookingId) {
    return List<MockMessage>.unmodifiable(messages[bookingId] ?? const []);
  }

  void updateBookingStatus(
    String bookingId,
    MockBookingStatus status, {
    int? rating,
    String? reviewComment,
  }) {
    bookings = [
      for (final booking in bookings)
        if (booking.id == bookingId)
          booking.copyWith(
            status: status,
            rating: rating,
            reviewComment: reviewComment,
          )
        else
          booking,
    ];
    notifyListeners();
  }

  void addUserMessage(String bookingId, String text) {
    final now = DateTime.now();
    final label =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final next = MockMessage(
      id: 'msg_${now.microsecondsSinceEpoch}',
      senderRole: MockSenderRole.user,
      text: text,
      sentAtLabel: label,
    );
    messages[bookingId] = [...messagesFor(bookingId), next];
    notifyListeners();
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
