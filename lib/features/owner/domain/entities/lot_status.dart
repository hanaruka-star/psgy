class LotStatus {
  const LotStatus._();

  static const open = 'open';
  static const closed = 'closed';

  static bool isValid(String status) =>
      status == open || status == closed;
}
