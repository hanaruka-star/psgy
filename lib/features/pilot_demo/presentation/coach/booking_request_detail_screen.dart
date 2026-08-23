import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/pilot_demo/data/mock_coach_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_booking_request.dart';

class BookingRequestDetailScreen extends StatelessWidget {
  const BookingRequestDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final session = MockCoachSession.instance;

    return ListenableBuilder(
      listenable: session,
      builder: (context, _) {
        final booking = session.bookingById(bookingId);
        if (booking == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Chi tiết booking')),
            body: const Center(child: Text('Không tìm thấy booking.')),
          );
        }

        final theme = Theme.of(context);
        final canDecide = booking.status == MockBookingStatus.pending;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(title: const Text('Yêu cầu đặt lịch')),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: AppSpacing.screenPadding,
                  children: [
                    Card(
                      child: Padding(
                        padding: AppSpacing.cardPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking.userName, style: theme.textTheme.titleLarge),
                            const SizedBox(height: AppSpacing.md),
                            _Row(label: 'Dịch vụ', value: booking.serviceName),
                            _Row(label: 'Giá', value: booking.priceLabel),
                            _Row(label: 'Giờ', value: booking.requestedTimeLabel),
                            _Row(label: 'Địa điểm', value: booking.locationLabel),
                            _Row(label: 'Trạng thái', value: booking.statusLabel),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (canDecide)
                SafeArea(
                  child: Padding(
                    padding: AppSpacing.screenPadding,
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              session.updateBookingStatus(
                                booking.id,
                                MockBookingStatus.cancelled,
                                cancelReason: 'Coach từ chối',
                              );
                              Navigator.of(context).pop();
                            },
                            child: const Text('Từ chối'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              session.updateBookingStatus(
                                booking.id,
                                MockBookingStatus.confirmed,
                              );
                              Navigator.of(context).pop();
                            },
                            child: const Text('Xác nhận'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(label, style: theme.textTheme.bodySmall),
          ),
          Expanded(
            child: Text(value, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
