import 'package:flutter/foundation.dart';
import 'package:psgy/features/pilot_demo/data/mock_journal_seed.dart';
import 'package:psgy/features/pilot_demo/models/mock_badge.dart';
import 'package:psgy/features/pilot_demo/models/mock_booking_request.dart';
import 'package:psgy/features/pilot_demo/models/mock_journal_comment.dart';
import 'package:psgy/features/pilot_demo/models/mock_journal_post.dart';
import 'package:psgy/features/pilot_demo/models/mock_message.dart';
import 'package:psgy/features/pilot_demo/models/mock_package.dart';
import 'package:psgy/features/pilot_demo/models/mock_user_profile.dart';
import 'package:psgy/features/pilot_demo/models/mock_user_streak.dart';

/// In-memory user session for the pilot. Not persisted across app restarts.
class MockUserSession extends ChangeNotifier {
  MockUserSession._();

  static final MockUserSession instance = MockUserSession._();

  MockUserProfile? profile;
  String? _verifiedPhone;
  List<MockPurchasedPackage> purchasedPackages = [];
  List<MockBookingRequest> bookings = [];
  final Map<String, List<MockMessage>> messages = {};
  /// Chat trước khi đặt lịch — tách biệt với [messages] theo bookingId.
  final Map<String, List<MockMessage>> coachInquiryMessages = {};
  List<JournalPost> journalPosts = List<JournalPost>.of(mockSeedJournalPosts);
  List<JournalComment> journalComments =
      List<JournalComment>.of(mockSeedJournalComments);
  UserStreak userStreak = const UserStreak(userId: '');
  List<UserBadge> userBadges = [];

  List<MockPurchasedPackage> usablePackagesFor(String coachId) {
    return purchasedPackages
        .where(
          (item) => item.coachId == coachId && item.remainingSessions > 0,
        )
        .toList();
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
    userStreak = UserStreak(userId: profile!.id);
    userBadges = [];
    notifyListeners();
  }

