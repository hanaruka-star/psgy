import 'package:flutter/material.dart';

/// Semantic status pairs — light and dark, not a single hex for both modes.
class AppStatusPair {
  const AppStatusPair({required this.container, required this.onContainer});

  final Color container;
  final Color onContainer;
}

abstract final class AppStatusColors {
  static AppStatusPair warning(Brightness brightness) {
    return brightness == Brightness.dark
        ? const AppStatusPair(
            container: Color(0xFF5C3D1A),
            onContainer: Color(0xFFFFEDD5),
          )
        : const AppStatusPair(
            container: Color(0xFFFFEDD5),
            onContainer: Color(0xFF7C2D12),
          );
  }

  static AppStatusPair success(Brightness brightness) {
    return brightness == Brightness.dark
        ? const AppStatusPair(
            container: Color(0xFF14532D),
            onContainer: Color(0xFFDCFCE7),
          )
        : const AppStatusPair(
            container: Color(0xFFDCFCE7),
            onContainer: Color(0xFF14532D),
          );
  }

  static AppStatusPair danger(Brightness brightness) {
    return brightness == Brightness.dark
        ? const AppStatusPair(
            container: Color(0xFF7F1D1D),
            onContainer: Color(0xFFFEE2E2),
          )
        : const AppStatusPair(
            container: Color(0xFFFEE2E2),
            onContainer: Color(0xFF7F1D1D),
          );
  }

  static Color warningFg(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFFFDBA74)
        : const Color(0xFFF97316);
  }

  static Color successFg(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF86EFAC)
        : const Color(0xFF16A34A);
  }

  /// Card fill — Light `#EFF3FA`; Dark keeps E7 blend (15% white on surface).
  static Color cardBackground({
    required bool isDark,
    required Color surface,
  }) {
    if (isDark) {
      return Color.alphaBlend(
        Colors.white.withValues(alpha: 0.15),
        surface,
      );
    }
    return const Color(0xFFEFF3FA);
  }

  /// Tag fill — Light `#EFF3FA`; Dark = E7-style blend at 12% white on surface.
  static Color tagBackground({
    required bool isDark,
    required Color surface,
  }) {
    if (isDark) {
      return Color.alphaBlend(
        Colors.white.withValues(alpha: 0.12),
        surface,
      );
    }
    return const Color(0xFFEFF3FA);
  }

  static Color tagBackgroundOf(BuildContext context) {
    final theme = Theme.of(context);
    return tagBackground(
      isDark: theme.brightness == Brightness.dark,
      surface: theme.colorScheme.surface,
    );
  }

  /// "Rảnh …" label + flat rating star. Light `#346B34`, Dark `#7BC17B`.
  static Color highlight(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF7BC17B)
        : const Color(0xFF346B34);
  }

  /// Ink on [highlight] fill (wallet buttons, map marker hole).
  static Color onHighlight(Brightness brightness) {
    final fill = highlight(brightness);
    return ThemeData.estimateBrightnessForColor(fill) == Brightness.dark
        ? Colors.white
        : const Color(0xFF14532D);
  }

  static ButtonStyle highlightFilledButton(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return FilledButton.styleFrom(
      backgroundColor: highlight(brightness),
      foregroundColor: onHighlight(brightness),
    );
  }

  static TextStyle? headingStyle(BuildContext context, [TextStyle? base]) {
    final theme = Theme.of(context);
    return (base ?? theme.textTheme.titleLarge)?.copyWith(
      color: sheetTitle(theme.brightness),
    );
  }

  /// Selected bottom-bar icon/label. Light `#275F95`, Dark `#7BAEE0`.
  static Color tabActive(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF7BAEE0)
        : const Color(0xFF275F95);
  }

  /// Unselected bottom-bar icon/label — xám sáng `#94A3B8`.
  static const Color tabInactive = Color(0xFF94A3B8);

  /// Map / modal bottom sheet fill. Light `#DEF0F1`.
  static Color sheetBackground(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF1E2A2A)
        : const Color(0xFFDEF0F1);
  }

  /// Sheet heading e.g. "Coach gần bạn". Light `#2E2F2F`.
  static Color sheetTitle(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFFE8E8E8)
        : const Color(0xFF2E2F2F);
  }
}

class AppTag extends StatelessWidget {
  const AppTag({super.key, required this.label, this.highlight = false});

  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = highlight
        ? AppStatusColors.highlight(theme.brightness)
        : theme.colorScheme.onSurface;
    return Chip(
      visualDensity: VisualDensity.compact,
      label: Text(label),
      backgroundColor: AppStatusColors.tagBackgroundOf(context),
      side: BorderSide.none,
      labelStyle: theme.textTheme.labelMedium?.copyWith(color: fg),
    );
  }
}

class AppRating extends StatelessWidget {
  const AppRating({
    super.key,
    required this.value,
    this.suffix,
    this.style,
  });

  final double value;
  final String? suffix;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppStatusColors.highlight(theme.brightness);
    final textStyle = (style ?? theme.textTheme.bodySmall)?.copyWith(
      color: color,
    );
    final label = suffix == null
        ? value.toStringAsFixed(1)
        : '${value.toStringAsFixed(1)}  ·  $suffix';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: 16, color: color),
        const SizedBox(width: 4),
        Text(label, style: textStyle),
      ],
    );
  }
}
