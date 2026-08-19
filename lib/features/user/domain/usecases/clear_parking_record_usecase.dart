import 'package:parking_link/features/user/domain/repositories/i_my_parking_repository.dart';

class ClearParkingRecordUseCase {
  const ClearParkingRecordUseCase(this._repository);

  final IMyParkingRepository _repository;

  Future<void> call() => _repository.clearRecord();
}
