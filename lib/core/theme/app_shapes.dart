import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_spacing.dart';

/// Continuous-corner (squircle) shapes for [AppTheme].
abstract final class AppShapes {
  static const double cornerSmoothing = 0.8;

  static SmoothRadius radius(double cornerRadius) {
    return SmoothRadius(
      cornerRadius: cornerRadius,
      cornerSmoothing: cornerSmoothing,
    );
  }

  static SmoothBorderRadius all(double cornerRadius) {
    return SmoothBorderRadius(
      cornerRadius: cornerRadius,
      cornerSmoothing: cornerSmoothing,
    );
  }

  static SmoothRectangleBorder rect({
    required double radius,
    BorderSide side = BorderSide.none,
  }) {
    return SmoothRectangleBorder(
      side: side,
      borderRadius: all(radius),
    );
  }

  static SmoothRectangleBorder sheetTop({
    BorderSide side = BorderSide.none,
  }) {
    return SmoothRectangleBorder(
      side: side,
      borderRadius: SmoothBorderRadius.only(
        topLeft: radius(AppSpacing.radiusXl),
        topRight: radius(AppSpacing.radiusXl),
      ),
    );
  }
}
