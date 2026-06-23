import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtensions on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String formatDate({
    String pattern = 'MMM d, yyyy',
    String? locale,
  }) {
    try {
      final date = DateTime.parse(this);
      return DateFormat(pattern, locale).format(date);
    } catch (e) {
      return this;
    }
  }

  String formatTime({
    String pattern = 'h:mm a',
    String? locale,
  }) {
    try {
      final date = DateTime.parse(this);
      return DateFormat(pattern, locale).format(date);
    } catch (e) {
      return this;
    }
  }

  bool get isValidEmail {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(this);
  }

  Color toColor() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
