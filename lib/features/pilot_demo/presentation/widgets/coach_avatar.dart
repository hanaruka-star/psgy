import 'package:flutter/material.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/models/mock_coach_profile.dart';

/// Small circular Coach portrait. Keeps the existing round frame; only the
/// inner content is the local photo (initials if the asset is missing).
class CoachAvatar extends StatelessWidget {
  const CoachAvatar({
    super.key,
    required this.assetPath,
    this.initials = '',
    this.radius = 28,
  });

  factory CoachAvatar.coach(MockCoach coach, {Key? key, double radius = 28}) {
    return CoachAvatar(
      key: key,
      assetPath: coach.avatarAsset,
      initials: coach.initials,
      radius: radius,
    );
  }

  factory CoachAvatar.profile(
    MockCoachProfile profile, {
    Key? key,
    double radius = 28,
  }) {
    return CoachAvatar(
      key: key,
      assetPath: profile.avatarAsset,
      initials: profile.avatarInitials,
      radius: radius,
    );
  }

  final String assetPath;
  final String initials;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = radius * 2;
    return ClipOval(
      child: ColoredBox(
        color: theme.colorScheme.surfaceContainerHighest,
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          errorBuilder: (context, error, stackTrace) => SizedBox(
            width: size,
            height: size,
            child: ColoredBox(
              color: theme.colorScheme.primaryContainer,
              child: Center(
                child: Text(
                  initials,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontSize: radius * 0.7,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
