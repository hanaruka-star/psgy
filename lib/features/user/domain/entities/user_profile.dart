class UserProfile {
  final String userId;
  final String phoneNumber;
  final String? displayName;
  final DateTime createdAt;

  const UserProfile({
    required this.userId,
    required this.phoneNumber,
    this.displayName,
    required this.createdAt,
  });

  UserProfile copyWith({
    String? userId,
    String? phoneNumber,
    String? displayName,
    DateTime? createdAt,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserProfile &&
            runtimeType == other.runtimeType &&
            userId == other.userId &&
            phoneNumber == other.phoneNumber &&
            displayName == other.displayName &&
            createdAt == other.createdAt;
  }

  @override
  int get hashCode =>
      Object.hash(userId, phoneNumber, displayName, createdAt);
}
