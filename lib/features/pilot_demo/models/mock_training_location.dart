class MockTrainingLocation {
  static const typeNearby = 'gần bạn';
  static const typePartnerGym = 'phòng gym liên kết';

  final String name;
  final String address;
  final String type;

  const MockTrainingLocation({
    required this.name,
    required this.address,
    required this.type,
  });
}
