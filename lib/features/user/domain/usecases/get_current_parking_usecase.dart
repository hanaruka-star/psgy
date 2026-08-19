import 'package:parking_link/features/user/domain/entities/my_parking_record.dart';
import 'package:parking_link/features/user/domain/repositories/i_my_parking_repository.dart';

class GetCurrentParkingUseCase {
  const GetCurrentParkingUseCase(this._repository);

  final IMyParkingRepository _repository;

  Future<MyParkingRecord?> call() => _repository.getCurrentRecord();
}
