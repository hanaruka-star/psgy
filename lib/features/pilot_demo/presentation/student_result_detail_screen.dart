import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/models/mock_student_result.dart';

class StudentResultDetailScreen extends StatelessWidget {
  const StudentResultDetailScreen({super.key, required this.result});

  final MockStudentResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = AppStatusColors.highlight(theme.brightness);

    return Scaffold(
      appBar: AppBar(
        title: Text(result.studentLabel),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Row(
            children: [
              Expanded(
                child: _LabeledPhoto(
                  label: 'Trước',
                  url: result.beforeImageUrl,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _LabeledPhoto(
                  label: 'Sau',
                  url: result.afterImageUrl,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Tóm tắt', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(result.summary, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          Text('Nhật ký tiến độ', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < result.timeline.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent,
                      ),
                    ),
                    if (i < result.timeline.length - 1)
                      Container(
                        width: 2,
                        height: 36,
                        color: accent.withValues(alpha: 0.35),
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.timeline[i].dateLabel,
                          style: theme.textTheme.labelLarge,
                        ),
                        Text(
                          result.timeline[i].note,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LabeledPhoto extends StatelessWidget {
  const _LabeledPhoto({required this.label, required this.url});

  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: AppSpacing.borderRadiusMd,
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Image.asset(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return ColoredBox(
                  color: theme.colorScheme.primaryContainer,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
