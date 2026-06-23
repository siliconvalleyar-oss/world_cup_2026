class HiveConstants {
  HiveConstants._();

  static const String matchesBox = 'matches';
  static const String teamsBox = 'teams';
  static const String playersBox = 'players';
  static const String groupsBox = 'groups';
  static const String standingsBox = 'standings';
  static const String statsBox = 'stats';
  static const String eventsBox = 'events';
  static const String favoritesBox = 'favorites';
  static const String settingsBox = 'settings';
  static const String cacheBox = 'cache';
  static const String userBox = 'user';
  static const String notificationsBox = 'notifications';

  static const int matchTypeId = 0;
  static const int teamTypeId = 1;
  static const int playerTypeId = 2;
  static const int groupTypeId = 3;
  static const int standingTypeId = 4;
  static const int statTypeId = 5;
  static const int eventTypeId = 6;
  static const int favoriteTypeId = 7;
  static const int settingsTypeId = 8;
  static const int cacheTypeId = 9;
  static const int userTypeId = 10;
  static const int notificationTypeId = 11;

  static const String settingsThemeKey = 'theme_mode';
  static const String settingsLanguageKey = 'language_code';
  static const String settingsCountryKey = 'country_code';
  static const String settingsNotificationsKey = 'notifications_enabled';
  static const String settingsOnboardingKey = 'onboarding_completed';
  static const String settingsLastSyncKey = 'last_sync_timestamp';

  static const String cacheTimestampKey = 'timestamp';
  static const String cacheDataKey = 'data';
  static const Duration cacheDuration = Duration(hours: 1);
}