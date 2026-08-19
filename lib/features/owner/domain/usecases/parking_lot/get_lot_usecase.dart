import 'package:psgy/features/owner/domain/repositories/owner_repository.dart';
import 'package:psgy/features/parking/domain/entities/parking_lot_entity.dart';

class GetLotUseCase {
  final OwnerRepository repository;

  GetLotUseCase(this.repository);

  Future<ParkingLotEntity> call(String lotId) {
    if (lotId.trim().isEmpty) {
      throw ArgumentError('lotId must not be empty');
    }

    return repository.getLot(lotId);
  }
}
