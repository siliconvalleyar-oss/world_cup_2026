class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.worldcup2026.app/v1';

  static const String matches = '/matches';
  static const String matchById = '/matches/{id}';
  static const String matchTimeline = '/matches/{id}/timeline';
  static const String matchEvents = '/matches/{id}/events';
  static const String matchStats = '/matches/{id}/stats';
  static const String matchLineups = '/matches/{id}/lineups';

  static const String teams = '/teams';
  static const String teamById = '/teams/{id}';
  static const String teamPlayers = '/teams/{id}/players';
  static const String teamMatches = '/teams/{id}/matches';
  static const String teamStats = '/teams/{id}/stats';

  static const String players = '/players';
  static const String playerById = '/players/{id}';
  static const String playerStats = '/players/{id}/stats';
  static const String playerMatches = '/players/{id}/matches';

  static const String groups = '/groups';
  static const String groupById = '/groups/{id}';
  static const String groupStandings = '/groups/{id}/standings';
  static const String groupMatches = '/groups/{id}/matches';

  static const String standings = '/standings';
  static const String standingsOverall = '/standings/overall';
  static const String standingsByGroup = '/standings/groups';

  static const String stats = '/stats';
  static const String statsTopScorers = '/stats/top-scorers';
  static const String statsTopAssists = '/stats/top-assists';
  static const String statsTopCards = '/stats/top-cards';
  static const String statsGeneral = '/stats/general';

  static const String events = '/events';
  static const String eventById = '/events/{id}';

  static const String stadiums = '/stadiums';
  static const String stadiumById = '/stadiums/{id}';

  static const String news = '/news';
  static const String newsById = '/news/{id}';

  static const String search = '/search';

  static const String notifications = '/notifications';
  static const String notificationPreferences = '/notifications/preferences';

  static const String user = '/user';
  static const String userProfile = '/user/profile';
  static const String userFavorites = '/user/favorites';
  static const String userPreferences = '/user/preferences';

  static String withId(String endpoint, String id) {
    return endpoint.replaceAll('{id}', id);
  }
}