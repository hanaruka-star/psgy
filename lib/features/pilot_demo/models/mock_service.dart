class MockService {
  final String id;
  final String name;
  final int priceVnd;
  final int durationMinutes;

  const MockService({
    required this.id,
    required this.name,
    required this.priceVnd,
    required this.durationMinutes,
  });

  String get priceLabel => formatVnd(priceVnd);

  MockService copyWith({
    String? id,
    String? name,
    int? priceVnd,
    int? durationMinutes,
  }) {
    return MockService(
      id: id ?? this.id,
      name: name ?? this.name,
      priceVnd: priceVnd ?? this.priceVnd,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}

String formatVnd(int priceVnd) {
  final digits = priceVnd.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(digits[i]);
  }
  return '$bufferđ';
}
