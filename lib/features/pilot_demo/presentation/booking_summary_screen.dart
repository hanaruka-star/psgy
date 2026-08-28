import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_colors.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';
import 'package:psgy/features/pilot_demo/models/mock_booking_request.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/models/mock_service.dart';
import 'package:psgy/features/pilot_demo/models/mock_wallet_package.dart';
import 'package:psgy/features/pilot_demo/presentation/booking_pending_screen.dart';

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
  bool _coverShortfallWithCash = true;

  MockWalletPackage? _walletById(String? id) {
    if (id == null) return null;
    for (final wallet in MockUserSession.instance.usableWallets) {
      if (wallet.id == id) return wallet;
    }
    return null;
  }

  void _confirm() {
    final service = widget.service;
    final wallet = _walletById(_paymentKey == _cashKey ? null : _paymentKey);
    var method = MockPaymentMethod.cash;
    var topUp = 0;
    String? walletId;

    if (wallet != null) {
      final shortfall = service.priceVnd - wallet.remainingBalanceVnd;
      if (shortfall > 0 && !_coverShortfallWithCash) {
        method = MockPaymentMethod.cash;
      } else {
        method = MockPaymentMethod.wallet;
        walletId = wallet.id;
        topUp = shortfall > 0 ? shortfall : 0;
      }
    }

    final booking = MockUserSession.instance.placeBooking(
      coachId: widget.coach.id,
      coachName: widget.coach.name,
      serviceName: service.name,
      priceVnd: service.priceVnd,
      requestedTimeLabel: widget.coach.nextSlotLabel,
      paymentMethod: method,
      walletId: walletId,
      topUpAmountVnd: topUp,
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
        final wallets = session.usableWallets;
        final selectedWallet = _walletById(
          _paymentKey == _cashKey ? null : _paymentKey,
        );
        final usingWallet = selectedWallet != null;
        final shortfall = usingWallet
            ? service.priceVnd - selectedWallet.remainingBalanceVnd
            : 0;
        final walletShort = usingWallet && shortfall > 0;
        final payingCashOnly = !usingWallet || (walletShort && !_coverShortfallWithCash);

        final String payNote;
        Color noteBg = AppColors.warningContainer;
        Color noteFg = AppColors.onWarningContainer;
        if (payingCashOnly) {
          payNote = 'Thanh toán tiền mặt trực tiếp với Coach';
        } else if (shortfall <= 0) {
          payNote = 'Thanh toán bằng ví — 0đ tiền mặt';
          noteBg = AppColors.successContainer;
          noteFg = AppColors.onSuccessContainer;
        } else {
          payNote =
              'Ví ${formatVnd(selectedWallet.remainingBalanceVnd)} · tiền mặt thêm ${formatVnd(shortfall)}';
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
                              value: service.priceLabel,
                              emphasize: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (wallets.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text('Thanh toán', style: theme.textTheme.titleMedium),
                      RadioGroup<String>(
                        groupValue: _paymentKey,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _paymentKey = value;
                            _coverShortfallWithCash = true;
                          });
                        },
                        child: Column(
                          children: [
                            const RadioListTile<String>(
                              value: _cashKey,
                              title: Text('Tiền mặt trực tiếp với Coach'),
                              activeColor: AppColors.primary,
                              contentPadding: EdgeInsets.zero,
                            ),
                            for (final wallet in wallets)
                              RadioListTile<String>(
                                value: wallet.id,
                                title: Text(
                                  'Dùng ví — ${wallet.packageName} (còn lại ${formatVnd(wallet.remainingBalanceVnd)})',
                                ),
                                activeColor: AppColors.primary,
                                contentPadding: EdgeInsets.zero,
                              ),
                          ],
                        ),
                      ),
                      if (walletShort) ...[
                        Text(
                          'Ví không đủ cho buổi này',
                          style: theme.textTheme.titleMedium,
                        ),
                        RadioGroup<bool>(
                          groupValue: _coverShortfallWithCash,
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              if (value) {
                                _coverShortfallWithCash = true;
                              } else {
                                _paymentKey = _cashKey;
                                _coverShortfallWithCash = true;
                              }
                            });
                          },
                          child: Column(
                            children: [
                              RadioListTile<bool>(
                                value: true,
                                title: Text(
                                  'Trả thêm tiền mặt phần chênh lệch (${formatVnd(shortfall)})',
                                ),
                                activeColor: AppColors.primary,
                                contentPadding: EdgeInsets.zero,
                              ),
                              const RadioListTile<bool>(
                                value: false,
                                title: Text(
                                  'Đổi sang trả tiền mặt trực tiếp',
                                ),
                                activeColor: AppColors.primary,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: AppSpacing.cardPadding,
                      decoration: BoxDecoration(
                        color: noteBg,
                        borderRadius: AppSpacing.borderRadiusMd,
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
