class MockCoachReview {
  final String id;
  final String coachId;
  final String reviewerName;
  final int rating;
  final String comment;
  final DateTime date;

  const MockCoachReview({
    required this.id,
    required this.coachId,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class MockCoachReviewStats {
  const MockCoachReviewStats({
    required this.count,
    required this.average,
    required this.countsByStar,
  });

  final int count;
  final double average;
  final List<int> countsByStar;

  double percentOf(int star) {
    if (count == 0) return 0;
    return countsByStar[star] / count;
  }

  String get summaryLabel =>
      '${average.toStringAsFixed(1)}/5 · $count đánh giá';
}

MockCoachReviewStats reviewStatsFor(Iterable<MockCoachReview> reviews) {
  final counts = List<int>.filled(6, 0);
  var sum = 0;
  var count = 0;
  for (final review in reviews) {
    if (review.rating < 1 || review.rating > 5) continue;
    counts[review.rating] += 1;
    sum += review.rating;
    count += 1;
  }
  return MockCoachReviewStats(
    count: count,
    average: count == 0 ? 0 : sum / count,
    countsByStar: counts,
  );
}