  void purchasePackage(MockPackage package) {
    purchasedPackages = [
      ...purchasedPackages,
      MockPurchasedPackage(
        id: 'own_${DateTime.now().microsecondsSinceEpoch}',
        packageId: package.id,
        coachId: package.coachId,
        packageName: package.name,
        sessionCount: package.sessionCount,
        remainingSessions: package.sessionCount,
        purchasedAt: DateTime.now(),
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
    String? purchasedPackageId,
  }) {
    String? purchasedPackageName;
    if (paymentMethod == MockPaymentMethod.package &&
        purchasedPackageId != null) {
      purchasedPackages = [
        for (final item in purchasedPackages)
          if (item.id == purchasedPackageId && item.remainingSessions > 0)
            item.copyWith(remainingSessions: item.remainingSessions - 1)
          else
            item,
      ];
      for (final item in purchasedPackages) {
        if (item.id == purchasedPackageId) {
          purchasedPackageName = item.packageName;
          break;
        }
      }
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
      purchasedPackageId: purchasedPackageId,
      purchasedPackageName: purchasedPackageName,
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
    final previous = bookingById(bookingId);
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
    if (status == MockBookingStatus.completed &&
        previous?.status != MockBookingStatus.completed) {
      _applyCompletionRewards();
    }
    notifyListeners();
  }

  void addJournalPost({
    required String bookingId,
    required String coachId,
    required String coachName,
    required String serviceName,
    required int durationMinutes,
    required String caption,
    String? mediaUrl,
    required JournalPrivacy privacy,
  }) {
    final userId = profile?.id ?? '';
    journalPosts = [
      ...journalPosts,
      JournalPost(
        id: 'jp_${DateTime.now().microsecondsSinceEpoch}',
        userId: userId,
        bookingId: bookingId,
        coachId: coachId,
        coachName: coachName,
        serviceName: serviceName,
        durationMinutes: durationMinutes,
        caption: caption,
        mediaUrl: mediaUrl,
        privacy: privacy,
        createdAt: DateTime.now(),
      ),
    ];
    notifyListeners();
  }

  MockUserProfile? profileById(String userId) {
    if (profile?.id == userId) return profile;
    for (final user in mockSampleUsers) {
      if (user.id == userId) return user;
    }
    return null;
  }

  String displayNameFor(String userId) {
    return profileById(userId)?.name ?? 'Thành viên';
  }

  JournalPost? journalPostById(String id) {
    for (final post in journalPosts) {
      if (post.id == id) return post;
    }
    return null;
  }

  List<JournalComment> commentsForPost(String postId) {
    final list =
        journalComments.where((comment) => comment.postId == postId).toList();
    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list;
  }

  void toggleJournalLike(String postId) {
    final userId = profile?.id;
    if (userId == null || userId.isEmpty) return;
    journalPosts = [
      for (final post in journalPosts)
        if (post.id == postId)
          post.copyWith(
            likeUserIds: post.likeUserIds.contains(userId)
                ? [
                    for (final id in post.likeUserIds)
                      if (id != userId) id,
                  ]
                : [...post.likeUserIds, userId],
          )
        else
          post,
    ];
    notifyListeners();
  }

  void addJournalComment(String postId, String text) {
    final user = profile;
    final trimmed = text.trim();
    if (user == null || trimmed.isEmpty) return;
    journalComments = [
      ...journalComments,
      JournalComment(
        id: 'jc_${DateTime.now().microsecondsSinceEpoch}',
        postId: postId,
        authorId: user.id,
        authorName: user.name,
        text: trimmed,
        createdAt: DateTime.now(),
      ),
    ];
    journalPosts = [
      for (final post in journalPosts)
        if (post.id == postId)
          post.copyWith(commentCount: post.commentCount + 1)
        else
          post,
    ];
    notifyListeners();
  }

  void reportJournalPost(String postId) {
    journalPosts = [
      for (final post in journalPosts)
        if (post.id == postId) post.copyWith(reported: true) else post,
    ];
    notifyListeners();
  }

  void _applyCompletionRewards() {
    final userId = profile?.id ?? userStreak.userId;
    final today = _dateOnly(DateTime.now());
    final last = userStreak.lastCompletedDate == null
        ? null
        : _dateOnly(userStreak.lastCompletedDate!);

    var current = userStreak.currentStreak;
    if (last == null) {
      current = 1;
    } else if (last == today) {
      current = userStreak.currentStreak;
    } else if (last == today.subtract(const Duration(days: 1))) {
      current = userStreak.currentStreak + 1;
    } else {
      current = 1;
    }

    final longest = current > userStreak.longestStreak
        ? current
        : userStreak.longestStreak;
    userStreak = UserStreak(
      userId: userId,
      currentStreak: current,
      longestStreak: longest,
      lastCompletedDate: today,
    );

    final completedCount = bookings
        .where((booking) => booking.status == MockBookingStatus.completed)
        .length;
    if (completedCount == 1) {
      _awardBadge('badge_first_session', userId);
    }
    if (current == 3) {
      _awardBadge('badge_streak_3', userId);
    }
    if (current == 7) {
      _awardBadge('badge_streak_7', userId);
    }
  }

  void _awardBadge(String badgeId, String userId) {
    final already = userBadges.any((badge) => badge.badgeId == badgeId);
    if (already) return;
    userBadges = [
      ...userBadges,
      UserBadge(
        userId: userId,
        badgeId: badgeId,
        earnedAt: DateTime.now(),
      ),
    ];
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  List<MockMessage> inquiryMessagesFor(String coachId) {
    return List<MockMessage>.unmodifiable(
      coachInquiryMessages[coachId] ?? const [],
    );
  }

  void ensureCoachInquiry(String coachId) {
    if (coachInquiryMessages.containsKey(coachId)) return;
    coachInquiryMessages[coachId] = [
      MockMessage(
        id: 'inq_${coachId}_welcome',
        senderRole: MockSenderRole.coach,
        text:
            'Chào bạn, mình trao đổi địa chỉ và lịch tập tại đây trước khi bạn đặt nhé.',
        sentAtLabel: 'Bây giờ',
      ),
    ];
    notifyListeners();
  }

  void addInquiryMessage(String coachId, String text) {
    final now = DateTime.now();
    final label =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final next = MockMessage(
      id: 'inq_${now.microsecondsSinceEpoch}',
      senderRole: MockSenderRole.user,
      text: text,
      sentAtLabel: label,
    );
    coachInquiryMessages[coachId] = [...inquiryMessagesFor(coachId), next];
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
