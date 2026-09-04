import 'package:psgy/features/pilot_demo/models/mock_journal_comment.dart';
import 'package:psgy/features/pilot_demo/models/mock_journal_post.dart';
import 'package:psgy/features/pilot_demo/models/mock_user_profile.dart';

final mockSampleUserKhoa = MockUserProfile(
  id: 'sample_user_01',
  phone: '0901111111',
  name: 'Phạm Minh Khoa',
  createdAt: DateTime(2026, 6, 12),
);

final mockSampleUserHa = MockUserProfile(
  id: 'sample_user_02',
  phone: '0902222222',
  name: 'Ngô Thanh Hà',
  createdAt: DateTime(2026, 5, 3),
);

final mockSampleUserViet = MockUserProfile(
  id: 'sample_user_03',
  phone: '0903333333',
  name: 'Đặng Quốc Việt',
  createdAt: DateTime(2026, 4, 20),
);

final mockSampleUsers = [
  mockSampleUserKhoa,
  mockSampleUserHa,
  mockSampleUserViet,
];

final mockSeedJournalPosts = [
  JournalPost(
    id: 'jp_seed_01',
    userId: mockSampleUserKhoa.id,
    bookingId: 'seed_bk_khoa_01',
    coachId: 'coach_01',
    coachName: 'Nguyễn Văn Long',
    serviceName: 'Tập cá nhân 60 phút',
    durationMinutes: 60,
    caption:
        'Buổi đầu với anh Long khá căng nhưng form đúng hơn hẳn. Hẹn tuần sau!',
    mediaUrl: 'assets/images/journal/seed_01.jpg',
    privacy: JournalPrivacy.public,
    createdAt: DateTime(2026, 8, 26, 19, 10),
    likeUserIds: [mockSampleUserHa.id, mockSampleUserViet.id],
    commentCount: 2,
  ),
  JournalPost(
    id: 'jp_seed_02',
    userId: mockSampleUserHa.id,
    bookingId: 'seed_bk_ha_01',
    coachId: 'coach_02',
    coachName: 'Trần Thị Mai',
    serviceName: 'Tư vấn dinh dưỡng',
    durationMinutes: 45,
    caption:
        'Chị Mai chỉnh lại thực đơn rất rõ. Bớt tinh bột tối, ngủ ngon hơn.',
    mediaUrl: 'assets/images/journal/seed_02.jpg',
    privacy: JournalPrivacy.public,
    createdAt: DateTime(2026, 8, 25, 10, 30),
    likeUserIds: [mockSampleUserKhoa.id],
    commentCount: 1,
  ),
  JournalPost(
    id: 'jp_seed_03',
    userId: mockSampleUserViet.id,
    bookingId: 'seed_bk_viet_01',
    coachId: 'coach_01',
    coachName: 'Nguyễn Văn Long',
    serviceName: 'Tập cặp đôi 60 phút',
    durationMinutes: 60,
    caption: 'Tập cặp với bạn, anh Long keep tempo rất đều. Mồ hôi ướt áo.',
    mediaUrl: 'assets/images/journal/seed_03.jpg',
    privacy: JournalPrivacy.public,
    createdAt: DateTime(2026, 8, 24, 18, 45),
    likeUserIds: [mockSampleUserKhoa.id, mockSampleUserHa.id],
    commentCount: 1,
  ),
  JournalPost(
    id: 'jp_seed_04',
    userId: mockSampleUserViet.id,
    bookingId: 'seed_bk_viet_02',
    coachId: 'coach_03',
    coachName: 'Lê Hoàng Nam',
    serviceName: 'Tập cá nhân 60 phút',
    durationMinutes: 60,
    caption: 'Nam cho bài core mới. Ngày mai chắc đau nhưng đáng.',
    mediaUrl: 'assets/images/journal/seed_04.jpg',
    privacy: JournalPrivacy.public,
    createdAt: DateTime(2026, 8, 22, 7, 20),
    likeUserIds: const [],
    commentCount: 1,
  ),
];

final mockSeedJournalComments = [
  JournalComment(
    id: 'jc_seed_01',
    postId: 'jp_seed_01',
    authorId: mockSampleUserHa.id,
    authorName: mockSampleUserHa.name,
    text: 'Form chuẩn là tiến nhanh lắm. Cố lên Khoa!',
    createdAt: DateTime(2026, 8, 26, 19, 40),
  ),
  JournalComment(
    id: 'jc_seed_02',
    postId: 'jp_seed_01',
    authorId: mockSampleUserViet.id,
    authorName: mockSampleUserViet.name,
    text: 'Anh Long soi squat rất kỹ. Mình cũng đang tập với ảnh.',
    createdAt: DateTime(2026, 8, 26, 20, 5),
  ),
  JournalComment(
    id: 'jc_seed_03',
    postId: 'jp_seed_02',
    authorId: mockSampleUserKhoa.id,
    authorName: mockSampleUserKhoa.name,
    text: 'Xin thực đơn mẫu với Hà ơi.',
    createdAt: DateTime(2026, 8, 25, 11, 15),
  ),
  JournalComment(
    id: 'jc_seed_04',
    postId: 'jp_seed_03',
    authorId: mockSampleUserHa.id,
    authorName: mockSampleUserHa.name,
    text: 'Tập cặp vui hơn tập một mình thật.',
    createdAt: DateTime(2026, 8, 24, 19, 10),
  ),
  JournalComment(
    id: 'jc_seed_05',
    postId: 'jp_seed_04',
    authorId: mockSampleUserKhoa.id,
    authorName: mockSampleUserKhoa.name,
    text: 'Core của Nam là huyền thoại.',
    createdAt: DateTime(2026, 8, 22, 8, 0),
  ),
];
