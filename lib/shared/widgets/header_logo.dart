import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psgy/core/theme/app_colors.dart';

/// gymPS header lockup: `gym` + dumbbell-pulse mark + `PS`.
class HeaderLogo extends StatelessWidget {
  const HeaderLogo({
    super.key,
    this.fontSize = 22,
    this.onDark = false,
    this.showCoachLabel = false,
  });

  final double fontSize;
  final bool onDark;
  final bool showCoachLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark =
        onDark || Theme.of(context).brightness == Brightness.dark;
    final gymColor = onDark
        ? Colors.white
        : (isDark ? scheme.primary : AppColors.gymPsNavy);
    final psColor = onDark
        ? Colors.white
        : (isDark ? scheme.onSurface : AppColors.gymPsInk);
    final iconSize = fontSize;
    final lockup = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'gym',
          style: GoogleFonts.inter(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: gymColor,
            letterSpacing: -0.5,
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: SizedBox(
            width: iconSize,
            height: iconSize,
            child: CustomPaint(
              painter: _DumbbellPulsePainter(color: gymColor),
            ),
          ),
        ),
        Text(
          'PS',
          style: GoogleFonts.inter(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: psColor,
            letterSpacing: 0.5,
            height: 1,
          ),
        ),
      ],
    );

    return Semantics(
      label: showCoachLabel ? 'gymPS coach' : 'gymPS',
      header: true,
      child: showCoachLabel
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                lockup,
                SizedBox(height: fontSize * 0.12),
                Text(
                  'coach',
                  style: GoogleFonts.inter(
                    fontSize: fontSize * 0.42,
                    fontWeight: FontWeight.w600,
                    color: gymColor,
                    letterSpacing: 1.2,
                    height: 1,
                  ),
                ),
              ],
            )
          : lockup,
    );
  }
}

/// Stylized dumbbell whose bar is an ECG-style pulse.
class _DumbbellPulsePainter extends CustomPainter {
  const _DumbbellPulsePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2 * s, 8 * s, 3 * s, 8 * s),
        Radius.circular(s),
      ),
      fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(19 * s, 8 * s, 3 * s, 8 * s),
        Radius.circular(s),
      ),
      fill,
    );

    final pulse = Path()
      ..moveTo(5 * s, 12 * s)
      ..lineTo(8 * s, 12 * s)
      ..lineTo(10 * s, 8 * s)
      ..lineTo(13 * s, 16 * s)
      ..lineTo(15 * s, 12 * s)
      ..lineTo(19 * s, 12 * s);
    canvas.drawPath(pulse, stroke);
  }

  @override
  bool shouldRepaint(covariant _DumbbellPulsePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
