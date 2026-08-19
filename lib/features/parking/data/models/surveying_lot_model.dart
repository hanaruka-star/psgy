import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyingLotModel {
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

  const SurveyingLotModel({
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

  factory SurveyingLotModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    final slotEstimates = _readSlotEstimates(data);

    return SurveyingLotModel(
      id: doc.id,
      name: (data['name'] as String?) ?? '',
      address: (data['address'] as String?) ?? '',
      lat: (data['lat'] as num?)?.toDouble() ?? 0,
      lng: (data['lng'] as num?)?.toDouble() ?? 0,
      status: (data['status'] as String?) ?? 'surveying',
      surveyedAt: _readTimestamp(data['surveyedAt']),
      estimatedOpeningAt: _readTimestamp(data['estimatedOpeningAt']),
      estimatedSlots: (data['estimatedSlots'] as num?)?.toInt(),
      estimatedCarSlots: (data['estimatedCarSlots'] as num?)?.toInt() ??
          slotEstimates?['car'],
      estimatedMotoSlots: (data['estimatedMotoSlots'] as num?)?.toInt() ??
          slotEstimates?['moto'],
      carPrice: _readInt(data['carPrice']),
      motoPrice: _readInt(data['motoPrice']),
      totalSlots: (data['totalSlots'] as num?)?.toInt() ?? 0,
      vehicleTypes: (data['vehicleTypes'] as String?) ?? '',
      category: (data['category'] as String?) ?? '',
      photoUrl: (data['photoUrl'] as String?) ?? (data['imageUrl'] as String?),
      notes: (data['notes'] as String?) ?? '',
      source: (data['source'] as String?) ?? '',
      surveyor: (data['surveyor'] as String?) ?? '',
    );
  }

  static Map<String, int>? _readSlotEstimates(Map<String, dynamic> data) {
    final raw = data['vehicleSlotEstimates'] ?? data['estimatedSlotsByVehicle'];
    if (raw is! Map) return null;

    final estimates = <String, int>{};
    raw.forEach((key, value) {
      if (value is num) {
        estimates[key.toString()] = value.toInt();
      }
    });
    return estimates.isEmpty ? null : estimates;
  }

  static DateTime? _readTimestamp(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  static int _readInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value == null) return 0;
    return int.tryParse('$value') ?? 0;
  }
}
