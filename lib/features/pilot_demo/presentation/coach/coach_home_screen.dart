import 'package:flutter/material.dart';
import 'package:psgy/core/config/app_config.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/data/mock_coach_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_booking_request.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/active_booking_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/booking_request_detail_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/coach_services_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/coach_student_journal_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/booking_status_style.dart';
import 'package:psgy/shared/widgets/header_logo.dart';

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
            title: AppConfig.showDevModeSwitcher
                ? null
                : const HeaderLogo(fontSize: 20, showCoachLabel: true),
            toolbarHeight:
                AppConfig.showDevModeSwitcher ? kToolbarHeight : 72,
            foregroundColor: AppStatusColors.sheetTitle(theme.brightness),
            actions: [
              IconButton(
                tooltip: 'Nhật ký học viên',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const CoachStudentJournalScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.auto_stories_outlined),
              ),
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
                    backgroundColor: theme.colorScheme.primaryContainer,
                    foregroundColor: theme.colorScheme.onPrimaryContainer,
                    child: Text(
                      profile.avatarInitials,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile.name, style: theme.textTheme.titleLarge),
                        AppRating(
                          value: profile.ratingAvg,
                          suffix: '${profile.ratingCount} đánh giá',
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
                        onChanged: session.setAvailable,
                        thumbColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppStatusColors.highlight(theme.brightness);
                          }
                          return null;
                        }),
                        trackColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppStatusColors.highlight(theme.brightness)
                                .withValues(alpha: 0.35);
                          }
                          return null;
                        }),
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
                Text(
                  'Booking đang diễn ra',
                  style: AppStatusColors.headingStyle(context),
                ),
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
              Text(
                'Booking mới cần xác nhận',
                style: AppStatusColors.headingStyle(context),
              ),
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
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.onPrimaryContainer,
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
    final pair = bookingStatusPair(context, booking.status);
    return Chip(
      visualDensity: VisualDensity.compact,
      backgroundColor: pair.container,
      side: BorderSide.none,
      label: Text(booking.statusLabel),
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: pair.onContainer,
          ),
    );
  }
}
