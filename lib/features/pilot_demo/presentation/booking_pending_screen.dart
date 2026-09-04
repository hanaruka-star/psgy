import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_booking_request.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/models/mock_service.dart';
import 'package:psgy/features/pilot_demo/presentation/create_journal_post_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/main_shell_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/user_chat_screen.dart';

class BookingPendingScreen extends StatefulWidget {
  const BookingPendingScreen({
    super.key,
    required this.coach,
    required this.service,
    this.booking,
    this.readOnly = false,
  });

  final MockCoach coach;
  final MockService service;
  final MockBookingRequest? booking;
  final bool readOnly;

  @override
  State<BookingPendingScreen> createState() => _BookingPendingScreenState();
}

class _BookingPendingScreenState extends State<BookingPendingScreen> {
  static const _demoStepDelay = Duration(seconds: 3);

  final _commentController = TextEditingController();
  int _rating = 5;

  @override
  void initState() {
    super.initState();
    if (!widget.readOnly) {
      _runDemoAdvance();
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  /// DEMO ONLY: auto-advance fakes Coach actions on this device.
  /// Production must sync status via Firestore between User and Coach apps.
  Future<void> _runDemoAdvance() async {
    final id = widget.booking?.id;
    if (id == null) return;

    while (mounted) {
      await Future<void>.delayed(_demoStepDelay);
      if (!mounted) return;
      final current = MockUserSession.instance.bookingById(id);
      if (current == null) return;
      final next = switch (current.status) {
        MockBookingStatus.pending => MockBookingStatus.confirmed,
        MockBookingStatus.confirmed => MockBookingStatus.inProgress,
        MockBookingStatus.inProgress =>
          MockBookingStatus.awaitingUserConfirmation,
        _ => null,
      };
      if (next == null) return;
      MockUserSession.instance.updateBookingStatus(id, next);
    }
  }

  MockBookingStatus get _status {
    final id = widget.booking?.id;
    if (id == null) return MockBookingStatus.pending;
    return MockUserSession.instance.bookingById(id)?.status ??
        widget.booking!.status;
  }

  bool get _canChat {
    return switch (_status) {
      MockBookingStatus.pending || MockBookingStatus.cancelled => false,
      _ => widget.booking != null,
    };
  }

  void _openShare() {
    final booking = widget.booking;
    if (booking == null) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CreateJournalPostScreen(
          coach: widget.coach,
          service: widget.service,
          booking: booking,
        ),
      ),
    );
  }

  void _goHome() {
    Navigator.of(context).popUntil((route) {
      return route.settings.name == MainShellScreen.routeName || route.isFirst;
    });
  }

