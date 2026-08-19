import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/user/presentation/widgets/parking_lot_marker.dart';
import 'package:psgy/shared/widgets/micro_interactions.dart';

/// Premium bell toggle for surveying lot watchlist.
class WatchFollowButton extends StatefulWidget {
  final bool isWatched;
  final bool isLoading;
  final VoidCallback onPressed;
  final bool compact;

  const WatchFollowButton({
    super.key,
    required this.isWatched,
    required this.onPressed,
    this.isLoading = false,
    this.compact = false,
  });

  @override
  State<WatchFollowButton> createState() => _WatchFollowButtonState();
}

class _WatchFollowButtonState extends State<WatchFollowButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ringController;
  late final Animation<double> _ringTurns;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _ringTurns = Tween<double>(begin: 0, end: 0.15).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(WatchFollowButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isWatched && widget.isWatched) {
      HapticFeedback.mediumImpact();
      _ringController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.isWatched ? 'Đang theo dõi' : 'Theo dõi bãi này';

    return ScaleTap(
      onTap: widget.isLoading ? null : widget.onPressed,
      enableHaptic: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        width: widget.compact ? null : double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: widget.compact ? AppSpacing.sm : AppSpacing.sm + 4,
          horizontal: widget.compact ? AppSpacing.md : AppSpacing.md,
        ),
        decoration: BoxDecoration(
          gradient: widget.isWatched
              ? null
              : LinearGradient(
                  colors: [
                    surveyingMarkerColor.withValues(alpha: 0.18),
                    surveyingMarkerDeep.withValues(alpha: 0.12),
                  ],
                ),
          color: widget.isWatched
              ? surveyingMarkerColor.withValues(alpha: 0.22)
              : null,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: surveyingMarkerColor.withValues(
              alpha: widget.isWatched ? 0.65 : 0.35,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: widget.compact ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _ringTurns,
              child: Icon(
                widget.isWatched
                    ? Icons.notifications_active_rounded
                    : Icons.notifications_none_rounded,
                color: surveyingMarkerDeep,
                size: widget.compact ? 18 : 20,
              ),
            ),
            SizedBox(width: widget.compact ? AppSpacing.xs : AppSpacing.sm),
            if (widget.isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: surveyingMarkerDeep,
                ),
              )
            else
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: surveyingMarkerDeep,
                      fontWeight: FontWeight.w700,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
