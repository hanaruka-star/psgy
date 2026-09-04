import 'package:psgy/features/pilot_demo/models/mock_coach_review.dart';

final List<MockCoachReview> mockCoachReviews = [
  MockCoachReview(
    id: 'rev_01',
    coachId: 'coach_01',
    reviewerName: 'Trần Minh Anh',
    rating: 5,
    comment:
        'Buổi tập rất rõ mục tiêu, Long chỉnh form kỹ. Mình thấy tiến bộ rõ sau 2 tuần.',
    date: DateTime(2026, 9, 3),
  ),
  MockCoachReview(
    id: 'rev_02',
    coachId: 'coach_01',
    reviewerName: 'Lê Hoàng Phúc',
    rating: 4,
    comment:
        'Chuyên môn tốt, lịch linh hoạt. Muốn anh nói chậm hơn một chút khi hướng dẫn máy.',
    date: DateTime(2026, 9, 1),
  ),
  MockCoachReview(
    id: 'rev_03',
    coachId: 'coach_01',
    reviewerName: 'Ngô Nhật Hà',
    rating: 5,
    comment:
        'Từng tập gym tự phát, giờ có giáo án giảm mỡ rõ ràng. Recommend.',
    date: DateTime(2026, 8, 28),
  ),
  MockCoachReview(
    id: 'rev_04',
    coachId: 'coach_01',
    reviewerName: 'Phạm Quốc Huy',
    rating: 3,
    comment:
        'Tập ổn nhưng đôi lúc đến muộn khoảng 10 phút. Nội dung buổi thì ổn.',
    date: DateTime(2026, 8, 22),
  ),
  MockCoachReview(
    id: 'rev_05',
    coachId: 'coach_01',
    reviewerName: 'Vũ Thanh Trúc',
    rating: 5,
    comment:
        'Kèm dinh dưỡng khá sát. Mình giữ được streak 3 tuần nhờ anh nhắc.',
    date: DateTime(2026, 8, 18),
  ),
  MockCoachReview(
    id: 'rev_06',
    coachId: 'coach_01',
    reviewerName: 'Đặng Khoa',
    rating: 2,
    comment:
        'Buổi đầu hơi dồn bài, mình chưa kịp theo. Mong điều chỉnh nhịp cho người mới.',
    date: DateTime(2026, 8, 12),
  ),
  MockCoachReview(
    id: 'rev_07',
    coachId: 'coach_01',
    reviewerName: 'Bùi Lan Phương',
    rating: 4,
    comment: 'Tập cặp với bạn cũng ổn. Giá gói 10 buổi hợp lý hơn tập lẻ.',
    date: DateTime(2026, 8, 8),
  ),
  MockCoachReview(
    id: 'rev_08',
    coachId: 'coach_01',
    reviewerName: 'Mai Đức Thịnh',
    rating: 5,
    comment:
        'Kinh nghiệm lâu năm thấy rõ. Nhắc form squat rất chi tiết, vai đỡ đau hơn.',
    date: DateTime(2026, 8, 3),
  ),
];

List<MockCoachReview> reviewsForCoach(String coachId) {
  final list =
      mockCoachReviews.where((review) => review.coachId == coachId).toList();
  list.sort((a, b) => b.date.compareTo(a.date));
  return list;
}
