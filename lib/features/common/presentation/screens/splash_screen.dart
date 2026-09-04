import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/config/app_config.dart';
import 'package:psgy/core/config/flavor.dart';
import 'package:psgy/core/theme/app_colors.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/common/presentation/widgets/debug_menu_host.dart';
import 'package:psgy/shared/widgets/header_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  final VoidCallback onFinished;
  final String appName;

  const SplashScreen({
    super.key,
    required this.onFinished,
    required this.appName,
  });

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _scale = Tween<double>(begin: 0.82, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    Future<void>.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) widget.onFinished();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canvas = FlavorConfig.isCoach
        ? AppStatusColors.sheetBackground(Brightness.light)
        : Colors.white;
    return Scaffold(
      backgroundColor: canvas,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fade.value,
              child: Transform.scale(
                scale: _scale.value,
                child: child,
              ),
            );
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              GestureDetector(
                onLongPress: () => openDebugMenuFromContext(context, ref),
                child: HeaderLogo(
                  fontSize: 32,
                  showCoachLabel: FlavorConfig.isCoach,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                widget.appName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.gymPsInk.withValues(alpha: 0.7),
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppConfig.tagline,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
              ),
              if (!AppConfig.isProduction) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: AppSpacing.chipPadding,
                  decoration: BoxDecoration(
                    color: AppColors.gymPsNavy.withValues(alpha: 0.08),
                    borderRadius: AppSpacing.borderRadiusSm,
                  ),
                  child: Text(
                    AppConfig.environmentLabel,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.gymPsNavy,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Giữ logo để mở Debug Menu',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                ),
              ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
