import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psgy/core/config/app_config.dart';
import 'package:psgy/core/config/flavor.dart';
import 'package:psgy/core/theme/app_colors.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/core/theme/app_theme.dart';

String hex(Color c) {
  final v = c.toARGB32();
  return '#${v.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
}

void dumpScheme(String label, ColorScheme s) {
  // ignore: avoid_print
  print('=== ColorScheme $label ===');
  final fields = <String, Color>{
    'primary': s.primary,
    'onPrimary': s.onPrimary,
    'primaryContainer': s.primaryContainer,
    'onPrimaryContainer': s.onPrimaryContainer,
    'primaryFixed': s.primaryFixed,
    'primaryFixedDim': s.primaryFixedDim,
    'onPrimaryFixed': s.onPrimaryFixed,
    'onPrimaryFixedVariant': s.onPrimaryFixedVariant,
    'secondary': s.secondary,
    'onSecondary': s.onSecondary,
    'secondaryContainer': s.secondaryContainer,
    'onSecondaryContainer': s.onSecondaryContainer,
    'secondaryFixed': s.secondaryFixed,
    'secondaryFixedDim': s.secondaryFixedDim,
    'onSecondaryFixed': s.onSecondaryFixed,
    'onSecondaryFixedVariant': s.onSecondaryFixedVariant,
    'tertiary': s.tertiary,
    'onTertiary': s.onTertiary,
    'tertiaryContainer': s.tertiaryContainer,
    'onTertiaryContainer': s.onTertiaryContainer,
    'tertiaryFixed': s.tertiaryFixed,
    'tertiaryFixedDim': s.tertiaryFixedDim,
    'onTertiaryFixed': s.onTertiaryFixed,
    'onTertiaryFixedVariant': s.onTertiaryFixedVariant,
    'error': s.error,
    'onError': s.onError,
    'errorContainer': s.errorContainer,
    'onErrorContainer': s.onErrorContainer,
    'surface': s.surface,
    'onSurface': s.onSurface,
    'surfaceDim': s.surfaceDim,
    'surfaceBright': s.surfaceBright,
    'surfaceContainerLowest': s.surfaceContainerLowest,
    'surfaceContainerLow': s.surfaceContainerLow,
    'surfaceContainer': s.surfaceContainer,
    'surfaceContainerHigh': s.surfaceContainerHigh,
    'surfaceContainerHighest': s.surfaceContainerHighest,
    'onSurfaceVariant': s.onSurfaceVariant,
    'outline': s.outline,
    'outlineVariant': s.outlineVariant,
    'shadow': s.shadow,
    'scrim': s.scrim,
    'inverseSurface': s.inverseSurface,
    'onInverseSurface': s.onInverseSurface,
    'inversePrimary': s.inversePrimary,
    'surfaceTint': s.surfaceTint,
  };
  for (final e in fields.entries) {
    // ignore: avoid_print
    print('  ${e.key}: ${hex(e.value)}');
  }
}

void dumpTheme(String label, ThemeData t) {
  // ignore: avoid_print
  print('=== ThemeData extras $label ===');
  // ignore: avoid_print
  print('  scaffoldBackgroundColor: ${hex(t.scaffoldBackgroundColor)}');
  // ignore: avoid_print
  print('  canvasColor: ${hex(t.canvasColor)}');
  // ignore: avoid_print
  print('  cardColor: ${hex(t.cardColor)}');
  // ignore: avoid_print
  print('  dividerColor: ${hex(t.dividerColor)}');
  // ignore: avoid_print
  print('  focusColor: ${hex(t.focusColor)}');
  // ignore: avoid_print
  print('  hoverColor: ${hex(t.hoverColor)}');
  // ignore: avoid_print
  print('  highlightColor: ${hex(t.highlightColor)}');
  // ignore: avoid_print
  print('  splashColor: ${hex(t.splashColor)}');
  // ignore: avoid_print
  print('  unselectedWidgetColor: ${hex(t.unselectedWidgetColor)}');
  // ignore: avoid_print
  print('  disabledColor: ${hex(t.disabledColor)}');
  // ignore: avoid_print
  print('  secondaryHeaderColor: ${hex(t.secondaryHeaderColor)}');
  // ignore: avoid_print
  print('  hintColor: ${hex(t.hintColor)}');
  final card = t.cardTheme.color;
  if (card != null) {
    // ignore: avoid_print
    print('  cardTheme.color: ${hex(card)}');
  }
  final appBar = t.appBarTheme.backgroundColor;
  if (appBar != null) {
    // ignore: avoid_print
    print('  appBarTheme.backgroundColor: ${hex(appBar)}');
  }
}

