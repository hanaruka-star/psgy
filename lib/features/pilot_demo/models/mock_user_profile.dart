class MockUserProfile {
  final String id;
  final String phone;
  final String name;
  final String? avatarPath;
  final DateTime createdAt;

  const MockUserProfile({
    required this.id,
    required this.phone,
    required this.name,
    this.avatarPath,
    required this.createdAt,
  });
}
