import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/debug/debug_logger.dart';

final debugLogLevelProvider =
    StateProvider<DebugLogLevel>((ref) => DebugLogLevel.normal);

final debugLoggerProvider = Provider<DebugLogger>((ref) {
  final logger = DebugLogger(level: ref.read(debugLogLevelProvider));
  final levelSub = ref.listen<DebugLogLevel>(
    debugLogLevelProvider,
    (_, next) => logger.setLevel(next),
  );
  ref.onDispose(levelSub.close);
  return logger;
});
