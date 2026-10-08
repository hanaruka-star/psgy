import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:psgy/core/routes/app_navigator.dart';
import 'package:psgy/core/theme/app_theme.dart';

/// Flip to `false` to hide the debug switcher without deleting this file.
const kEnableDebugThemeSwitcher = true;

enum DebugThemeStyle { minimal, dark, glass, neumorph }

extension DebugThemeStyleLabel on DebugThemeStyle {
  String get label => switch (this) {
        DebugThemeStyle.minimal => 'Minimal (hiện tại)',
        DebugThemeStyle.dark => 'Dark',
        DebugThemeStyle.glass => 'Glass',
        DebugThemeStyle.neumorph => 'Neumorph',
      };
}

/// In-memory only — resets to [DebugThemeStyle.minimal] on every cold start.
class DebugThemeController extends ChangeNotifier {
  DebugThemeController._();

  static final DebugThemeController instance = DebugThemeController._();

  DebugThemeStyle currentStyle = DebugThemeStyle.minimal;

  void setStyle(DebugThemeStyle style) {
    if (currentStyle == style) return;
    currentStyle = style;
    notifyListeners();
  }

  /// Widget tests can set this to skip [GoogleFonts] network/asset loads.
  static ThemeData? debugBaseThemeOverride;

  ThemeData get themeData =>
      DebugThemeStyles.forStyle(currentStyle, base: debugBaseThemeOverride);
}

/// Parallel debug palettes. Does not edit [AppTheme].
abstract final class DebugThemeStyles {
  static const _seed = Color(0xFF00A0E0);
  static const _darkScaffold = Color(0xFF121212);
  static const _darkSurface = Color(0xFF1E1E1E);
  static const _neumorphFill = Color(0xFFE0E5EC);
  static const _glassRadius = 30.0;
  static const _neumorphRadius = 24.0;

  static const glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFC5E8F5),
      Color(0xFFD4D0F5),
      Color(0xFFE5F7F1),
    ],
  );

  static ThemeData forStyle(DebugThemeStyle style, {ThemeData? base}) {
    final official = base ?? AppTheme.light;
    return switch (style) {
      DebugThemeStyle.minimal => official,
      DebugThemeStyle.dark => darkOf(official),
      DebugThemeStyle.glass => glassOf(official),
      DebugThemeStyle.neumorph => neumorphOf(official),
    };
  }

  static ThemeData darkOf(ThemeData base) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF5EC8F0),
      brightness: Brightness.dark,
    ).copyWith(
      surface: _darkSurface,
      onSurface: const Color(0xFFF2F2F2),
    );
    final textTheme = base.textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );
    return base.copyWith(
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: _darkScaffold,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: _darkScaffold,
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: _darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: _darkSurface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _darkSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: _darkSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2A2A2A),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        side: BorderSide.none,
        labelStyle: textTheme.labelMedium?.copyWith(color: scheme.onSurface),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
        ),
      ),
    );
  }

  static ThemeData glassOf(ThemeData base) {
    final scheme = base.colorScheme.copyWith(
      surface: Colors.white.withValues(alpha: 0.18),
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_glassRadius),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
    );
    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white.withValues(alpha: 0.18),
        foregroundColor: base.colorScheme.onSurface,
        titleTextStyle: base.textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white.withValues(alpha: 0.18),
        surfaceTintColor: Colors.transparent,
        shape: shape,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.22),
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.22),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.22),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: shape,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.28),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _seed.withValues(alpha: 0.85),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_glassRadius),
          ),
        ),
      ),
    );
  }

  static ThemeData neumorphOf(ThemeData base) {
    const fill = _neumorphFill;
    final shape = NeumorphBorder(
      borderRadius: BorderRadius.circular(_neumorphRadius),
    );
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(surface: fill),
      scaffoldBackgroundColor: fill,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: fill,
        foregroundColor: base.colorScheme.onSurface,
        titleTextStyle: base.textTheme.titleLarge,
        shadowColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: fill,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: shape,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.none,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: fill,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        elevation: 0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: fill,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: NeumorphBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: fill,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: shape,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: fill,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        pressElevation: 0,
        shadowColor: Colors.transparent,
        side: BorderSide.none,
        shape: NeumorphBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: fill,
          foregroundColor: base.colorScheme.onSurface,
          shadowColor: Colors.transparent,
          shape: NeumorphBorder(
            borderRadius: BorderRadius.circular(_neumorphRadius),
          ),
        ),
      ),
    );
  }

  static Widget decorate(Widget child) {
    if (DebugThemeController.instance.currentStyle != DebugThemeStyle.glass) {
      return child;
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: glassGradient),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: const ColoredBox(color: Color(0x26FFFFFF)),
            ),
          ),
        ),
        child,
      ],
    );
  }

  static Widget wrap(Widget child) {
    if (!kEnableDebugThemeSwitcher) return child;
    return ListenableBuilder(
      listenable: DebugThemeController.instance,
      builder: (context, _) {
        return Stack(
          children: [
            Theme(
              data: DebugThemeController.instance.themeData,
              child: decorate(child),
            ),
            const DebugThemeFab(),
          ],
        );
      },
    );
  }
}

