class MockCoachProfile {
  final String id;
  final String name;
  final String avatarInitials;
  final String bio;
  final int yearsExperience;
  final double ratingAvg;
  final int ratingCount;
  final bool isAvailableNow;
  final String availableFrom;
  final String availableUntil;
  final String currentLocationLabel;

  const MockCoachProfile({
    required this.id,
    required this.name,
    required this.avatarInitials,
    required this.bio,
    required this.yearsExperience,
    required this.ratingAvg,
    required this.ratingCount,
    required this.isAvailableNow,
    required this.availableFrom,
    required this.availableUntil,
    required this.currentLocationLabel,
  });

  String get hoursLabel => '$availableFrom - $availableUntil';

  MockCoachProfile copyWith({
    bool? isAvailableNow,
    String? currentLocationLabel,
  }) {
    return MockCoachProfile(
      id: id,
      name: name,
      avatarInitials: avatarInitials,
      bio: bio,
      yearsExperience: yearsExperience,
      ratingAvg: ratingAvg,
      ratingCount: ratingCount,
      isAvailableNow: isAvailableNow ?? this.isAvailableNow,
      availableFrom: availableFrom,
      availableUntil: availableUntil,
      currentLocationLabel: currentLocationLabel ?? this.currentLocationLabel,
    );
  }
}
