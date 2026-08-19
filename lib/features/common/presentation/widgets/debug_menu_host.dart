import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_link/core/config/app_config.dart';
import 'package:parking_link/features/common/presentation/widgets/debug_menu_sheet.dart';

/// Listens for debug-menu open requests and shows a dev-only FAB on device.
class DebugMenuHost extends ConsumerStatefulWidget {
  final Widget child;

  const DebugMenuHost({super.key, required this.child});

  @override
  ConsumerState<DebugMenuHost> createState() => _DebugMenuHostState();
}

class _DebugMenuHostState extends ConsumerState<DebugMenuHost> {
  bool get _debugEnabled => !AppConfig.isProduction;

  void _openDebugMenu() {
    unawaited(_openDebugMenuDirectly());
  }

  Future<void> _openDebugMenuDirectly() async {
    HapticFeedback.mediumImpact();
    await DebugMenuSheet.showFromRootNavigator();
  }

  @override
  Widget build(BuildContext context) {
    if (!_debugEnabled) return widget.child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        Positioned(
          left: 12,
          bottom: 96,
          child: SafeArea(
            child: _DebugMenuFab(onPressed: _openDebugMenu),
          ),
        ),
      ],
    );
  }
}

class _DebugMenuFab extends StatelessWidget {
  final VoidCallback onPressed;

  const _DebugMenuFab({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      elevation: 4,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(28),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.bug_report_outlined,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}

/// Call from long-press handlers (splash logo, map search bar).
void openDebugMenuFromContext(BuildContext _, WidgetRef __) {
  if (AppConfig.isProduction) return;
  HapticFeedback.mediumImpact();
  unawaited(DebugMenuSheet.showFromRootNavigator());
}
