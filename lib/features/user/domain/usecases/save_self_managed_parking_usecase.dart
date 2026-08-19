import 'package:parking_link/features/user/domain/entities/my_parking_record.dart';
import 'package:parking_link/features/user/domain/entities/parking_enums.dart';
import 'package:parking_link/features/user/domain/repositories/i_my_parking_repository.dart';

class SaveSelfManagedParkingUseCase {
  const SaveSelfManagedParkingUseCase(this._repository);

  final IMyParkingRepository _repository;

  Future<void> call({
    required double latitude,
    required double longitude,
    String? photoPath,
  }) async {
    final record = MyParkingRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      parkedAt: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
      photoPath: photoPath,
      type: ParkingRecordType.selfManaged,
    );
    await _repository.saveRecord(record);
  }
}
