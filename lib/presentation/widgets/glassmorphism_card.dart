import 'dart:ui';

import 'package:flutter/material.dart';

class GlassmorphismCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final double opacity;
  final double blur;
  final Color? borderColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const GlassmorphismCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.opacity = 0.1,
    this.blur = 16,
    this.borderColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(16);

    Widget card = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          margin: margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            gradient: backgroundColor != null
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: opacity),
                      Colors.white.withValues(alpha: opacity * 0.5),
                    ],
                  ),
            borderRadius: radius,
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      card = GestureDetector(onTap: onTap, child: card);
    }

    return card;
  }
}
