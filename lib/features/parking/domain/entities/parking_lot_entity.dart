class ParkingLotEntity {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String status;
  final String ownerId;

  const ParkingLotEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.status,
    required this.ownerId,
  });

  bool get isOpen => status == 'open';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ParkingLotEntity &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            address == other.address &&
            lat == other.lat &&
            lng == other.lng &&
            status == other.status &&
            ownerId == other.ownerId;
  }

  @override
  int get hashCode => Object.hash(id, name, address, lat, lng, status, ownerId);
}
