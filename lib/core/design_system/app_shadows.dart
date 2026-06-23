import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static const Color _shadowColor = Color(0x40000000);
  static const Color _glowColor = Color(0x6000C2FF);

  static final List<BoxShadow> card = [
    const BoxShadow(
      color: _shadowColor,
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static final List<BoxShadow> elevated = [
    const BoxShadow(
      color: _shadowColor,
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
    const BoxShadow(
      color: Color(0x20000000),
      blurRadius: 32,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  static final List<BoxShadow> glow = [
    BoxShadow(
      color: _glowColor.withOpacity(0.3),
      blurRadius: 24,
      offset: Offset.zero,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: _glowColor.withOpacity(0.1),
      blurRadius: 48,
      offset: Offset.zero,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> coloredGlow(Color color, {double intensity = 0.3}) {
    return [
      BoxShadow(
        color: color.withOpacity(intensity),
        blurRadius: 24,
        offset: Offset.zero,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: color.withOpacity(intensity * 0.5),
        blurRadius: 48,
        offset: Offset.zero,
        spreadRadius: 0,
      ),
    ];
  }

  static final List<BoxShadow> neonBlue = [
    BoxShadow(
      color: const Color(0xFF00C2FF).withOpacity(0.4),
      blurRadius: 20,
      offset: Offset.zero,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: const Color(0xFF00C2FF).withOpacity(0.2),
      blurRadius: 40,
      offset: Offset.zero,
      spreadRadius: 0,
    ),
  ];

  static final List<BoxShadow> neonGreen = [
    BoxShadow(
      color: const Color(0xFF00FF9D).withOpacity(0.4),
      blurRadius: 20,
      offset: Offset.zero,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: const Color(0xFF00FF9D).withOpacity(0.2),
      blurRadius: 40,
      offset: Offset.zero,
      spreadRadius: 0,
    ),
  ];

  static final List<BoxShadow> subtle = [
    const BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 1),
      spreadRadius: 0,
    ),
  ];
}