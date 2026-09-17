import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psgy/core/theme/app_shapes.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/models/mock_ai_exercise.dart';
import 'package:psgy/features/pilot_demo/presentation/pt_ai/pt_ai_complete_screen.dart';

enum _PtAiPhase { workout, rest }

class PtAiSessionScreen extends StatefulWidget {
  const PtAiSessionScreen({super.key, required this.exercises});

  static const restSeconds = 5;

  final List<MockAiExercise> exercises;

  @override
  State<PtAiSessionScreen> createState() => _PtAiSessionScreenState();
}

class _PtAiSessionScreenState extends State<PtAiSessionScreen> {
  CameraController? _camera;
  Timer? _timer;
  var _index = 0;
  var _phase = _PtAiPhase.workout;
  var _elapsed = 0;
  late int _remaining;
  var _cameraReady = false;
  var _cameraFailed = false;

  MockAiExercise get _exercise => widget.exercises[_index];

  String get _cueText {
    if (_phase == _PtAiPhase.rest) {
      final next = widget.exercises[_index + 1];
      return 'Nghỉ — tiếp theo: ${next.name}';
    }
    var message = _exercise.cues.isEmpty ? '' : _exercise.cues.first.message;
    for (final cue in _exercise.cues) {
      if (cue.atSecond <= _elapsed) message = cue.message;
    }
    return message;
  }

  @override
  void initState() {
    super.initState();
    _remaining = _exercise.durationSeconds;
    _initCamera();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _camera?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (!mounted || cameras.isEmpty) return;
      final front = cameras.firstWhere(
        (item) => item.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        front,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _camera = controller;
        _cameraReady = true;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _cameraReady = false;
          _cameraFailed = true;
        });
      }
    }
  }

  void _tick() {
    if (_remaining <= 1) {
      _advance();
      return;
    }
    setState(() {
      _remaining -= 1;
      if (_phase == _PtAiPhase.workout) _elapsed += 1;
    });
  }

  void _advance() {
    if (_phase == _PtAiPhase.workout && _index < widget.exercises.length - 1) {
      setState(() {
        _phase = _PtAiPhase.rest;
        _elapsed = 0;
        _remaining = PtAiSessionScreen.restSeconds;
      });
      return;
    }
    if (_phase == _PtAiPhase.rest) {
      setState(() {
        _index += 1;
        _phase = _PtAiPhase.workout;
        _elapsed = 0;
        _remaining = _exercise.durationSeconds;
      });
      return;
    }
    _timer?.cancel();
    final totalSeconds = widget.exercises.fold<int>(
      0,
      (sum, item) => sum + item.durationSeconds,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => PtAiCompleteScreen(
          exerciseCount: widget.exercises.length,
          totalSeconds: totalSeconds,
        ),
      ),
    );
  }

  Future<void> _stop() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Dừng buổi tập?'),
          content: const Text('Tiến trình bài tập hiện tại sẽ không được lưu.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Tiếp tục tập'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Dừng'),
            ),
          ],
        );
      },
    );
    if (leave == true && mounted) Navigator.of(context).pop();
  }

  String _clock(int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overlay = theme.brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.light;
    final title = _phase == _PtAiPhase.rest ? 'Nghỉ' : _exercise.name;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            _CameraStage(
              controller: _camera,
              ready: _cameraReady,
              failed: _cameraFailed,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x99000000),
                    Color(0x00000000),
                    Color(0x00000000),
                    Color(0xB3000000),
                  ],
                  stops: [0, 0.22, 0.62, 1],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.sm,
                      AppSpacing.sm,
                      AppSpacing.sm,
                      0,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _stop,
                          tooltip: 'Dừng',
                          color: Colors.white,
                          icon: const Icon(Icons.close),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${_index + 1}/${widget.exercises.length}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Text(
                    _clock(_remaining),
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.lg,
                    ),
                    child: _AiCueBubble(message: _cueText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraStage extends StatelessWidget {
  const _CameraStage({
    required this.controller,
    required this.ready,
    required this.failed,
  });

  final CameraController? controller;
  final bool ready;
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final live = controller;
    if (ready && live != null && live.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: live.value.previewSize?.height ?? 720,
          height: live.value.previewSize?.width ?? 1280,
          child: CameraPreview(live),
        ),
      );
    }
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.videocam_outlined,
              size: 48,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              failed
                  ? 'Camera chưa sẵn sàng — AI vẫn hướng dẫn'
                  : 'Đang mở camera trước…',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiCueBubble extends StatelessWidget {
  const _AiCueBubble({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.86,
        ),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.94),
            shape: AppShapes.rect(radius: AppSpacing.radiusMd),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppStatusColors.highlight(theme.brightness),
                  foregroundColor: AppStatusColors.onHighlight(theme.brightness),
                  child: const Icon(Icons.smart_toy_outlined, size: 18),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    message,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
