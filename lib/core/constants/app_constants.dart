import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const Color primaryColor = Color(0xFF00C2FF);
  static const Color secondaryColor = Color(0xFF00FF9D);
  static const Color backgroundColor = Color(0xFF0A0A0A);
  static const Color cardColor = Color(0xFF161616);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color secondaryTextColor = Color(0xFFB0B0B0);

  static const String appName = 'World Cup 2026';
  static const String appTagline = 'Premium Football Experience';
  static const String appVersion = '1.0.3';
  static const String appBuildNumber = '6';

  static const String packageName = 'com.worldcup.premium';
  static const String bundleId = 'com.worldcup.premium';

  static const String defaultCountryCode = 'US';
  static const String defaultLanguage = 'en';

  static const String storageKeyTheme = 'theme_mode';
  static const String storageKeyLanguage = 'language_code';
  static const String storageKeyCountry = 'country_code';
  static const String storageKeyNotifications = 'notifications_enabled';
  static const String storageKeyOnboarding = 'onboarding_completed';

  static const int maxRecentMatches = 10;
  static const int maxFavoriteTeams = 5;
  static const int maxFavoritePlayers = 10;
  static const int matchesPerPage = 20;
  static const int teamsPerPage = 20;
  static const int playersPerPage = 20;

  static const String tournamentName = 'FIFA World Cup 2026';
  static const String tournamentEdition = '23rd Edition';
  static const String tournamentHost = 'United States, Canada, Mexico';
  static const String tournamentStartDate = '2026-06-11';
  static const String tournamentEndDate = '2026-07-19';
  static const int totalTeams = 48;
  static const int totalGroups = 12;
  static const int matchesPerGroup = 6;
  static const int totalMatchDays = 39;

  static const String assetPathLogos = 'assets/images/logos';
  static const String assetPathFlags = 'assets/images/flags';
  static const String assetPathIcons = 'assets/images/icons';
  static const String assetPathStadiums = 'assets/images/stadiums';
  static const String assetPathAnimations = 'assets/animations';

  static const String deepLinkPrefix = 'worldcup2026://';
  static const String androidAppLink = 'https://worldcup2026.app';
  static const String iosAppLink = 'https://worldcup2026.app';

  static const String privacyPolicyUrl = 'https://worldcup2026.app/privacy';
  static const String termsOfServiceUrl = 'https://worldcup2026.app/terms';
  static const String supportEmail = 'support@worldcup2026.app';
}
