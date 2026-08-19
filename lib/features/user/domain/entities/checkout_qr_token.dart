class CheckoutQrToken {
  final String tokenId;
  final String sessionId;
  final String userId;
  final String plate;
  final String lotId;
  final String lotName;
  final String vehicleType;
  final int estimatedFee;
  final DateTime checkedInAt;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool used;
  final DateTime? usedAt;
  final String? checkOutStaffId;

  const CheckoutQrToken({
    required this.tokenId,
    required this.sessionId,
    required this.userId,
    required this.plate,
    required this.lotId,
    required this.lotName,
    required this.vehicleType,
    required this.estimatedFee,
    required this.checkedInAt,
    required this.createdAt,
    required this.expiresAt,
    this.used = false,
    this.usedAt,
    this.checkOutStaffId,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  bool get isValid => !used && !isExpired;

  Duration get parkingDuration => DateTime.now().difference(checkedInAt);

  CheckoutQrToken copyWith({
    String? tokenId,
    String? sessionId,
    String? userId,
    String? plate,
    String? lotId,
    String? lotName,
    String? vehicleType,
    int? estimatedFee,
    DateTime? checkedInAt,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? used,
    DateTime? usedAt,
    String? checkOutStaffId,
  }) {
    return CheckoutQrToken(
      tokenId: tokenId ?? this.tokenId,
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      plate: plate ?? this.plate,
      lotId: lotId ?? this.lotId,
      lotName: lotName ?? this.lotName,
      vehicleType: vehicleType ?? this.vehicleType,
      estimatedFee: estimatedFee ?? this.estimatedFee,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      used: used ?? this.used,
      usedAt: usedAt ?? this.usedAt,
      checkOutStaffId: checkOutStaffId ?? this.checkOutStaffId,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CheckoutQrToken &&
            runtimeType == other.runtimeType &&
            tokenId == other.tokenId &&
            sessionId == other.sessionId &&
            userId == other.userId &&
            plate == other.plate &&
            lotId == other.lotId &&
            lotName == other.lotName &&
            vehicleType == other.vehicleType &&
            estimatedFee == other.estimatedFee &&
            checkedInAt == other.checkedInAt &&
            createdAt == other.createdAt &&
            expiresAt == other.expiresAt &&
            used == other.used &&
            usedAt == other.usedAt &&
            checkOutStaffId == other.checkOutStaffId;
  }

  @override
  int get hashCode => Object.hash(
        tokenId,
        sessionId,
        userId,
        plate,
        lotId,
        lotName,
        vehicleType,
        estimatedFee,
        checkedInAt,
        createdAt,
        expiresAt,
        used,
        usedAt,
        checkOutStaffId,
      );
}
