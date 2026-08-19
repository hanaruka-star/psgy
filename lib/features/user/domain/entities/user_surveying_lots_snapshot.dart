import 'package:parking_link/features/parking/domain/entities/surveying_lot_entity.dart';

enum UserSurveyingLotsQueryMode {
  cache,
  geohash,
  clientSide,
  fallbackAll,
}

class UserSurveyingLotsSnapshot {
  final List<SurveyingLotEntity> lots;
  final UserSurveyingLotsQueryMode mode;

  const UserSurveyingLotsSnapshot({
    required this.lots,
    required this.mode,
  });
}
