import 'package:psgy/features/pilot_demo/models/mock_ai_cue.dart';

class MockAiExercise {
  final String id;
  final String name;
  final String description;
  final int durationSeconds;
  final String thumbnailAsset;
  final List<MockAiCue> cues;

  const MockAiExercise({
    required this.id,
    required this.name,
    required this.description,
    required this.durationSeconds,
    required this.thumbnailAsset,
    this.cues = const [],
  });

  String get durationLabel => '$durationSeconds giây';
}
