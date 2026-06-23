import 'package:flutter/material.dart';

class AppGlassEffects {
  AppGlassEffects._();

  static const Color _glassBorder = Color(0x33FFFFFF);
  static const Color _glassBackground = Color(0x1AFFFFFF);
  static const Color _glassBackgroundLight = Color(0x0DFFFFFF);

  static BoxDecoration get glass => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        _glassBackground,
        _glassBackgroundLight,
      ],
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: _glassBorder,
      width: 1,
    ),
  );

  static BoxDecoration get glassLight => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        _glassBackgroundLight,
        _glassBackground,
      ],
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: _glassBorder.withOpacity(0.5),
      width: 1,
    ),
  );

  static BoxDecoration get glassCard => BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0x16FFFFFF),
        Color(0x08FFFFFF),
      ],
    ),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: _glassBorder.withOpacity(0.6),
      width: 1,
    ),
  );

  static BoxDecoration glassWithColor(Color color, {double opacity = 0.1}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withOpacity(opacity),
          color.withOpacity(opacity * 0.5),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: color.withOpacity(0.3),
        width: 1,
      ),
    );
  }

  static BoxDecoration glassWithGlow(Color color) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withOpacity(0.15),
          color.withOpacity(0.05),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: color.withOpacity(0.4),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.2),
          blurRadius: 24,
          spreadRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration get liquid => BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x20FFFFFF),
        Color(0x10FFFFFF),
        Color(0x05FFFFFF),
      ],
    ),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: _glassBorder.withOpacity(0.4),
      width: 1,
    ),
  );

  static BoxDecoration get glassBottomNav => BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xF20A0A0A),
        Color(0xFF0A0A0A),
      ],
    ),
    border: Border(
      top: BorderSide(
        color: _glassBorder,
        width: 0.5,
      ),
    ),
  );

  static BoxDecoration get glassAppBar => BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        Color(0xE60A0A0A),
        Color(0xCC0A0A0A),
      ],
    ),
    border: Border(
      bottom: BorderSide(
        color: _glassBorder,
        width: 0.5,
      ),
    ),
  );
}