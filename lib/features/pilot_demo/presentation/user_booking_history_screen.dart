import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_booking_request.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/models/mock_service.dart';
import 'package:psgy/features/pilot_demo/presentation/booking_pending_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/booking_status_style.dart';

class UserBookingHistoryScreen extends StatelessWidget {
  const UserBookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = MockUserSession.instance;
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: session,
      builder: (context, _) {
        final bookings = session.bookings.reversed.toList();

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(title: const Text('Lịch sử booking')),
          body: bookings.isEmpty
              ? Center(
                  child: Text(
                    'Chưa có booking nào.',
                    style: theme.textTheme.bodyLarge,
                  ),
                )
              : ListView.separated(
                  padding: AppSpacing.screenPadding,
                  itemCount: bookings.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return _HistoryCard(
                      booking: booking,
                      onTap: () => _openBooking(context, booking),
                    );
                  },
                ),
        );
      },
    );
  }

  void _openBooking(BuildContext context, MockBookingRequest booking) {
    final coach = _coachFor(booking);
    final service = _serviceFor(coach, booking);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BookingPendingScreen(
          coach: coach,
          service: service,
          booking: booking,
          readOnly: !booking.isTrackable,
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.booking, required this.onTap});

  final MockBookingRequest booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pair = bookingStatusPair(context, booking.status);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.coachName.isEmpty ? 'Coach' : booking.coachName,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Chip(
                    visualDensity: VisualDensity.compact,
                    backgroundColor: pair.container,
                    side: BorderSide.none,
                    label: Text(booking.statusLabel),
                    labelStyle: theme.textTheme.labelMedium?.copyWith(
                      color: pair.onContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(booking.serviceName, style: theme.textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                booking.requestedTimeLabel,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Thanh toán: ${booking.paymentMethodLabel}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

MockCoach _coachFor(MockBookingRequest booking) {
  for (final coach in mockCoaches) {
    if (coach.id == booking.coachId) return coach;
  }
  for (final coach in mockCoaches) {
    if (coach.name == booking.coachName) return coach;
  }
  return MockCoach(
    id: booking.coachId.isEmpty ? 'unknown' : booking.coachId,
    name: booking.coachName.isEmpty ? 'Coach' : booking.coachName,
    initials: 'C',
    rating: 0,
    yearsExperience: 0,
    distanceKm: 0,
    nextSlotLabel: booking.requestedTimeLabel,
    lat: 0,
    lng: 0,
    services: [
      MockService(
        id: 'svc_history',
        name: booking.serviceName,
        priceVnd: booking.priceVnd,
        durationMinutes: 60,
      ),
    ],
    packages: const [],
    bio: '',
  );
}

MockService _serviceFor(MockCoach coach, MockBookingRequest booking) {
  for (final service in coach.services) {
    if (service.name == booking.serviceName) return service;
  }
  return MockService(
    id: 'svc_history',
    name: booking.serviceName,
    priceVnd: booking.priceVnd,
    durationMinutes: 60,
  );
}
