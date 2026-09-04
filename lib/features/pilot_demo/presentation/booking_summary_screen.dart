import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_shapes.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_booking_request.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/models/mock_package.dart';
import 'package:psgy/features/pilot_demo/models/mock_service.dart';
import 'package:psgy/features/pilot_demo/presentation/booking_pending_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/user_chat_screen.dart';

class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({
    super.key,
    required this.coach,
    required this.service,
  });

  final MockCoach coach;
  final MockService service;

  static const _locationLabel = 'Coach đến chỗ bạn';

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  static const _cashKey = 'cash';

  String _paymentKey = _cashKey;
  final _address = TextEditingController();
  final _promo = TextEditingController();
  final _promoFocus = FocusNode();

  @override
  void dispose() {
    _address.dispose();
    _promo.dispose();
    _promoFocus.dispose();
    super.dispose();
  }

  void _openCoachChat() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => UserChatScreen(
          inquiryCoachId: widget.coach.id,
          coachName: widget.coach.name,
        ),
      ),
    );
  }

  void _applyPromo() {
    _promoFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  MockPurchasedPackage? _packageById(String? id) {
    if (id == null) return null;
    for (final item in MockUserSession.instance
        .usablePackagesFor(widget.coach.id)) {
      if (item.id == id) return item;
    }
    return null;
  }

  void _confirm() {
    final service = widget.service;
    final owned = _packageById(_paymentKey == _cashKey ? null : _paymentKey);
    final method = owned == null
        ? MockPaymentMethod.cash
        : MockPaymentMethod.package;

    final booking = MockUserSession.instance.placeBooking(
      coachId: widget.coach.id,
      coachName: widget.coach.name,
      serviceName: service.name,
      priceVnd: service.priceVnd,
      requestedTimeLabel: widget.coach.nextSlotLabel,
      paymentMethod: method,
      purchasedPackageId: owned?.id,
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BookingPendingScreen(
          coach: widget.coach,
          service: service,
          booking: booking,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final service = widget.service;
    final session = MockUserSession.instance;

    return ListenableBuilder(
      listenable: session,
      builder: (context, _) {
        final packages = session.usablePackagesFor(widget.coach.id);
        final paymentKey = (_paymentKey != _cashKey &&
                packages.any((item) => item.id == _paymentKey))
            ? _paymentKey
            : _cashKey;
        final selected = _packageById(
          paymentKey == _cashKey ? null : paymentKey,
        );
        final usingPackage = selected != null;

        final String payNote;
        final brightness = theme.brightness;
        late final Color noteBg;
        late final Color noteFg;
        if (!usingPackage) {
          payNote = 'Thanh toán tiền mặt trực tiếp với Coach';
          final pair = AppStatusColors.warning(brightness);
          noteBg = pair.container;
          noteFg = pair.onContainer;
        } else {
          payNote =
              'Thanh toán bằng gói ${selected.packageName} — trừ 1 buổi '
              '(còn ${selected.remainingSessions} buổi)';
          final pair = AppStatusColors.success(brightness);
          noteBg = pair.container;
          noteFg = pair.onContainer;
        }

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(title: const Text('Xác nhận đặt lịch')),
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
                            Text('Địa chỉ', style: theme.textTheme.titleMedium),
                            const SizedBox(height: AppSpacing.sm),
                            TextField(
                              controller: _address,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                hintText: 'Nhập địa chỉ muốn tập',
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _openCoachChat,
                                icon: const Icon(Icons.chat_bubble_outline),
                                label: const Text('Trao đổi với Coach'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (packages.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text('Thanh toán', style: theme.textTheme.titleMedium),
                      RadioGroup<String>(
                        groupValue: paymentKey,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _paymentKey = value);
                        },
                        child: Column(
                          children: [
                            const RadioListTile<String>(
                              value: _cashKey,
                              title: Text('Tiền mặt trực tiếp với Coach'),
                              contentPadding: EdgeInsets.zero,
                            ),
                            for (final item in packages)
                              RadioListTile<String>(
                                value: item.id,
                                title: Text(
                                  'Dùng gói ${item.packageName} (${item.remainingLabel})',
                                ),
                                contentPadding: EdgeInsets.zero,
                              ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    Card(
                      child: Padding(
                        padding: AppSpacing.cardPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mã giảm giá',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _promo,
                                    focusNode: _promoFocus,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: const InputDecoration(
                                      hintText: 'Nhập mã',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                FilledButton(
                                  onPressed: _applyPromo,
                                  child: const Text('Áp dụng'),
                                ),
                              ],
                            ),
                          ],
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
                            Text('Hóa đơn', style: theme.textTheme.titleLarge),
                            const SizedBox(height: AppSpacing.md),
                            _BillRow(label: 'Coach', value: widget.coach.name),
                            _BillRow(
                              label: 'Dịch vụ',
                              value: '${service.name} · ${service.priceLabel}',
                            ),
                            _BillRow(
                              label: 'Khung giờ',
                              value: widget.coach.nextSlotLabel,
                            ),
                            const _BillRow(
                              label: 'Địa điểm',
                              value: BookingSummaryScreen._locationLabel,
                            ),
                            const Divider(height: AppSpacing.lg),
                            _BillRow(
                              label: 'Tổng tiền',
                              value: usingPackage
                                  ? 'Trừ 1 buổi gói'
                                  : service.priceLabel,
                              emphasize: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: AppSpacing.cardPadding,
                      decoration: ShapeDecoration(
                        color: noteBg,
                        shape: AppShapes.rect(radius: AppSpacing.radiusMd),
                      ),
                      child: Text(
                        payNote,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: noteFg,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _confirm,
                      child: const Text('Đặt lịch ngay'),
                    ),
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

class _BillRow extends StatelessWidget {
  const _BillRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = emphasize
        ? theme.textTheme.titleMedium
        : theme.textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: theme.textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: style,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
