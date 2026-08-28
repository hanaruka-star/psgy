import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_colors.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/pilot_demo/data/mock_coaches.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/presentation/coach_detail_screen.dart';

/// Danh sách Coach cho WEB demo — KHÔNG dùng Google Map (tránh cần API key).
/// Thay thế PilotMapScreen trên web; trên iOS/Android vẫn dùng map thật.
class PilotListScreen extends StatelessWidget {
  const PilotListScreen({super.key});

  void _openCoach(BuildContext context, MockCoach coach) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CoachDetailScreen(coach: coach),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Coach gần bạn'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: AppSpacing.screenPadding,
        itemCount: mockCoaches.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final coach = mockCoaches[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _openCoach(context, coach),
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: AppColors.onPrimaryContainer,
                      child: Text(
                        coach.initials,
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
                          Text(coach.name, style: theme.textTheme.titleMedium),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '⭐ ${coach.rating.toStringAsFixed(1)}  ·  ${coach.distanceKm.toStringAsFixed(1)} km',
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Chip(
                            visualDensity: VisualDensity.compact,
                            label: Text(coach.nextSlotLabel),
                            backgroundColor: AppColors.primaryContainer,
                            side: BorderSide.none,
                            labelStyle:
                                theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: theme.colorScheme.outline),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
