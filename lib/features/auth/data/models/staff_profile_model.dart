import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:parking_link/features/auth/data/mappers/staff_profile_mapper.dart';
import 'package:parking_link/features/auth/domain/entities/staff_profile_entity.dart';

class StaffProfileModel extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String role;
  final String lotId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StaffProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.lotId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StaffProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return StaffProfileModel(
      uid: (data['uid'] as String?) ?? doc.id,
      name: (data['name'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      role: (data['role'] as String?) ?? 'staff',
      lotId: (data['lotId'] as String?) ?? '',
      isActive: (data['isActive'] as bool?) ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'lotId': lotId,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  StaffProfileEntity toEntity() => StaffProfileMapper.toEntity(this);

  StaffProfileModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? role,
    String? lotId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StaffProfileModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      lotId: lotId ?? this.lotId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        role,
        lotId,
        isActive,
        createdAt,
        updatedAt,
      ];
}
