import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:psgy/features/pilot_demo/data/mock_ai_exercises.dart';
import 'package:psgy/features/pilot_demo/data/mock_coach_reviews.dart';
import 'package:psgy/features/pilot_demo/data/mock_coach_session.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/data/mock_gyms.dart';
import 'package:psgy/features/pilot_demo/data/mock_journal_seed.dart';
import 'package:psgy/features/pilot_demo/models/mock_badge.dart';
import 'package:psgy/features/pilot_demo/models/mock_booking_request.dart';

String iso(DateTime d) => d.toIso8601String();

Map<String, Object?> coachJson(coach) {
  final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  return {
    'id': coach.id,
    'name': coach.name,
    'initials': coach.initials,
    'avatarAsset': coach.avatarAsset,
    'rating': coach.rating,
    'yearsExperience': coach.yearsExperience,
    'distanceKm': coach.distanceKm,
    'nextSlotLabel': coach.nextSlotLabel,
    'lat': coach.lat,
    'lng': coach.lng,
    'bio': coach.bio,
    'photoUrls': coach.photoUrls,
    'totalBookings': coach.totalBookings,
    'goals': coach.goals,
    'targetAudience': coach.targetAudience,
    'trainingFormats': coach.trainingFormats,
    'gymFeeIncluded': coach.gymFeeIncluded,
    'membershipFeeLabel': coach.membershipFeeLabel,
    'certifications': coach.certifications,
    'bookingCancellationPolicy': coach.bookingCancellationPolicy,
    'services': [
      for (final s in coach.services)
        {
          'id': s.id,
          'name': s.name,
          'priceVnd': s.priceVnd,
          'priceLabel': s.priceLabel,
          'durationMinutes': s.durationMinutes,
          'promoLabel': s.promoLabel,
        },
    ],
    'packages': [
      for (final p in coach.packages)
        {
          'id': p.id,
          'coachId': p.coachId,
          'name': p.name,
          'sessionCount': p.sessionCount,
          'totalPriceVnd': p.totalPriceVnd,
          'priceLabel': p.priceLabel,
          'description': p.description,
        },
    ],
    'trainingLocations': [
      for (final loc in coach.trainingLocations)
        {'name': loc.name, 'address': loc.address, 'type': loc.type},
    ],
    'studentResults': [
      for (final r in coach.studentResults)
        {
          'studentLabel': r.studentLabel,
          'summary': r.summary,
          'beforeImageUrl': r.beforeImageUrl,
          'afterImageUrl': r.afterImageUrl,
          'timeline': [
            for (final log in r.timeline)
              {'dateLabel': log.dateLabel, 'note': log.note},
          ],
        },
    ],
    'weeklyAvailability': [
      for (final slot in coach.weeklyAvailability)
        {
          'offsetDays': slot.date.difference(today).inDays,
          'dateRule': 'DateTime(now.year, now.month, now.day).add(Duration(days: offsetDays))',
          'startTime': slot.startTime,
          'endTime': slot.endTime,
        },
    ],
  };
}

void writeJson(String name, Object data) {
  final dir = Directory('prototype/docs/audit/04_MOCK_DATA');
  dir.createSync(recursive: true);
  File('${dir.path}/$name').writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(data),
  );
}

