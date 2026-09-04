import 'package:flutter/material.dart';

/// ParkingLink brand and semantic colors.
abstract final class AppColors {
  // Brand — modern blue
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryContainer = Color(0xFFDBEAFE);
  static const Color onPrimaryContainer = Color(0xFF1E3A8A);

  /// gymPS lockup — navy + ink (header logo).
  static const Color gymPsNavy = Color(0xFF1E3A8A);
  static const Color gymPsNavyDeep = Color(0xFF0A192F);
  static const Color gymPsInk = Color(0xFF0F172A);

  // Semantic
  static const Color success = Color(0xFF22C55E);
  static const Color successContainer = Color(0xFFDCFCE7);
  static const Color onSuccessContainer = Color(0xFF14532D);

  static const Color warning = Color(0xFFF97316);
  static const Color warningContainer = Color(0xFFFFEDD5);
  static const Color onWarningContainer = Color(0xFF7C2D12);

  static const Color danger = Color(0xFFEF4444);
  static const Color dangerContainer = Color(0xFFFEE2E2);
  static const Color onDangerContainer = Color(0xFF7F1D1D);

  // Light neutrals
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF1F5F9);
  static const Color outlineLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // Dark neutrals
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceVariantDark = Color(0xFF334155);
  static const Color outlineDark = Color(0xFF475569);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Gradients
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient brandGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primary],
  );

  /// Slot availability color based on ratio (available / total).
  static Color slotColor(double ratio) {
    if (ratio > 0.5) return success;
    if (ratio > 0.1) return warning;
    return danger;
  }

  static Color slotContainerColor(double ratio, {required bool isDark}) {
    if (ratio > 0.5) return isDark ? const Color(0xFF14532D) : successContainer;
    if (ratio > 0.1) return isDark ? const Color(0xFF7C2D12) : warningContainer;
    return isDark ? const Color(0xFF7F1D1D) : dangerContainer;
  }
}
