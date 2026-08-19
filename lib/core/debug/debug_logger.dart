import 'package:flutter/foundation.dart';

enum DebugLogLevel { normal, verbose }

class DebugLogger {
  DebugLogger({DebugLogLevel level = DebugLogLevel.normal}) : _level = level;

  DebugLogLevel _level;
  final Map<String, DateTime> _lastAtByKey = <String, DateTime>{};
  final Map<String, String> _lastMessageByKey = <String, String>{};

  void setLevel(DebugLogLevel level) {
    _level = level;
  }

  void log(
    String message, {
    DebugLogLevel minLevel = DebugLogLevel.normal,
  }) {
    if (!_shouldLog(minLevel)) return;
    debugPrint(message);
  }

  void logIfChanged(
    String key,
    String message, {
    DebugLogLevel minLevel = DebugLogLevel.normal,
  }) {
    if (!_shouldLog(minLevel)) return;
    if (_lastMessageByKey[key] == message) return;
    _lastMessageByKey[key] = message;
    _lastAtByKey[key] = DateTime.now();
    debugPrint(message);
  }

  void logThrottled(
    String key,
    String message, {
    int throttleMs = 900,
    bool logOnChange = true,
    DebugLogLevel minLevel = DebugLogLevel.normal,
  }) {
    if (!_shouldLog(minLevel)) return;

    final now = DateTime.now();
    final previousMessage = _lastMessageByKey[key];
    final lastAt = _lastAtByKey[key];

    if (logOnChange && previousMessage == message) {
      if (lastAt != null &&
          now.difference(lastAt).inMilliseconds < throttleMs) {
        return;
      }
    } else if (lastAt != null &&
        now.difference(lastAt).inMilliseconds < throttleMs) {
      return;
    }

    _lastAtByKey[key] = now;
    _lastMessageByKey[key] = message;
    debugPrint(message);
  }

  bool _shouldLog(DebugLogLevel minLevel) {
    if (!kDebugMode) return false;
    return _level.index >= minLevel.index;
  }
}