void dumpStatus(String mode, Brightness b, Color surface) {
  final isDark = b == Brightness.dark;
  // ignore: avoid_print
  print('=== AppStatusColors $mode ===');
  final w = AppStatusColors.warning(b);
  final s = AppStatusColors.success(b);
  final d = AppStatusColors.danger(b);
  // ignore: avoid_print
  print('  warning.container: ${hex(w.container)}');
  // ignore: avoid_print
  print('  warning.onContainer: ${hex(w.onContainer)}');
  // ignore: avoid_print
  print('  success.container: ${hex(s.container)}');
  // ignore: avoid_print
  print('  success.onContainer: ${hex(s.onContainer)}');
  // ignore: avoid_print
  print('  danger.container: ${hex(d.container)}');
  // ignore: avoid_print
  print('  danger.onContainer: ${hex(d.onContainer)}');
  // ignore: avoid_print
  print('  warningFg: ${hex(AppStatusColors.warningFg(b))}');
  // ignore: avoid_print
  print('  successFg: ${hex(AppStatusColors.successFg(b))}');
  // ignore: avoid_print
  print(
    '  cardBackground: ${hex(AppStatusColors.cardBackground(isDark: isDark, surface: surface))}',
  );
  // ignore: avoid_print
  print(
    '  tagBackground: ${hex(AppStatusColors.tagBackground(isDark: isDark, surface: surface))}',
  );
  // ignore: avoid_print
  print('  highlight: ${hex(AppStatusColors.highlight(b))}');
  // ignore: avoid_print
  print('  onHighlight: ${hex(AppStatusColors.onHighlight(b))}');
  // ignore: avoid_print
  print('  tabActive: ${hex(AppStatusColors.tabActive(b))}');
  // ignore: avoid_print
  print('  tabInactive: ${hex(AppStatusColors.tabInactive)}');
  // ignore: avoid_print
  print('  sheetBackground: ${hex(AppStatusColors.sheetBackground(b))}');
  // ignore: avoid_print
  print('  sheetTitle: ${hex(AppStatusColors.sheetTitle(b))}');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  FlutterError.onError = (details) {
    if (details.exception.toString().contains('google_fonts') ||
        details.exception.toString().contains('Failed to load font') ||
        details.exception.toString().contains('allowRuntimeFetching')) {
      return;
    }
    FlutterError.presentError(details);
  };

  test('dump AppTheme colors', () {
    AppConfig.initialize();
    FlavorConfig.initialize(AppFlavor.user);
    dumpScheme('LIGHT (seed #00A0E0)', AppTheme.light.colorScheme);
    dumpTheme('LIGHT user', AppTheme.light);
    dumpStatus('LIGHT', Brightness.light, AppTheme.light.colorScheme.surface);

    dumpScheme('DARK (seed #9290FA)', AppTheme.dark.colorScheme);
    dumpTheme('DARK user', AppTheme.dark);
    dumpStatus('DARK', Brightness.dark, AppTheme.dark.colorScheme.surface);

    FlavorConfig.initialize(AppFlavor.coach);
    dumpTheme('LIGHT coach', AppTheme.light);
    dumpTheme('DARK coach', AppTheme.dark);

    // ignore: avoid_print
    print('=== AppColors (hardcoded, not fromSeed) ===');
    final brand = <String, Color>{
      'primary': AppColors.primary,
      'primaryLight': AppColors.primaryLight,
      'primaryDark': AppColors.primaryDark,
      'primaryContainer': AppColors.primaryContainer,
      'onPrimaryContainer': AppColors.onPrimaryContainer,
      'gymPsNavy': AppColors.gymPsNavy,
      'gymPsNavyDeep': AppColors.gymPsNavyDeep,
      'gymPsInk': AppColors.gymPsInk,
      'success': AppColors.success,
      'successContainer': AppColors.successContainer,
      'onSuccessContainer': AppColors.onSuccessContainer,
      'warning': AppColors.warning,
      'warningContainer': AppColors.warningContainer,
      'onWarningContainer': AppColors.onWarningContainer,
      'danger': AppColors.danger,
      'dangerContainer': AppColors.dangerContainer,
      'onDangerContainer': AppColors.onDangerContainer,
      'backgroundLight': AppColors.backgroundLight,
      'surfaceLight': AppColors.surfaceLight,
      'surfaceVariantLight': AppColors.surfaceVariantLight,
      'outlineLight': AppColors.outlineLight,
      'textPrimaryLight': AppColors.textPrimaryLight,
      'textSecondaryLight': AppColors.textSecondaryLight,
      'backgroundDark': AppColors.backgroundDark,
      'surfaceDark': AppColors.surfaceDark,
      'surfaceVariantDark': AppColors.surfaceVariantDark,
      'outlineDark': AppColors.outlineDark,
      'textPrimaryDark': AppColors.textPrimaryDark,
      'textSecondaryDark': AppColors.textSecondaryDark,
    };
    for (final e in brand.entries) {
      // ignore: avoid_print
      print('  ${e.key}: ${hex(e.value)}');
    }
  });
}
