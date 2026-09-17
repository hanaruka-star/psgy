import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_shapes.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';
import 'package:psgy/features/pilot_demo/presentation/main_shell_screen.dart';

class PtAiCompleteScreen extends StatefulWidget {
  const PtAiCompleteScreen({
    super.key,
    required this.exerciseCount,
    required this.totalSeconds,
  });

  final int exerciseCount;
  final int totalSeconds;

  @override
  State<PtAiCompleteScreen> createState() => _PtAiCompleteScreenState();
}

class _PtAiCompleteScreenState extends State<PtAiCompleteScreen> {
  @override
  void initState() {
    super.initState();
    MockUserSession.instance.recordCompletedWorkout();
  }

  void _done() {
    Navigator.of(context).popUntil((route) {
      return route.settings.name == MainShellScreen.routeName || route.isFirst;
    });
  }

  String get _timeLabel {
    final minutes = widget.totalSeconds ~/ 60;
    final seconds = widget.totalSeconds % 60;
    if (minutes == 0) return '$seconds giây';
    if (seconds == 0) return '$minutes phút';
    return '$minutes phút $seconds giây';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final success = AppStatusColors.success(brightness);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Hoàn thành'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: AppSpacing.screenPadding,
              children: [
                DecoratedBox(
                  decoration: ShapeDecoration(
                    color: success.container,
                    shape: AppShapes.rect(radius: AppSpacing.radiusMd),
                  ),
                  child: Padding(
                    padding: AppSpacing.cardPadding,
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 48,
                          color: success.onContainer,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Tuyệt vời! Bạn vừa hoàn thành buổi tập cùng PT AI.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: success.onContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _SummaryRow(
                  label: 'Số bài đã tập',
                  value: '${widget.exerciseCount}',
                ),
                _SummaryRow(
                  label: 'Tổng thời gian',
                  value: _timeLabel,
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
                  onPressed: _done,
                  child: const Text('Xong'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
          Text(value, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
