import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppSettings {
  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final String language;

  const AppSettings({
    this.themeMode = ThemeMode.dark,
    this.notificationsEnabled = true,
    this.language = 'en',
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    String? language,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _loadFromHive();
  }

  static const String _boxName = 'settings';
  static const String _themeKey = 'theme_mode';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _languageKey = 'language';

  Future<void> _loadFromHive() async {
    try {
      final box = await Hive.openBox(_boxName);
      final themeIndex = box.get(_themeKey, defaultValue: 2) as int;
      final notifications = box.get(_notificationsKey, defaultValue: true) as bool;
      final language = box.get(_languageKey, defaultValue: 'en') as String;

      state = AppSettings(
        themeMode: ThemeMode.values[themeIndex],
        notificationsEnabled: notifications,
        language: language,
      );
    } catch (_) {}
  }

  Future<void> _saveToHive() async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.put(_themeKey, state.themeMode.index);
      await box.put(_notificationsKey, state.notificationsEnabled);
      await box.put(_languageKey, state.language);
    } catch (_) {}
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _saveToHive();
  }

  Future<void> toggleNotifications() async {
    state = state.copyWith(notificationsEnabled: !state.notificationsEnabled);
    await _saveToHive();
  }

  Future<void> setLanguage(String lang) async {
    state = state.copyWith(language: lang);
    await _saveToHive();
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});
