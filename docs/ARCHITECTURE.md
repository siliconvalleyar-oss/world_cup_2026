# Architecture — World Cup 2026

## Clean Architecture

La app sigue clean architecture con 3 capas:

```
presentation/ → domain/ ← data/
     ↓              ↑         ↓
  providers     entities   datasources
  screens     repositories  models
  widgets      usecases    repositories (impl)
```

### Data Layer (`lib/data/`)

**Datasources:**
- `local/world_cup_local_data.dart` — 48 equipos, 15 estadios, standings hardcoded
- `local/world_cup_fixtures.dart` — 72 partidos de fase de grupos hardcoded
- `local/world_cup_players_data.dart` — 75 jugadores hardcoded
- `local/world_cup_scorers.dart` — 15 goleadores hardcoded
- `remote/thesportsdb_service.dart` — Servicio principal que combina API + datos locales
- `remote/*_remote_datasource.dart` — Datasources abstractos (no usados activamente)

**Models (Freezed):**
- `TeamModel` — id, name, code, flag, group, fifaRanking, confederation, coach, stats
- `MatchModel` — id, home/away team, scores, status, group, venue, date, events
- `GroupModel` — id, name, teams (List<StandingModel>)
- `StandingModel` — teamId, team, played, won, drawn, lost, GF, GA, GD, points, position
- `VenueModel` — id, name, city, country, capacity, lat/lng, image
- `NewsModel` — id, title, summary, content, imageUrl, source, publishedAt
- `PlayerModel` — id, name, position, number, age, nationality, teamId, goals, assists

**Repositories (Impl):**
- `MatchRepositoryImpl` — Try API → fallback to cache
- `TeamRepositoryImpl` — Try API → fallback to cache
- `StandingRepositoryImpl`, `PlayerRepositoryImpl`, `NewsRepositoryImpl`

### Domain Layer (`lib/domain/`)

- `entities/` — Plain Dart classes (TeamEntity, MatchEntity, PlayerEntity)
- `repositories/` — Abstract interfaces (MatchRepository, TeamRepository, etc.)
- `usecases/` — Empty (not implemented)

### Presentation Layer (`lib/presentation/`)

**Providers (Riverpod):**
- `api_provider.dart` — `theSportsDBServiceProvider` (singleton TheSportsDBService)
- `match_provider.dart` — `matchListProvider`, `knockoutMatchesProvider`, `liveMatchesProvider`
- `team_provider.dart` — `teamListProvider`, `teamDetailProvider`
- `standing_provider.dart` — `groupListProvider`, `standingsProvider`
- `player_provider.dart` — `playerListProvider` (LOCAL ONLY, no API)
- `news_provider.dart` — `newsListProvider`
- `stadium_provider.dart` — `stadiumListProvider`

**Screens:**
- Splash → Home → Fixture → Standings → Teams → Players → Knockout → Stadiums → News → Settings

**Router:**
- GoRouter with ShellRoute for bottom navigation (Home, Fixture, Standings, Favorites, Settings)
- Named routes for detail screens

### Core (`lib/core/`)

- `config/api_config.dart` — API base URL, league ID, timeouts
- `constants/` — App-wide constants
- `network/dio_client.dart` — Singleton Dio with interceptors
- `network/interceptors/` — Auth, cache, logging, retry
- `services/` — Connectivity, Hive, notifications
- `localization/app_localizations.dart` — EN/ES translations
- `errors/` — Failure types (Server, Network, Timeout, Cache)
- `design_system/` — Colors, typography, spacing, glass effects
- `theme/app_theme.dart` — Dark theme

## Data Flow

```
1. App starts → SplashScreen (2.5s delay) → HomeScreen
2. HomeScreen providers auto-load:
   - matchListProvider → TheSportsDBService.getMatches()
   - teamListProvider → TheSportsDBService.getTeamsFromStandings()
   - newsListProvider → TheSportsDBService.getNews()
3. TheSportsDBService:
   a. Calls TheSportsDB API (eventsseason.php, lookuptable.php)
   b. Loads local hardcoded data
   c. Merges API + local (API overrides when available)
   d. Returns merged list
4. Providers expose AsyncValue<List<T>> to screens
5. Screens use .when(data:, loading:, error:) to render
```

## State Management

- **StateNotifierProvider** for list state (matchList, teamList, groupList)
- **FutureProvider.family** for detail lookups (matchDetail, teamDetail, groupStandings)
- **Provider** for derived state (liveMatches, knockoutMatches, filtered lists)
- **StateProvider** for search/filter state
