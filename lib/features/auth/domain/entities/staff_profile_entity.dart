class StaffProfileEntity {
  final String uid;
  final String name;
  final String email;
  final String role;
  final String lotId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StaffProfileEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.lotId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  String get normalizedRole => role.trim().replaceAll('"', '').toLowerCase();

  bool get isOwner => normalizedRole == 'owner';

  bool get isStaff => normalizedRole == 'staff';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StaffProfileEntity &&
            runtimeType == other.runtimeType &&
            uid == other.uid &&
            name == other.name &&
            email == other.email &&
            role == other.role &&
            lotId == other.lotId &&
            isActive == other.isActive &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        uid,
        name,
        email,
        role,
        lotId,
        isActive,
        createdAt,
        updatedAt,
      );
}
