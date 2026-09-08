/// Case-study công khai trên hồ sơ Coach (User xem để tin tưởng).
/// Độc lập với Nhật ký / Journal của Coach app.
class MockStudentResultLog {
  final String dateLabel;
  final String note;

  const MockStudentResultLog({
    required this.dateLabel,
    required this.note,
  });
}

class MockStudentResult {
  final String studentLabel;
  final String summary;
  final String beforeImageUrl;
  final String afterImageUrl;
  final List<MockStudentResultLog> timeline;

  const MockStudentResult({
    required this.studentLabel,
    required this.summary,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    required this.timeline,
  });
}
