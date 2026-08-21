import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_colors.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/models/mock_service.dart';
import 'package:psgy/features/pilot_demo/presentation/booking_summary_screen.dart';

class CoachDetailScreen extends StatefulWidget {
  const CoachDetailScreen({super.key, required this.coach});

  final MockCoach coach;

  @override
  State<CoachDetailScreen> createState() => _CoachDetailScreenState();
}

class _CoachDetailScreenState extends State<CoachDetailScreen> {
  late String _selectedServiceId;

  @override
  void initState() {
    super.initState();
    _selectedServiceId = widget.coach.services.first.id;
  }

  MockService get _selectedService => widget.coach.services.firstWhere(
        (service) => service.id == _selectedServiceId,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coach = widget.coach;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Chi tiết Coach')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: AppSpacing.screenPadding,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: AppColors.onPrimaryContainer,
                    child: Text(
                      coach.initials,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: AppColors.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  coach.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '⭐ ${coach.rating.toStringAsFixed(1)}  ·  ${coach.yearsExperience} năm kinh nghiệm',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  coach.nextSlotLabel,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Chọn dịch vụ', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                RadioGroup<String>(
                  groupValue: _selectedServiceId,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _selectedServiceId = value);
                  },
                  child: Column(
                    children: [
                      for (final service in coach.services)
                        RadioListTile<String>(
                          value: service.id,
                          title: Text(service.name),
                          subtitle: Text(
                            '${service.priceLabel} · ${service.durationMinutes} phút',
                          ),
                          activeColor: AppColors.primary,
                          contentPadding: EdgeInsets.zero,
                        ),
                    ],
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
                        builder: (_) => BookingSummaryScreen(
                          coach: coach,
                          service: _selectedService,
                        ),
                      ),
                    );
                  },
                  child: const Text('Tiếp tục'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