  void _openChat() {
    final booking = widget.booking;
    if (booking == null) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => UserChatScreen(
          bookingId: booking.id,
          coachName: widget.coach.name,
        ),
      ),
    );
  }

  void _confirmReceived() {
    final id = widget.booking?.id;
    if (id == null) return;
    MockUserSession.instance.updateBookingStatus(
      id,
      MockBookingStatus.completed,
      rating: _rating,
      reviewComment: _commentController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = MockUserSession.instance;

    return ListenableBuilder(
      listenable: session,
      builder: (context, _) {
        final status = _status;
        final done = status == MockBookingStatus.completed;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              widget.readOnly ? 'Chi tiết Booking' : 'Theo dõi Booking',
            ),
            automaticallyImplyLeading: true,
          ),
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
                            Text(
                              widget.coach.name,
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(widget.service.name),
                            Text(
                              widget.service.priceLabel,
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              widget.booking?.requestedTimeLabel ??
                                  widget.coach.nextSlotLabel,
                            ),
                            const Text('Coach đến chỗ bạn'),
                            if (widget.booking != null) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Text(widget.booking!.paymentSummary),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Tiến trình', style: theme.textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.md),
                    _Timeline(status: status),
                    if (!widget.readOnly && _canChat) ...[
                      const SizedBox(height: AppSpacing.md),
                      OutlinedButton.icon(
                        onPressed: _openChat,
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text('Chat với Coach'),
                      ),
                    ],
                    if (!widget.readOnly &&
                        status ==
                            MockBookingStatus.awaitingUserConfirmation) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Xác nhận đã nhận dịch vụ',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          for (var star = 1; star <= 5; star++)
                            IconButton(
                              onPressed: () => setState(() => _rating = star),
                              icon: Icon(
                                star <= _rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: AppStatusColors.highlight(
                                  theme.brightness,
                                ),
                              ),
                            ),
                        ],
                      ),
                      TextField(
                        controller: _commentController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Bình luận',
                          hintText: 'Buổi tập thế nào?',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _confirmReceived,
                          child: const Text('Xác nhận đã nhận dịch vụ'),
                        ),
                      ),
                    ],
                    if (widget.readOnly) ...[
                      Builder(
                        builder: (context) {
                          final live = widget.booking == null
                              ? null
                              : session.bookingById(widget.booking!.id) ??
                                  widget.booking;
                          if (live == null) return const SizedBox.shrink();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (live.cancelReason != null &&
                                  live.cancelReason!.isNotEmpty) ...[
                                const SizedBox(height: AppSpacing.lg),
                                Text(
                                  'Lý do hủy: ${live.cancelReason}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                              if (live.rating != null) ...[
                                const SizedBox(height: AppSpacing.lg),
                                Text(
                                  'Đánh giá của bạn',
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Row(
                                  children: [
                                    for (var star = 1; star <= 5; star++)
                                      Icon(
                                        star <= live.rating!
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: AppStatusColors.highlight(
                                          theme.brightness,
                                        ),
                                      ),
                                  ],
                                ),
                                if (live.reviewComment != null &&
                                    live.reviewComment!.isNotEmpty) ...[
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(live.reviewComment!),
                                ],
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                    if (done) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Icon(
                        Icons.check_circle_rounded,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Hoàn thành buổi tập',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium,
                      ),
                    ],
                  ],
                ),
              ),
              if (done && !widget.readOnly)
                SafeArea(
                  child: Padding(
                    padding: AppSpacing.screenPadding,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _openShare,
                            child: const Text('📸 Chia sẻ buổi tập hôm nay'),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _goHome,
                            child: const Text('Về trang chủ'),
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

class _Timeline extends StatelessWidget {
  const _Timeline({required this.status});

  final MockBookingStatus status;

  static const _steps = [
    (MockBookingStatus.confirmed, 'Coach xác nhận'),
    (MockBookingStatus.inProgress, 'Coach bắt đầu'),
    (MockBookingStatus.awaitingUserConfirmation, 'Coach hoàn thành'),
    (MockBookingStatus.completed, 'Bạn xác nhận'),
  ];

  int get _currentIndex {
    return switch (status) {
      MockBookingStatus.pending || MockBookingStatus.cancelled => -1,
      MockBookingStatus.confirmed => 0,
      MockBookingStatus.inProgress => 1,
      MockBookingStatus.awaitingUserConfirmation => 2,
      MockBookingStatus.completed => 3,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = _currentIndex;

    return Column(
      children: [
        if (status == MockBookingStatus.pending)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              children: [
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Đang chờ Coach xác nhận...',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        for (var i = 0; i < _steps.length; i++)
          _TimelineRow(
            label: _steps[i].$2,
            isLast: i == _steps.length - 1,
            done: current > i,
            current: current == i,
          ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.label,
    required this.isLast,
    required this.done,
    required this.current,
  });

  final String label;
  final bool isLast;
  final bool done;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = done || current ? scheme.primary : scheme.outline;
    final textStyle = current
        ? theme.textTheme.titleMedium?.copyWith(color: scheme.primary)
        : theme.textTheme.bodyMedium;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Icon(
                  done
                      ? Icons.check_circle
                      : current
                          ? Icons.radio_button_checked
                          : Icons.circle_outlined,
                  size: 22,
                  color: color,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: done ? scheme.primary : scheme.outline,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
              child: Text(label, style: textStyle),
            ),
          ),
        ],
      ),
    );
  }
}
