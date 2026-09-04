class UserStreak {
  final String userId;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCompletedDate;

  const UserStreak({
    required this.userId,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCompletedDate,
  });

  UserStreak copyWith({
    String? userId,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastCompletedDate,
  }) {
    return UserStreak(
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
    );
  }
}
