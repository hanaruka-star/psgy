import 'package:psgy/features/pilot_demo/models/mock_service.dart';

class MockPackage {
  final String id;
  final String coachId;
  final String name;
  final int sessionCount;
  final int totalPriceVnd;
  final String description;

  const MockPackage({
    required this.id,
    required this.coachId,
    required this.name,
    required this.sessionCount,
    required this.totalPriceVnd,
    required this.description,
  });

  String get priceLabel => formatVnd(totalPriceVnd);

  MockPackage copyWith({
    String? id,
    String? coachId,
    String? name,
    int? sessionCount,
    int? totalPriceVnd,
    String? description,
  }) {
    return MockPackage(
      id: id ?? this.id,
      coachId: coachId ?? this.coachId,
      name: name ?? this.name,
      sessionCount: sessionCount ?? this.sessionCount,
      totalPriceVnd: totalPriceVnd ?? this.totalPriceVnd,
      description: description ?? this.description,
    );
  }
}

/// Gói user đã mua — chỉ dùng được với đúng [coachId].
class MockPurchasedPackage {
  final String id;
  final String packageId;
  final String coachId;
  final String packageName;
  final int sessionCount;
  final int remainingSessions;
  final DateTime purchasedAt;

  const MockPurchasedPackage({
    required this.id,
    required this.packageId,
    required this.coachId,
    required this.packageName,
    required this.sessionCount,
    required this.remainingSessions,
    required this.purchasedAt,
  });

  String get remainingLabel =>
      'Còn $remainingSessions / $sessionCount buổi';

  MockPurchasedPackage copyWith({int? remainingSessions}) {
    return MockPurchasedPackage(
      id: id,
      packageId: packageId,
      coachId: coachId,
      packageName: packageName,
      sessionCount: sessionCount,
      remainingSessions: remainingSessions ?? this.remainingSessions,
      purchasedAt: purchasedAt,
    );
  }
}
