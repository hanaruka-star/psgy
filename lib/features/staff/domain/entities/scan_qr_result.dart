class ScanQrResult {
  final String sessionId;
  final String plate;
  final String vehiclePhotoUrl;
  final String userPhone;

  const ScanQrResult({
    required this.sessionId,
    required this.plate,
    required this.vehiclePhotoUrl,
    required this.userPhone,
  });
}
