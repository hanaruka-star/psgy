class ActiveSessionInfo {
  final String sessionId;
  final String lotId;
  final String lotName;
  final double lotLatitude;
  final double lotLongitude;
  final DateTime checkedInAt;
  final String vehiclePlate;

  const ActiveSessionInfo({
    required this.sessionId,
    required this.lotId,
    required this.lotName,
    required this.lotLatitude,
    required this.lotLongitude,
    required this.checkedInAt,
    required this.vehiclePlate,
  });

  ActiveSessionInfo copyWith({
    String? sessionId,
    String? lotId,
    String? lotName,
    double? lotLatitude,
    double? lotLongitude,
    DateTime? checkedInAt,
    String? vehiclePlate,
  }) {
    return ActiveSessionInfo(
      sessionId: sessionId ?? this.sessionId,
      lotId: lotId ?? this.lotId,
      lotName: lotName ?? this.lotName,
      lotLatitude: lotLatitude ?? this.lotLatitude,
      lotLongitude: lotLongitude ?? this.lotLongitude,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ActiveSessionInfo &&
            sessionId == other.sessionId &&
            lotId == other.lotId &&
            lotName == other.lotName &&
            lotLatitude == other.lotLatitude &&
            lotLongitude == other.lotLongitude &&
            checkedInAt == other.checkedInAt &&
            vehiclePlate == other.vehiclePlate;
  }

  @override
  int get hashCode => Object.hash(
        sessionId,
        lotId,
        lotName,
        lotLatitude,
        lotLongitude,
        checkedInAt,
        vehiclePlate,
      );
}
