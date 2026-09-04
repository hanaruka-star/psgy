enum JournalPrivacy { private, coachOnly, public }

class JournalPost {
  final String id;
  final String userId;
  final String bookingId;
  final String coachId;
  final String coachName;
  final String serviceName;
  final int durationMinutes;
  final String caption;
  final String? mediaUrl;
  final JournalPrivacy privacy;
  final DateTime createdAt;
  final List<String> likeUserIds;
  final int commentCount;
  final bool reported;

  const JournalPost({
    required this.id,
    required this.userId,
    required this.bookingId,
    required this.coachId,
    required this.coachName,
    required this.serviceName,
    required this.durationMinutes,
    required this.caption,
    this.mediaUrl,
    required this.privacy,
    required this.createdAt,
    this.likeUserIds = const [],
    this.commentCount = 0,
    this.reported = false,
  });

  JournalPost copyWith({
    List<String>? likeUserIds,
    int? commentCount,
    bool? reported,
  }) {
    return JournalPost(
      id: id,
      userId: userId,
      bookingId: bookingId,
      coachId: coachId,
      coachName: coachName,
      serviceName: serviceName,
      durationMinutes: durationMinutes,
      caption: caption,
      mediaUrl: mediaUrl,
      privacy: privacy,
      createdAt: createdAt,
      likeUserIds: likeUserIds ?? this.likeUserIds,
      commentCount: commentCount ?? this.commentCount,
      reported: reported ?? this.reported,
    );
  }
}