void main() {
  test('export mock JSON into 04_MOCK_DATA', () {
    writeJson('coaches.json', {
      '_note':
          'weeklyAvailability.offsetDays tính từ hôm nay (DateTime.now() date-only). Không persist ngày lịch cứng.',
      'coaches': [for (final c in mockCoaches) coachJson(c)],
    });

    writeJson('gyms.json', [
      for (final g in mockGyms)
        {
          'id': g.id,
          'name': g.name,
          'address': g.address,
          'lat': g.lat,
          'lng': g.lng,
          'gymSourceType': g.gymSourceType,
        },
    ]);

    writeJson('reviews.json', [
      for (final r in mockCoachReviews)
        {
          'id': r.id,
          'coachId': r.coachId,
          'reviewerName': r.reviewerName,
          'rating': r.rating,
          'comment': r.comment,
          'date': iso(r.date),
        },
    ]);

    writeJson('sample_users.json', [
      for (final u in mockSampleUsers)
        {
          'id': u.id,
          'phone': u.phone,
          'name': u.name,
          'avatarPath': u.avatarPath,
          'createdAt': iso(u.createdAt),
        },
    ]);

    writeJson('journal_posts.json', [
      for (final p in mockSeedJournalPosts)
        {
          'id': p.id,
          'userId': p.userId,
          'bookingId': p.bookingId,
          'coachId': p.coachId,
          'coachName': p.coachName,
          'serviceName': p.serviceName,
          'durationMinutes': p.durationMinutes,
          'caption': p.caption,
          'mediaUrl': p.mediaUrl,
          'privacy': p.privacy.name,
          'createdAt': iso(p.createdAt),
          'likeUserIds': p.likeUserIds,
          'commentCount': p.commentCount,
          'reported': p.reported,
        },
    ]);

    writeJson('journal_comments.json', [
      for (final c in mockSeedJournalComments)
        {
          'id': c.id,
          'postId': c.postId,
          'authorId': c.authorId,
          'authorName': c.authorName,
          'text': c.text,
          'createdAt': iso(c.createdAt),
        },
    ]);

    writeJson('badges.json', [
      for (final b in mockBadges)
        {
          'id': b.id,
          'name': b.name,
          'description': b.description,
          'iconAsset': b.iconAsset,
          '_note': 'iconAsset là key logic, không phải file PNG. UI map sang Material Icon.',
        },
    ]);

    writeJson('streak.json', {
      'initial': {
        'userId': '',
        'currentStreak': 0,
        'longestStreak': 0,
        'lastCompletedDate': null,
      },
      'rules': {
        'onCreateProfile': 'UserStreak(userId: profile.id)',
        'onBookingCompleted':
            'cùng ngày → giữ streak; hôm qua → +1; còn lại → reset 1; cập nhật longestStreak. lastCompletedDate = date-only của DateTime.now()',
        'badges': {
          'completedCount==1': 'badge_first_session',
          'currentStreak==3': 'badge_streak_3',
          'currentStreak==7': 'badge_streak_7',
        },
      },
    });

    writeJson('pt_ai_exercises.json', [
      for (final e in mockAiExercises)
        {
          'id': e.id,
          'name': e.name,
          'description': e.description,
          'durationSeconds': e.durationSeconds,
          'thumbnailAsset': e.thumbnailAsset,
          'cues': [
            for (final cue in e.cues)
              {'atSecond': cue.atSecond, 'message': cue.message},
          ],
        },
    ]);

    final session = MockCoachSession.instance;
    writeJson('coach_session_seed.json', {
      'profile': {
        'id': session.profile.id,
        'name': session.profile.name,
        'avatarInitials': session.profile.avatarInitials,
        'ratingAvg': session.profile.ratingAvg,
        'ratingCount': session.profile.ratingCount,
        'yearsExperience': session.profile.yearsExperience,
        'isAvailableNow': session.profile.isAvailableNow,
        'availableFrom': session.profile.availableFrom,
        'availableUntil': session.profile.availableUntil,
        'currentLocationLabel': session.profile.currentLocationLabel,
        'hoursLabel': session.profile.hoursLabel,
        'bio': session.profile.bio,
      },
      'locationCycle': [
        'Quận 2, TP.HCM',
        'Quận 1, TP.HCM',
        'Quận 7, TP.HCM',
        'Thủ Đức, TP.HCM',
      ],
      'bookings': [
        for (final b in session.bookings) _bookingJson(b),
      ],
      'messages': {
        for (final id in ['bk_pending', 'bk_confirmed', 'bk_in_progress'])
          id: [
            for (final m in session.messagesFor(id))
              {
                'id': m.id,
                'senderRole': m.senderRole.name,
                'text': m.text,
                'sentAtLabel': m.sentAtLabel,
              },
          ],
      },
      'studentJournalPosts': [
        for (final p in session.studentJournalPosts)
          {
            'id': p.id,
            'userId': p.userId,
            'bookingId': p.bookingId,
            'coachId': p.coachId,
            'coachName': p.coachName,
            'serviceName': p.serviceName,
            'durationMinutes': p.durationMinutes,
            'caption': p.caption,
            'mediaUrl': p.mediaUrl,
            'privacy': p.privacy.name,
            'createdAt': iso(p.createdAt),
          },
      ],
    });

    writeJson('user_runtime.json', {
      'bookings':
          '[] lúc mở app. Được tạo bởi MockUserSession.placeBooking. id = bk_<microsecondsSinceEpoch>. requestedTimeLabel copy từ coach.nextSlotLabel. locationLabel cố định "Coach đến chỗ bạn".',
      'purchasedPackages':
          '[] lúc mở app. purchasePackage(pkg) → remainingSessions = sessionCount, purchasedAt = DateTime.now().',
      'messages': {
        'welcomeOnPlaceBooking':
            'Chào bạn, mình đã nhận lịch. Nhắn mình nếu cần đổi giờ nhé. sentAtLabel = Bây giờ',
        'inquiryOnEnsureCoachInquiry':
            'Chào bạn, mình trao đổi địa chỉ và lịch tập tại đây trước khi bạn đặt nhé. sentAtLabel = Bây giờ',
      },
      'otpDemo': 'Mã demo: 123456 — mọi OTP 6 chữ số đều pass.',
    });

    writeJson('README.json', {
      'model':
          'Gói theo từng Coach (MockPackage.coachId). KHÔNG còn ví hệ thống / user_wallet_screen / mockSystemPackages / tab Ví.',
      'generationRules': {
        'weeklyAvailability':
            'date = DateTime(now.year, now.month, now.day).add(Duration(days: offsetDays))',
        'userProfile.createdAt': 'DateTime.now() khi createProfile()',
        'purchasedPackage.purchasedAt': 'DateTime.now() khi purchasePackage()',
        'booking.id / journalPost.id / message.id':
            'prefix + DateTime.now().microsecondsSinceEpoch',
      },
    });
  });
}

Map<String, Object?> _bookingJson(MockBookingRequest b) {
  return {
    'id': b.id,
    'userName': b.userName,
    'userAvatarInitials': b.userAvatarInitials,
    'serviceName': b.serviceName,
    'priceVnd': b.priceVnd,
    'priceLabel': b.priceLabel,
    'requestedTimeLabel': b.requestedTimeLabel,
    'locationLabel': b.locationLabel,
    'status': b.status.name,
    'statusLabel': b.statusLabel,
    'cancelReason': b.cancelReason,
    'paymentMethod': b.paymentMethod.name,
    'purchasedPackageId': b.purchasedPackageId,
    'purchasedPackageName': b.purchasedPackageName,
    'rating': b.rating,
    'reviewComment': b.reviewComment,
    'coachId': b.coachId,
    'coachName': b.coachName,
  };
}
