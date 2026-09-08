/// Phòng gym mock trên bản đồ User. Độc lập với địa điểm tập của từng Coach.
class MockGym {
  /// Hệ thống tự thu thập — chỉ tham khảo, chưa phải đối tác PSgy.
  static const sourceCollected = 'thu thập';

  /// Đối tác chính thức của hệ thống PSgy.
  static const sourcePartner = 'hệ thống';

  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String gymSourceType;

  const MockGym({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.gymSourceType,
  });

  bool get isPartner => gymSourceType == sourcePartner;

  Uri get directionsUri => Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
      );
}
