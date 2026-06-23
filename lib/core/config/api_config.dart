class ApiConfig {
  ApiConfig._();

  static const String baseUrl = "https://www.thesportsdb.com/api/v1/json/3";
  static const String apiKey = "3";

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  static const int worldCupLeagueId = 4429;
  static const String worldCupSeason = "2026";
}
