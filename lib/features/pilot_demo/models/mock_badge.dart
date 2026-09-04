class Badge {
  final String id;
  final String name;
  final String description;
  final String iconAsset;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
  });
}

class UserBadge {
  final String userId;
  final String badgeId;
  final DateTime earnedAt;

  const UserBadge({
    required this.userId,
    required this.badgeId,
    required this.earnedAt,
  });
}

const mockBadges = [
  Badge(
    id: 'badge_first_session',
    name: 'Buổi tập đầu tiên',
    description: 'Hoàn thành buổi tập đầu tiên trên PSgy.',
    iconAsset: 'badge_first_session',
  ),
  Badge(
    id: 'badge_streak_3',
    name: 'Streak 3 ngày',
    description: 'Tập 3 ngày liên tiếp.',
    iconAsset: 'badge_streak_3',
  ),
  Badge(
    id: 'badge_streak_7',
    name: 'Streak 7 ngày',
    description: 'Tập 7 ngày liên tiếp.',
    iconAsset: 'badge_streak_7',
  ),
];
