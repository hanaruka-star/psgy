import 'package:flutter_riverpod/flutter_riverpod.dart';

/// When true, app behaves as if network is unavailable (dev/staging QA only).
final debugSimulateOfflineProvider = StateProvider<bool>((ref) => false);
