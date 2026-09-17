import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/data/mock_ai_exercises.dart';
import 'package:psgy/features/pilot_demo/models/mock_ai_exercise.dart';
import 'package:psgy/features/pilot_demo/presentation/pt_ai/pt_ai_session_screen.dart';

class PtAiPickerScreen extends StatefulWidget {
  const PtAiPickerScreen({super.key});

  @override
  State<PtAiPickerScreen> createState() => _PtAiPickerScreenState();
}

class _PtAiPickerScreenState extends State<PtAiPickerScreen> {
  final Set<String> _selectedIds = {mockAiExercises.first.id};

  List<MockAiExercise> get _selected {
    return [
      for (final exercise in mockAiExercises)
        if (_selectedIds.contains(exercise.id)) exercise,
    ];
  }

  void _toggle(String id, bool selected) {
    setState(() {
      if (selected) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
    });
  }

  void _start() {
    final exercises = _selected;
    if (exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chọn ít nhất 1 bài tập')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PtAiSessionScreen(exercises: exercises),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Chọn bài tập')),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: AppSpacing.screenPadding,
              itemCount: mockAiExercises.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final exercise = mockAiExercises[index];
                final selected = _selectedIds.contains(exercise.id);
                return _ExerciseTile(
                  exercise: exercise,
                  selected: selected,
                  onChanged: (value) => _toggle(exercise.id, value ?? false),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _selectedIds.isEmpty ? null : _start,
                  child: Text(
                    _selectedIds.isEmpty
                        ? 'Bắt đầu tập'
                        : 'Bắt đầu tập (${_selectedIds.length})',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({
    required this.exercise,
    required this.selected,
    required this.onChanged,
  });

  final MockAiExercise exercise;
  final bool selected;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onChanged(!selected),
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: AppSpacing.borderRadiusSm,
                child: Image.asset(
                  exercise.thumbnailAsset,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return ColoredBox(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const SizedBox(
                        width: 64,
                        height: 64,
                        child: Icon(Icons.fitness_center_outlined),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exercise.name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      exercise.description,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTag(label: exercise.durationLabel),
                  ],
                ),
              ),
              Checkbox(
                value: selected,
                onChanged: onChanged,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
