import 'package:cloud_firestore/cloud_firestore.dart';

class ManualAdjustmentModel {
  final String id;
  final String lotId;
  final String vehicleType;
  final int delta;
  final String? reason;
  final String staffId;
  final DateTime createdAt;

  const ManualAdjustmentModel({
    required this.id,
    required this.lotId,
    required this.vehicleType,
    required this.delta,
    required this.reason,
    required this.staffId,
    required this.createdAt,
  });

  static ManualAdjustmentModel fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
    String lotId,
  ) {
    final data = doc.data();
    return ManualAdjustmentModel(
      id: (data['id'] as String?) ?? doc.id,
      lotId: lotId,
      vehicleType: (data['vehicleType'] as String?) ?? '',
      delta: (data['delta'] as num?)?.toInt() ?? 0,
      reason: data['reason'] as String?,
      staffId: (data['staffId'] as String?) ?? '',
      createdAt: _toDateTime(data['createdAt']),
    );
  }

  static DateTime _toDateTime(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
