/// A surveying lot the user follows for opening alerts.
class WatchlistEntity {
  final String lotId;
  final String lotName;
  final DateTime watchedAt;
  final DateTime? estimatedOpeningAt;
  final bool hasUnreadUpdate;

  const WatchlistEntity({
    required this.lotId,
    required this.lotName,
    required this.watchedAt,
    this.estimatedOpeningAt,
    this.hasUnreadUpdate = false,
  });

  factory WatchlistEntity.fromSurveying({
    required String lotId,
    required String lotName,
    DateTime? estimatedOpeningAt,
    DateTime? watchedAt,
  }) {
    return WatchlistEntity(
      lotId: lotId,
      lotName: lotName,
      watchedAt: watchedAt ?? DateTime.now(),
      estimatedOpeningAt: estimatedOpeningAt,
    );
  }

  WatchlistEntity copyWith({
    String? lotName,
    DateTime? watchedAt,
    DateTime? estimatedOpeningAt,
    bool? hasUnreadUpdate,
  }) {
    return WatchlistEntity(
      lotId: lotId,
      lotName: lotName ?? this.lotName,
      watchedAt: watchedAt ?? this.watchedAt,
      estimatedOpeningAt: estimatedOpeningAt ?? this.estimatedOpeningAt,
      hasUnreadUpdate: hasUnreadUpdate ?? this.hasUnreadUpdate,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WatchlistEntity &&
            lotId == other.lotId &&
            lotName == other.lotName &&
            watchedAt == other.watchedAt &&
            estimatedOpeningAt == other.estimatedOpeningAt &&
            hasUnreadUpdate == other.hasUnreadUpdate;
  }

  @override
  int get hashCode => Object.hash(
        lotId,
        lotName,
        watchedAt,
        estimatedOpeningAt,
        hasUnreadUpdate,
      );
}
