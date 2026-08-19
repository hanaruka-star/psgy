class SurveyingLotEntity {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String status;
  final DateTime? surveyedAt;
  final DateTime? estimatedOpeningAt;
  final int? estimatedSlots;
  final int? estimatedCarSlots;
  final int? estimatedMotoSlots;
  final int carPrice;
  final int motoPrice;
  final int totalSlots;
  final String vehicleTypes;
  final String category;
  final String? photoUrl;
  final String notes;
  final String source;
  final String surveyor;

  const SurveyingLotEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.status,
    this.surveyedAt,
    this.estimatedOpeningAt,
    this.estimatedSlots,
    this.estimatedCarSlots,
    this.estimatedMotoSlots,
    this.carPrice = 0,
    this.motoPrice = 0,
    this.totalSlots = 0,
    this.vehicleTypes = '',
    this.category = '',
    this.photoUrl,
    this.notes = '',
    this.source = '',
    this.surveyor = '',
  });

  bool get isSurveying => status == 'surveying' || status == 'planned';
  bool get hasCar => vehicleTypes == 'both' || vehicleTypes == 'car';
  bool get hasMoto => vehicleTypes == 'both' || vehicleTypes == 'moto';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SurveyingLotEntity &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            address == other.address &&
            lat == other.lat &&
            lng == other.lng &&
            status == other.status &&
            surveyedAt == other.surveyedAt &&
            estimatedOpeningAt == other.estimatedOpeningAt &&
            estimatedSlots == other.estimatedSlots &&
            estimatedCarSlots == other.estimatedCarSlots &&
            estimatedMotoSlots == other.estimatedMotoSlots &&
            carPrice == other.carPrice &&
            motoPrice == other.motoPrice &&
            totalSlots == other.totalSlots &&
            vehicleTypes == other.vehicleTypes &&
            category == other.category &&
            photoUrl == other.photoUrl &&
            notes == other.notes &&
            source == other.source &&
            surveyor == other.surveyor;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        address,
        lat,
        lng,
        status,
        surveyedAt,
        estimatedOpeningAt,
        estimatedSlots,
        estimatedCarSlots,
        estimatedMotoSlots,
        carPrice,
        motoPrice,
        totalSlots,
        vehicleTypes,
        category,
        photoUrl,
        notes,
        source,
        surveyor,
      );
}
