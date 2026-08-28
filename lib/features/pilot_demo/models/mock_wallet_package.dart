import 'package:psgy/features/pilot_demo/models/mock_service.dart';

class MockWalletPackage {
  final String id;
  final String packageId;
  final String packageName;
  final int totalPriceVnd;
  final int remainingBalanceVnd;
  final DateTime purchasedAt;
  final int validityDays;

  const MockWalletPackage({
    required this.id,
    required this.packageId,
    required this.packageName,
    required this.totalPriceVnd,
    required this.remainingBalanceVnd,
    required this.purchasedAt,
    required this.validityDays,
  });

  String get remainingLabel =>
      '${formatVnd(remainingBalanceVnd)} / ${formatVnd(totalPriceVnd)}';

  MockWalletPackage copyWith({int? remainingBalanceVnd}) {
    return MockWalletPackage(
      id: id,
      packageId: packageId,
      packageName: packageName,
      totalPriceVnd: totalPriceVnd,
      remainingBalanceVnd: remainingBalanceVnd ?? this.remainingBalanceVnd,
      purchasedAt: purchasedAt,
      validityDays: validityDays,
    );
  }
}
