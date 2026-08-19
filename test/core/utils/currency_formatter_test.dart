import 'package:flutter_test/flutter_test.dart';
import 'package:psgy/core/utils/currency_formatter.dart';

void main() {
  group('formatVnd', () {
    test('formatVnd 0 returns Miễn phí', () {
      expect(formatVnd(0), 'Miễn phí');
    });

    test('formatVnd null returns Miễn phí', () {
      expect(formatVnd(null), 'Miễn phí');
    });

    test('formatVnd 15000 returns 15.000đ', () {
      expect(formatVnd(15000), '15.000đ');
    });

    test('formatVnd 1000000 returns 1.000.000đ', () {
      expect(formatVnd(1000000), '1.000.000đ');
    });
  });
}
