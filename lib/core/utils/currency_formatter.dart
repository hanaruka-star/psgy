/// Formats a VND amount for display.
///
/// - `null` or `0` -> "Miễn phí"
/// - groups thousands with '.' and appends 'đ' (e.g. 15000 -> "15.000đ")
String formatVnd(int? amount) {
  if (amount == null || amount == 0) return 'Miễn phí';

  final isNegative = amount < 0;
  final digits = amount.abs().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(digits[i]);
  }

  return '${isNegative ? '-' : ''}$buffer\u0111';
}
