import 'dart:async';

import 'package:parking_link/features/staff/domain/entities/staff_today_stats_entity.dart';
import 'package:parking_link/features/staff/domain/repositories/staff_repository.dart';

class WatchTodayStatsUseCase {
  static const _vietnamUtcOffset = Duration(hours: 7);

  final StaffRepository repository;

  WatchTodayStatsUseCase(this.repository);

  Stream<StaffTodayStatsEntity> call(String lotId) {
    if (lotId.trim().isEmpty) {
      throw ArgumentError('lotId must not be empty');
    }

    return repository.watchTodayStats(
      lotId: lotId.trim(),
      dayStart: _todayStartInVietnam(),
    );
  }

  DateTime _todayStartInVietnam() {
    final vietnamNow = DateTime.now().toUtc().add(_vietnamUtcOffset);
    return DateTime.utc(
      vietnamNow.year,
      vietnamNow.month,
      vietnamNow.day,
    ).subtract(_vietnamUtcOffset);
  }
}
