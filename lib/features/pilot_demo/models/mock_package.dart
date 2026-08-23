import 'package:psgy/features/pilot_demo/models/mock_service.dart';

class MockPackage {
  final String id;
  final String name;
  final int sessionCount;
  final int totalPriceVnd;
  final String description;

  const MockPackage({
    required this.id,
    required this.name,
    required this.sessionCount,
    required this.totalPriceVnd,
    required this.description,
  });

  String get priceLabel => formatVnd(totalPriceVnd);

  MockPackage copyWith({
    String? id,
    String? name,
    int? sessionCount,
    int? totalPriceVnd,
    String? description,
  }) {
    return MockPackage(
      id: id ?? this.id,
      name: name ?? this.name,
      sessionCount: sessionCount ?? this.sessionCount,
      totalPriceVnd: totalPriceVnd ?? this.totalPriceVnd,
      description: description ?? this.description,
    );
  }
}
