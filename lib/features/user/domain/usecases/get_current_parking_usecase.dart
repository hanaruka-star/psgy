import 'package:psgy/features/user/domain/entities/my_parking_record.dart';
import 'package:psgy/features/user/domain/repositories/i_my_parking_repository.dart';

class GetCurrentParkingUseCase {
  const GetCurrentParkingUseCase(this._repository);

  final IMyParkingRepository _repository;

  Future<MyParkingRecord?> call() => _repository.getCurrentRecord();
}
