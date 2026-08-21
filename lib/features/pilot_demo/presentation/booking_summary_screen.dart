import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_colors.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/models/mock_service.dart';
import 'package:psgy/features/pilot_demo/presentation/booking_pending_screen.dart';

class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({
    super.key,
    required this.coach,
    required this.service,
  });

  final MockCoach coach;
  final MockService service;

  static const _locationLabel = 'Coach đến chỗ bạn';
  static const _cashNote = 'Thanh toán tiền mặt trực tiếp với Coach';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                        _BillRow(label: 'Coach', value: coach.name),
                        _BillRow(
                          label: 'Dịch vụ',
                          value: '${service.name} · ${service.priceLabel}',
                        ),
                        _BillRow(label: 'Khung giờ', value: coach.nextSlotLabel),
                        const _BillRow(
                          label: 'Địa điểm',
                          value: _locationLabel,
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
                const SizedBox(height: AppSpacing.md),
                Container(
                  width: double.infinity,
                  padding: AppSpacing.cardPadding,
                  decoration: const BoxDecoration(
                    color: AppColors.warningContainer,
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: Text(
                    _cashNote,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.onWarningContainer,
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => BookingPendingScreen(
                          coach: coach,
                          service: service,
                        ),
                      ),
                    );
                  },
                  child: const Text('Đặt lịch ngay'),
                ),
              ),
            ),
          ),
        ],
      ),
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
