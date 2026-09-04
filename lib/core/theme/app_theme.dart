import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psgy/core/config/flavor.dart';
import 'package:psgy/core/theme/app_colors.dart';
import 'package:psgy/core/theme/app_shapes.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/core/theme/app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get light => _buildTheme(isDark: false);

  static ThemeData get dark => _buildTheme(isDark: true);

  static ThemeData _buildTheme({required bool isDark}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: isDark
          ? const Color(0xFF9290FA)
          : const Color(0xFF00A0E0),
      brightness: isDark ? Brightness.dark : Brightness.light,
    );
    final textTheme = GoogleFonts.interTextTheme(
      AppTextStyles.textTheme(isDark: isDark),
    );
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final tabActive = AppStatusColors.tabActive(brightness);
    const tabInactive = AppStatusColors.tabInactive;
    final coachCanvas = AppStatusColors.sheetBackground(brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      fontFamily: GoogleFonts.inter().fontFamily,
      scaffoldBackgroundColor: FlavorConfig.isCoach
          ? coachCanvas
          : (isDark ? AppColors.backgroundDark : AppColors.backgroundLight),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor:
            FlavorConfig.isCoach ? coachCanvas : colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppStatusColors.cardBackground(
          isDark: isDark,
          surface: colorScheme.surface,
        ),
        surfaceTintColor: Colors.transparent,
        shape: AppShapes.rect(radius: AppSpacing.radiusMd),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md - 2,
          ),
          shape: AppShapes.rect(radius: AppSpacing.radiusMd),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md - 2,
          ),
          shape: AppShapes.rect(radius: AppSpacing.radiusMd),
          side: BorderSide(color: colorScheme.outline),
          textStyle: textTheme.labelLarge,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: AppShapes.rect(radius: AppSpacing.radiusMd),
          textStyle: textTheme.labelLarge,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        highlightElevation: 4,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: AppShapes.rect(radius: AppSpacing.radiusMd),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AppColors.surfaceVariantDark
            : AppColors.surfaceVariantLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md - 2,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppStatusColors.sheetBackground(brightness),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: AppShapes.sheetTop(),
        dragHandleColor: colorScheme.outline,
        showDragHandle: true,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: AppShapes.rect(
          radius: AppSpacing.radiusLg,
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: AppShapes.rect(radius: AppSpacing.radiusMd),
        backgroundColor:
            isDark ? AppColors.surfaceVariantDark : AppColors.textPrimaryLight,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppStatusColors.tagBackground(
          isDark: isDark,
          surface: colorScheme.surface,
        ),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        pressElevation: 0,
        shadowColor: Colors.transparent,
        shape: AppShapes.rect(radius: AppSpacing.radiusSm),
        side: BorderSide.none,
        labelStyle: textTheme.labelMedium,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? tabActive : tabInactive,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return (textTheme.labelMedium ?? const TextStyle()).copyWith(
            color: selected ? tabActive : tabInactive,
          );
        }),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 0.5),
        thickness: 1,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.outline.withValues(alpha: 0.3),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor:
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        indicatorColor: colorScheme.primary,
        labelStyle: textTheme.labelLarge,
        unselectedLabelStyle: textTheme.labelMedium,
      ),
    );
  }
}
