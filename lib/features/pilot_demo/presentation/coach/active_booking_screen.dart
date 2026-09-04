import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/data/mock_coach_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_booking_request.dart';
import 'package:psgy/features/pilot_demo/presentation/booking_status_style.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/coach_chat_screen.dart';

class ActiveBookingScreen extends StatelessWidget {
  const ActiveBookingScreen({super.key, required this.bookingId});

  final String bookingId;

  Future<void> _reportNoShow(BuildContext context, MockCoachSession session) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Báo cáo khách không đến'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Lý do ngắn',
              hintText: 'Ví dụ: Khách không nghe máy',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () {
                final text = controller.text.trim();
                Navigator.of(dialogContext).pop(
                  text.isEmpty ? 'Khách không đến' : text,
                );
              },
              style: AppStatusColors.highlightFilledButton(dialogContext),
              child: const Text('Gửi'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (reason == null || !context.mounted) return;
    session.updateBookingStatus(
      bookingId,
      MockBookingStatus.cancelled,
      cancelReason: reason,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final session = MockCoachSession.instance;

    return ListenableBuilder(
      listenable: session,
      builder: (context, _) {
        final booking = session.bookingById(bookingId);
        if (booking == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Booking đang diễn ra'),
              titleTextStyle: AppStatusColors.headingStyle(context),
              foregroundColor: AppStatusColors.sheetTitle(
                Theme.of(context).brightness,
              ),
            ),
            body: const Center(child: Text('Không tìm thấy booking.')),
          );
        }

        final theme = Theme.of(context);
        final pair = bookingStatusPair(context, booking.status);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Booking đang diễn ra'),
            titleTextStyle: AppStatusColors.headingStyle(context),
            foregroundColor: AppStatusColors.sheetTitle(theme.brightness),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: AppSpacing.screenPadding,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        backgroundColor: pair.container,
                        side: BorderSide.none,
                        label: Text(booking.statusLabel),
                        labelStyle: theme.textTheme.labelLarge?.copyWith(
                          color: pair.onContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Card(
                      child: Padding(
                        padding: AppSpacing.cardPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.userName,
                              style: AppStatusColors.headingStyle(context),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(booking.serviceName),
                            Text(booking.priceLabel, style: theme.textTheme.titleMedium),
                            const SizedBox(height: AppSpacing.sm),
                            Text(booking.requestedTimeLabel),
                            Text(booking.locationLabel),
                            if (booking.cancelReason != null) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Lý do hủy: ${booking.cancelReason}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => CoachChatScreen(bookingId: booking.id),
                          ),
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('Vào Chat'),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    children: [
                      if (booking.status == MockBookingStatus.confirmed)
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              session.updateBookingStatus(
                                booking.id,
                                MockBookingStatus.inProgress,
                              );
                            },
                            style: AppStatusColors.highlightFilledButton(context),
                            child: const Text('Bắt đầu buổi tập'),
                          ),
                        ),
                      if (booking.status == MockBookingStatus.inProgress)
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              session.updateBookingStatus(
                                booking.id,
                                MockBookingStatus.awaitingUserConfirmation,
                              );
                            },
                            style: AppStatusColors.highlightFilledButton(context),
                            child: const Text('Hoàn thành dịch vụ'),
                          ),
                        ),
                      if (booking.status ==
                          MockBookingStatus.awaitingUserConfirmation) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Đã gửi yêu cầu xác nhận cho khách.',
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                      if (booking.status == MockBookingStatus.confirmed) ...[
                        const SizedBox(height: AppSpacing.sm),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => _reportNoShow(context, session),
                            child: const Text('Báo cáo khách không đến'),
                          ),
                        ),
                      ],
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