/// Dual soft shadows for Neumorph, painted via [ShapeBorder] so [Card] picks it up.
class NeumorphBorder extends RoundedRectangleBorder {
  const NeumorphBorder({
    super.borderRadius = const BorderRadius.all(Radius.circular(24)),
  }) : super(side: BorderSide.none);

  static const _dark = Color(0xFFBEC3C9);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final rrect = borderRadius.resolve(textDirection).toRRect(rect);
    // Shadows live in ShapeBorder.paint, which runs *over* the fill and
    // *under* children. Clip the interior out so text/icons stay readable.
    final halo = rect.inflate(24);
    final ring = Path.combine(
      PathOperation.difference,
      Path()..addRect(halo),
      Path()..addRRect(rrect),
    );
    canvas.save();
    canvas.clipPath(ring);
    final dark = Paint()
      ..color = _dark
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    final light = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawRRect(rrect.shift(const Offset(6, 6)), dark);
    canvas.drawRRect(rrect.shift(const Offset(-6, -6)), light);
    canvas.restore();
    super.paint(canvas, rect, textDirection: textDirection);
  }

  @override
  NeumorphBorder copyWith({
    BorderSide? side,
    BorderRadiusGeometry? borderRadius,
  }) {
    return NeumorphBorder(borderRadius: borderRadius ?? this.borderRadius);
  }

  @override
  NeumorphBorder scale(double t) {
    return NeumorphBorder(borderRadius: borderRadius * t);
  }
}

class DebugThemeFab extends StatelessWidget {
  const DebugThemeFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 100,
      child: Material(
        key: const Key('debug_theme_fab'),
        color: Colors.black.withValues(alpha: 0.4),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => _openSheet(context),
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(
              Icons.palette_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> _openSheet(BuildContext context) {
    // FAB sits in MaterialApp.builder, sibling of the Navigator.
    final navContext = appNavigatorKey.currentContext ?? context;
    return showModalBottomSheet<void>(
      context: navContext,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return ListenableBuilder(
          listenable: DebugThemeController.instance,
          builder: (context, _) {
            final selected = DebugThemeController.instance.currentStyle;
            return SafeArea(
              child: RadioGroup<DebugThemeStyle>(
                groupValue: selected,
                onChanged: (value) {
                  if (value == null) return;
                  DebugThemeController.instance.setStyle(value);
                  Navigator.of(sheetContext).pop();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final style in DebugThemeStyle.values)
                      RadioListTile<DebugThemeStyle>(
                        key: Key('debug_theme_option_${style.name}'),
                        value: style,
                        title: Text(style.label),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
