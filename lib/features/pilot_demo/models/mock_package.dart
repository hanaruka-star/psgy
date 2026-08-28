import 'package:psgy/features/pilot_demo/models/mock_service.dart';

class MockPackage {
  final String id;
  final String name;
  final int sessionCount;
  final int totalPriceVnd;
  final String description;
  final int validityDays;

  const MockPackage({
    required this.id,
    required this.name,
    required this.sessionCount,
    required this.totalPriceVnd,
    required this.description,
    required this.validityDays,
  });

  String get priceLabel => formatVnd(totalPriceVnd);

  String get validityLabel => 'Hạn dùng $validityDays ngày';
}
