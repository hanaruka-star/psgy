class QrToken {
  final String tokenId;
  final String userId;
  final String vehicleId;
  final String plate;
  final String vehiclePhotoUrl;
  final String userPhone;
  final String? lotId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool used;
  final DateTime? usedAt;
  final String? sessionId;

  const QrToken({
    required this.tokenId,
    required this.userId,
    required this.vehicleId,
    required this.plate,
    required this.vehiclePhotoUrl,
    required this.userPhone,
    this.lotId,
    required this.createdAt,
    required this.expiresAt,
    this.used = false,
    this.usedAt,
    this.sessionId,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  bool get isValid => !used && !isExpired;

  QrToken copyWith({
    String? tokenId,
    String? userId,
    String? vehicleId,
    String? plate,
    String? vehiclePhotoUrl,
    String? userPhone,
    String? lotId,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? used,
    DateTime? usedAt,
    String? sessionId,
  }) {
    return QrToken(
      tokenId: tokenId ?? this.tokenId,
      userId: userId ?? this.userId,
      vehicleId: vehicleId ?? this.vehicleId,
      plate: plate ?? this.plate,
      vehiclePhotoUrl: vehiclePhotoUrl ?? this.vehiclePhotoUrl,
      userPhone: userPhone ?? this.userPhone,
      lotId: lotId ?? this.lotId,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      used: used ?? this.used,
      usedAt: usedAt ?? this.usedAt,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is QrToken &&
            runtimeType == other.runtimeType &&
            tokenId == other.tokenId &&
            userId == other.userId &&
            vehicleId == other.vehicleId &&
            plate == other.plate &&
            vehiclePhotoUrl == other.vehiclePhotoUrl &&
            userPhone == other.userPhone &&
            lotId == other.lotId &&
            createdAt == other.createdAt &&
            expiresAt == other.expiresAt &&
            used == other.used &&
            usedAt == other.usedAt &&
            sessionId == other.sessionId;
  }

  @override
  int get hashCode => Object.hash(
        tokenId,
        userId,
        vehicleId,
        plate,
        vehiclePhotoUrl,
        userPhone,
        lotId,
        createdAt,
        expiresAt,
        used,
        usedAt,
        sessionId,
      );
}
