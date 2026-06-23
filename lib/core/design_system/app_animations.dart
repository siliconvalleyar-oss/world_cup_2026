import 'package:flutter/material.dart';

class AppAnimations {
  AppAnimations._();

  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 700);

  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration bottomSheet = Duration(milliseconds: 400);
  static const Duration splash = Duration(milliseconds: 1500);

  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;
  static const Curve linear = Curves.linear;

  static const Curve slideInFromBottom = Curves.easeOutCubic;
  static const Curve slideOutToBottom = Curves.easeInCubic;
  static const Curve fadeIn = Curves.easeIn;
  static const Curve fadeOut = Curves.easeOut;

  static const double scaleDown = 0.95;
  static const double scaleUp = 1.05;
  static const double scaleNormal = 1.0;

  static const double opacityHidden = 0.0;
  static const double opacityHalf = 0.5;
  static const double opacityFull = 1.0;

  static const int staggerDelayMs = 50;
}