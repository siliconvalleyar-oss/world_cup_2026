import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/presentation/providers/settings_provider.dart';
import 'package:world_cup_2026/presentation/widgets/glassmorphism_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? AppConstants.backgroundColor : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDark ? AppConstants.backgroundColor : const Color(0xFFF5F5F5),
        title: Text(
          settings.language == 'es' ? 'Configuración' : 'Settings',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0A0A0A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAppearanceSection(context, ref, settings, isDark),
          const SizedBox(height: 24),
          _buildLanguageSection(context, ref, settings, isDark),
          const SizedBox(height: 24),
          _buildNotificationsSection(context, ref, settings, isDark),
          const SizedBox(height: 24),
          _buildAboutSection(isDark),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context, WidgetRef ref, AppSettings settings, bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF0A0A0A);
    final subtitleColor = isDark ? AppConstants.secondaryTextColor : const Color(0xFF666666);
    final cardBg = isDark ? AppConstants.cardColor : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          settings.language == 'es' ? 'Apariencia' : 'Appearance',
          style: TextStyle(
            color: isDark ? AppConstants.primaryColor : AppConstants.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        GlassmorphismCard(
          backgroundColor: cardBg,
          child: Column(
            children: [
              _buildSwitchTile(
                icon: Icons.dark_mode,
                title: settings.language == 'es' ? 'Modo Oscuro' : 'Dark Mode',
                subtitle: settings.language == 'es' ? 'Usar tema oscuro' : 'Use dark theme',
                value: settings.themeMode == ThemeMode.dark,
                textColor: textColor,
                subtitleColor: subtitleColor,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).setThemeMode(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                },
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildLanguageSection(BuildContext context, WidgetRef ref, AppSettings settings, bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF0A0A0A);
    final subtitleColor = isDark ? AppConstants.secondaryTextColor : const Color(0xFF666666);
    final cardBg = isDark ? AppConstants.cardColor : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          settings.language == 'es' ? 'Idioma' : 'Language',
          style: TextStyle(
            color: isDark ? AppConstants.primaryColor : AppConstants.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        GlassmorphismCard(
          backgroundColor: cardBg,
          child: Column(
            children: [
              _buildRadioTile(
                icon: Icons.language,
                title: 'English',
                value: 'en',
                groupValue: settings.language,
                textColor: textColor,
                subtitleColor: subtitleColor,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).setLanguage(value!);
                },
              ),
              Divider(color: cardBg == Colors.white ? const Color(0xFFEEEEEE) : AppConstants.cardColor),
              _buildRadioTile(
                icon: Icons.language,
                title: 'Español',
                value: 'es',
                groupValue: settings.language,
                textColor: textColor,
                subtitleColor: subtitleColor,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).setLanguage(value!);
                },
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }

  Widget _buildRadioTile({
    required IconData icon,
    required String title,
    required String value,
    required String groupValue,
    required Color textColor,
    required Color subtitleColor,
    required ValueChanged<String?> onChanged,
  }) {
    return RadioListTile<String>(
      secondary: Icon(icon, color: AppConstants.primaryColor),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      value: value,
      groupValue: groupValue,
      activeColor: AppConstants.primaryColor,
      onChanged: onChanged,
    );
  }

  Widget _buildNotificationsSection(BuildContext context, WidgetRef ref, AppSettings settings, bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF0A0A0A);
    final subtitleColor = isDark ? AppConstants.secondaryTextColor : const Color(0xFF666666);
    final cardBg = isDark ? AppConstants.cardColor : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          settings.language == 'es' ? 'Notificaciones' : 'Notifications',
          style: TextStyle(
            color: isDark ? AppConstants.primaryColor : AppConstants.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        GlassmorphismCard(
          backgroundColor: cardBg,
          child: _buildSwitchTile(
            icon: Icons.notifications,
            title: settings.language == 'es' ? 'Notificaciones Push' : 'Push Notifications',
            subtitle: settings.language == 'es' ? 'Recibir actualizaciones de partidos' : 'Receive match updates',
            value: settings.notificationsEnabled,
            textColor: textColor,
            subtitleColor: subtitleColor,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).toggleNotifications();
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }

  Widget _buildAboutSection(bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF0A0A0A);
    final subtitleColor = isDark ? AppConstants.secondaryTextColor : const Color(0xFF666666);
    final cardBg = isDark ? AppConstants.cardColor : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'World Cup 2026',
          style: TextStyle(
            color: isDark ? AppConstants.primaryColor : AppConstants.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        GlassmorphismCard(
          backgroundColor: cardBg,
          child: ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppConstants.primaryColor, AppConstants.secondaryColor],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.sports_soccer, color: Colors.white, size: 28),
            ),
            title: Text(
              'World Cup 2026 Premium',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'v${AppConstants.appVersion}+${AppConstants.appBuildNumber}',
              style: TextStyle(color: subtitleColor),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 300.ms);
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Color textColor,
    required Color subtitleColor,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.primaryColor),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: Text(subtitle, style: TextStyle(color: subtitleColor, fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppConstants.primaryColor,
        activeTrackColor: AppConstants.primaryColor.withValues(alpha: 0.3),
      ),
    );
  }
}
