import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_colors.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/pilot_demo/data/mock_coach_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_booking_request.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/active_booking_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/booking_request_detail_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/coach_services_screen.dart';

class CoachHomeScreen extends StatelessWidget {
  static const routeName = 'coach_home';

  const CoachHomeScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const CoachHomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = MockCoachSession.instance;

    return ListenableBuilder(
      listenable: session,
      builder: (context, _) {
        final theme = Theme.of(context);
        final profile = session.profile;
        final pending = session.pendingBookings;
        final active = session.activeBookings;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Trang chủ Coach'),
            actions: [
              IconButton(
                tooltip: 'Dịch vụ',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const CoachServicesScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.fitness_center_outlined),
              ),
            ],
          ),
          body: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: AppColors.onPrimaryContainer,
                    child: Text(
                      profile.avatarInitials,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile.name, style: theme.textTheme.titleLarge),
                        Text(
                          '⭐ ${profile.ratingAvg.toStringAsFixed(1)}  ·  ${profile.ratingCount} đánh giá',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Đang rảnh'),
                        subtitle: Text('Khung giờ ${profile.hoursLabel}'),
                        value: profile.isAvailableNow,
                        activeThumbColor: AppColors.primary,
                        onChanged: session.setAvailable,
                      ),
                      const Divider(),
                      Text('Vị trí hiện tại', style: theme.textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        profile.currentLocationLabel,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: session.cycleLocation,
                          icon: const Icon(Icons.my_location_outlined),
                          label: const Text('Cập nhật vị trí'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (active.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Text('Booking đang diễn ra', style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                for (final booking in active) ...[
                  _BookingCard(
                    booking: booking,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              ActiveBookingScreen(bookingId: booking.id),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
              const SizedBox(height: AppSpacing.lg),
              Text('Booking mới cần xác nhận', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              if (pending.isEmpty)
                Text(
                  'Không có yêu cầu mới.',
                  style: theme.textTheme.bodyMedium,
                )
              else
                for (final booking in pending) ...[
                  _BookingCard(
                    booking: booking,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => BookingRequestDetailScreen(
                            bookingId: booking.id,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
            ],
          ),
        );
      },
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking, required this.onTap});

  final MockBookingRequest booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: AppColors.onPrimaryContainer,
                child: Text(booking.userAvatarInitials),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.userName, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${booking.serviceName} · ${booking.priceLabel}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      booking.requestedTimeLabel,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _StatusChip(booking: booking),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.booking});

  final MockBookingRequest booking;

  @override
  Widget build(BuildContext context) {
    final colors = _statusColors(booking.status);
    return Chip(
      visualDensity: VisualDensity.compact,
      backgroundColor: colors.$1,
      side: BorderSide.none,
      label: Text(booking.statusLabel),
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colors.$2,
          ),
    );
  }
}

(Color, Color) _statusColors(MockBookingStatus status) {
  return switch (status) {
    MockBookingStatus.pending => (
        AppColors.warningContainer,
        AppColors.onWarningContainer,
      ),
    MockBookingStatus.confirmed => (
        AppColors.primaryContainer,
        AppColors.onPrimaryContainer,
      ),
    MockBookingStatus.inProgress => (
        AppColors.successContainer,
        AppColors.onSuccessContainer,
      ),
    MockBookingStatus.awaitingUserConfirmation => (
        AppColors.warningContainer,
        AppColors.onWarningContainer,
      ),
    MockBookingStatus.completed => (
        AppColors.successContainer,
        AppColors.onSuccessContainer,
      ),
    MockBookingStatus.cancelled => (
        AppColors.dangerContainer,
        AppColors.onDangerContainer,
      ),
  };
}
