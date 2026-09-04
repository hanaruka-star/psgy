import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/models/mock_booking_request.dart';

AppStatusPair bookingStatusPair(
  BuildContext context,
  MockBookingStatus status,
) {
  final scheme = Theme.of(context).colorScheme;
  final brightness = Theme.of(context).brightness;
  return switch (status) {
    MockBookingStatus.pending ||
    MockBookingStatus.awaitingUserConfirmation =>
      AppStatusColors.warning(brightness),
    MockBookingStatus.confirmed => AppStatusPair(
        container: scheme.primaryContainer,
        onContainer: scheme.onPrimaryContainer,
      ),
    MockBookingStatus.inProgress || MockBookingStatus.completed =>
      AppStatusColors.success(brightness),
    MockBookingStatus.cancelled => AppStatusColors.danger(brightness),
  };
}
