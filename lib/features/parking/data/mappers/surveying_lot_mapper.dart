import 'package:parking_link/features/parking/data/models/surveying_lot_model.dart';
import 'package:parking_link/features/parking/domain/entities/surveying_lot_entity.dart';

class SurveyingLotMapper {
  const SurveyingLotMapper._();

  static SurveyingLotEntity toEntity(SurveyingLotModel model) {
    return SurveyingLotEntity(
      id: model.id,
      name: model.name,
      address: model.address,
      lat: model.lat,
      lng: model.lng,
      status: model.status,
      surveyedAt: model.surveyedAt,
      estimatedOpeningAt: model.estimatedOpeningAt,
      estimatedSlots: model.estimatedSlots,
      estimatedCarSlots: model.estimatedCarSlots,
      estimatedMotoSlots: model.estimatedMotoSlots,
      carPrice: model.carPrice,
      motoPrice: model.motoPrice,
      totalSlots: model.totalSlots,
      vehicleTypes: model.vehicleTypes,
      category: model.category,
      photoUrl: model.photoUrl,
      notes: model.notes,
      source: model.source,
      surveyor: model.surveyor,
    );
  }
}
