import 'package:psgy/features/user/domain/entities/parking_enums.dart';

class MyParkingRecord {
  final String id;
  final DateTime parkedAt;
  final double latitude;
  final double longitude;
  final String? photoPath;
  final ParkingRecordType type;
  final String? sessionId;
  final String? lotId;
  final String? lotName;
  final double? lotLatitude;
  final double? lotLongitude;

  const MyParkingRecord({
    required this.id,
    required this.parkedAt,
    required this.latitude,
    required this.longitude,
    this.photoPath,
    required this.type,
    this.sessionId,
    this.lotId,
    this.lotName,
    this.lotLatitude,
    this.lotLongitude,
  });

  MyParkingRecord copyWith({
    String? id,
    DateTime? parkedAt,
    double? latitude,
    double? longitude,
    String? photoPath,
    ParkingRecordType? type,
    String? sessionId,
    String? lotId,
    String? lotName,
    double? lotLatitude,
    double? lotLongitude,
  }) {
    return MyParkingRecord(
      id: id ?? this.id,
      parkedAt: parkedAt ?? this.parkedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photoPath: photoPath ?? this.photoPath,
      type: type ?? this.type,
      sessionId: sessionId ?? this.sessionId,
      lotId: lotId ?? this.lotId,
      lotName: lotName ?? this.lotName,
      lotLatitude: lotLatitude ?? this.lotLatitude,
      lotLongitude: lotLongitude ?? this.lotLongitude,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MyParkingRecord &&
            id == other.id &&
            parkedAt == other.parkedAt &&
            latitude == other.latitude &&
            longitude == other.longitude &&
            photoPath == other.photoPath &&
            type == other.type &&
            sessionId == other.sessionId &&
            lotId == other.lotId &&
            lotName == other.lotName &&
            lotLatitude == other.lotLatitude &&
            lotLongitude == other.lotLongitude;
  }

  @override
  int get hashCode => Object.hash(
        id,
        parkedAt,
        latitude,
        longitude,
        photoPath,
        type,
        sessionId,
        lotId,
        lotName,
        lotLatitude,
        lotLongitude,
      );

  @override
  String toString() {
    return 'MyParkingRecord('
        'id: $id, parkedAt: $parkedAt, latitude: $latitude, longitude: $longitude, '
        'photoPath: $photoPath, type: $type, sessionId: $sessionId, lotId: $lotId, '
        'lotName: $lotName, lotLatitude: $lotLatitude, lotLongitude: $lotLongitude'
        ')';
  }
}
