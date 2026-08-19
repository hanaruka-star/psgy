import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/shared/widgets/loading_shimmer.dart';

/// Amber-tinted shimmer for surveying lot cards while data loads.
class SurveyLoadingShimmer extends StatelessWidget {
  const SurveyLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: AppSpacing.borderRadiusMd,
          child: _AmberShimmer(height: 140),
        ),
        SizedBox(height: AppSpacing.md),
        _AmberShimmer(height: 18, width: 180),
        SizedBox(height: AppSpacing.sm),
        _AmberShimmer(height: 14),
        SizedBox(height: AppSpacing.md),
        _AmberShimmer(height: 28, width: 120),
      ],
    );
  }
}

class _AmberShimmer extends StatelessWidget {
  final double height;
  final double? width;

  const _AmberShimmer({required this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer(
      height: height,
      width: width,
      borderRadius: AppSpacing.borderRadiusSm,
    );
  }
}
