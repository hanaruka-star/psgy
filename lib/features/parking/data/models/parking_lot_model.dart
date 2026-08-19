import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:parking_link/features/parking/data/mappers/parking_lot_mapper.dart';
import 'package:parking_link/features/parking/domain/entities/parking_lot_entity.dart';

class ParkingLotModel extends Equatable {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String status;
  final String ownerId;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  const ParkingLotModel({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.status,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ParkingLotModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return ParkingLotModel(
      id: (data['id'] as String?) ?? doc.id,
      name: (data['name'] as String?) ?? '',
      address: (data['address'] as String?) ?? '',
      lat: (data['lat'] as num?)?.toDouble() ?? 0,
      lng: (data['lng'] as num?)?.toDouble() ?? 0,
      status: (data['status'] as String?) ?? 'closed',
      ownerId: (data['ownerId'] as String?) ?? '',
      createdAt: (data['createdAt'] as Timestamp?) ?? Timestamp.now(),
      updatedAt: (data['updatedAt'] as Timestamp?) ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'lat': lat,
      'lng': lng,
      'status': status,
      'ownerId': ownerId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  ParkingLotEntity toEntity() => ParkingLotMapper.toEntity(this);

  ParkingLotModel copyWith({
    String? id,
    String? name,
    String? address,
    double? lat,
    double? lng,
    String? status,
    String? ownerId,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return ParkingLotModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      status: status ?? this.status,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        lat,
        lng,
        status,
        ownerId,
        createdAt,
        updatedAt,
      ];
}
