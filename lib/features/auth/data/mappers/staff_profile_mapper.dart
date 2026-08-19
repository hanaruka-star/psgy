import 'package:parking_link/features/auth/data/models/staff_profile_model.dart';
import 'package:parking_link/features/auth/domain/entities/staff_profile_entity.dart';

class StaffProfileMapper {
  const StaffProfileMapper._();

  static StaffProfileEntity toEntity(StaffProfileModel model) {
    return StaffProfileEntity(
      uid: model.uid,
      name: model.name,
      email: model.email,
      role: model.role,
      lotId: model.lotId,
      isActive: model.isActive,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
