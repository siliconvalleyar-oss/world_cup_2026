import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const String _fontFamily = 'Inter';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: Color(0xFFB0B0B0),
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: Color(0xFFB0B0B0),
  );

  static TextTheme get darkTextTheme => const TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );

  static TextTheme get lightTextTheme => TextTheme(
    displayLarge: displayLarge.copyWith(color: const Color(0xFF0A0A0A)),
    displayMedium: displayMedium.copyWith(color: const Color(0xFF0A0A0A)),
    displaySmall: displaySmall.copyWith(color: const Color(0xFF0A0A0A)),
    headlineLarge: headlineLarge.copyWith(color: const Color(0xFF0A0A0A)),
    headlineMedium: headlineMedium.copyWith(color: const Color(0xFF0A0A0A)),
    headlineSmall: headlineSmall.copyWith(color: const Color(0xFF0A0A0A)),
    titleLarge: titleLarge.copyWith(color: const Color(0xFF0A0A0A)),
    titleMedium: titleMedium.copyWith(color: const Color(0xFF0A0A0A)),
    titleSmall: titleSmall.copyWith(color: const Color(0xFF0A0A0A)),
    bodyLarge: bodyLarge.copyWith(color: const Color(0xFF0A0A0A)),
    bodyMedium: bodyMedium.copyWith(color: const Color(0xFF0A0A0A)),
    bodySmall: bodySmall.copyWith(color: const Color(0xFF4A4A4A)),
    labelLarge: labelLarge.copyWith(color: const Color(0xFF0A0A0A)),
    labelMedium: labelMedium.copyWith(color: const Color(0xFF0A0A0A)),
    labelSmall: labelSmall.copyWith(color: const Color(0xFF4A4A4A)),
  );
}