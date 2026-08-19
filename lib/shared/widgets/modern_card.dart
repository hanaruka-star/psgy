import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/shared/widgets/micro_interactions.dart';

class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;
  final bool selected;
  final BorderRadius? borderRadius;
  final bool enableScaleTap;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
    this.selected = false,
    this.borderRadius,
    this.enableScaleTap = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = borderRadius ?? AppSpacing.borderRadiusLg;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: color ??
            (selected
                ? colorScheme.primaryContainer.withValues(alpha: 0.45)
                : colorScheme.surface),
        borderRadius: radius,
        border: Border.all(
          color: selected
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.55),
          width: selected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? AppSpacing.cardPadding,
        child: child,
      ),
    );

    if (onTap == null) return card;

    if (enableScaleTap) {
      return ScaleTap(onTap: onTap, child: card);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: card,
      ),
    );
  }
}
