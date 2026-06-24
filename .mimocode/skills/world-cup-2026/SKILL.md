---
name: world-cup-2026
description: Use when working on the World Cup 2026 Flutter app — fixing bugs, adding features, debugging API issues, understanding data flow, or modifying knockout/groups/teams/matches/screens
---

# World Cup 2026 — Flutter App Knowledge Base

## Project Overview

Flutter app (v1.0.3+4) for FIFA World Cup 2026. Uses Riverpod + GoRouter + Dio + Hive + Freezed. Architecture: clean architecture with data/domain/presentation layers.

- **SDK**: Dart ^3.12.0
- **State Management**: flutter_riverpod ^2.6.1
- **Routing**: go_router ^14.8.1
- **HTTP**: dio ^5.7.0
- **Local Storage**: hive ^2.2.3
- **Code Gen**: freezed + json_serializable

## Directory Structure

```
lib/
├── main.dart                          # Entry: Hive init + ProviderScope
├── app/app.dart                       # MaterialApp.router + GoRouter + ScaffoldWithNavBar
├── core/
│   ├── config/api_config.dart         # TheSportsDB base URL + league ID 4429
│   ├── constants/
│   │   ├── api_endpoints.dart         # UNUSED fake API (api.worldcup2026.app)
│   │   ├── app_constants.dart         # Colors, tournament info, asset paths
│   │   └── hive_constants.dart
│   ├── network/
│   │   ├── dio_client.dart            # Singleton Dio with interceptors
│   │   ├── api_response.dart
│   │   └── interceptors/              # auth, cache, logging, retry
│   ├── services/                      # connectivity, hive, notification
│   ├── localization/app_localizations.dart  # EN/ES via L10n
│   ├── errors/                        # Failure + AppException
│   ├── extensions/                    # context, string
│   ├── design_system/                 # colors, typography, spacing, glass, shadows, animations
│   ├── theme/app_theme.dart
│   └── widgets/
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── world_cup_local_data.dart    # 48 teams hardcoded + standings + venues
│   │   │   ├── world_cup_fixtures.dart      # 72 group stage matches hardcoded
│   │   │   ├── world_cup_players_data.dart  # 75 players hardcoded (15 teams)
│   │   │   ├── world_cup_scorers.dart       # 15 top scorers hardcoded
│   │   │   ├── team_local_datasource.dart
│   │   │   ├── match_local_datasource.dart
│   │   │   ├── standing_local_datasource.dart
│   │   │   └── news_local_datasource.dart
│   │   └── remote/
│   │       ├── thesportsdb_service.dart     # MAIN API SERVICE (TheSportsDB)
│   │       ├── team_remote_datasource.dart
│   │       ├── match_remote_datasource.dart
│   │       ├── standing_remote_datasource.dart
│   │       ├── player_remote_datasource.dart
│   │       └── news_remote_datasource.dart
│   ├── models/                        # freezed models: Team, Match, Group, Standing, Venue, News, Player, Event, etc.
│   └── repositories/                  # Impl classes with Either<Failure, T> pattern
├── domain/
│   ├── entities/                      # TeamEntity, MatchEntity, PlayerEntity
│   ├── repositories/                  # Abstract interfaces
│   └── usecases/
├── features/                          # Empty dirs (features not implemented as separate modules)
│   ├── favorites/, fixture/, home/, knockout/, matches/, news/,
│   │   notifications/, players/, settings/, stadiums/, standings/, teams/
└── presentation/
    ├── providers/                     # Riverpod providers
    │   ├── api_provider.dart          # theSportsDBServiceProvider
    │   ├── match_provider.dart        # matchListProvider, knockoutMatchesProvider
    │   ├── team_provider.dart         # teamListProvider
    │   ├── standing_provider.dart     # groupListProvider, standingsProvider
    │   ├── player_provider.dart       # playerListProvider (LOCAL ONLY)
    │   ├── news_provider.dart         # newsListProvider
    │   ├── stadium_provider.dart      # stadiumListProvider
    │   ├── settings_provider.dart
    │   ├── favorites_provider.dart
    │   └── connectivity_provider.dart
    ├── screens/                       # All UI screens
    │   ├── splash/splash_screen.dart
    │   ├── home/home_screen.dart
    │   ├── fixture/fixture_screen.dart
    │   ├── standings/standings_screen.dart
    │   ├── teams/teams_screen.dart + team_detail_screen.dart
    │   ├── players/players_screen.dart + player_detail_screen.dart
    │   ├── matches/match_detail_screen.dart
    │   ├── knockout/knockout_screen.dart
    │   ├── stadiums/stadiums_screen.dart + stadium_detail_screen.dart
    │   ├── news/news_screen.dart + news_detail_screen.dart
    │   ├── favorites/favorites_screen.dart
    │   └── settings/settings_screen.dart
    ├── router/app_router.dart         # GoRouter (DUPLICATE with app.dart)
    └── widgets/                       # Reusable widgets
```

## API Configuration

### Active API: TheSportsDB (FREE)
- **Base URL**: `https://www.thesportsdb.com/api/v1/json/3`
- **League ID**: `4429` (FIFA World Cup)
- **Season**: `2026`
- **Endpoints used**:
  - `/eventsseason.php?id=4429&s=2026` — matches
  - `/lookuptable.php?l=4429&s=2026` — standings
  - `/eventsnextleague.php?id=4429` — next matches
  - `/eventspastleague.php?id=4429` — past events (news)

### UNUSED API: api.worldcup2026.app
- Defined in `api_endpoints.dart` but NEVER used anywhere
- Returns HTTP 000 (connection refused) — API does not exist

## Data Flow

```
TheSportsDB API ──→ TheSportsDBService ──→ merges with local data ──→ Providers ──→ Screens
                         │
                         ├── getMatches()        → local fixtures + API events
                         ├── getTeamsFromStandings() → local 48 teams + API table
                         ├── getGroups()         → local groups + API standings
                         ├── getNews()           → API past events OR local fallback
                         └── getVenues()         → local 15 venues + API events
```

## Critical Issues Found

See @issues.md for the full bug list. Summary:

1. **Duplicate team IDs** — ID `136477` reused for 4 different teams (Cape Verde, Curaçao, Jordan, DR Congo)
2. **No knockout data** — knockoutMatchesProvider filters `group == null` but all matches have groups → always empty
3. **Player-team ID mismatches** — Players reference wrong team IDs (France `133909` vs actual `133913`, etc.)
4. **Italy not in tournament** — Players exist for Italy but Italy didn't qualify; Belgium is the team
5. **Duplicate router definitions** — GoRouter defined in both `app.dart` and `app_router.dart`
6. **API silent failures** — All catch blocks swallow errors with empty lists

See @groups.md for the group organization analysis against the real FIFA draw.

## Key Files to Modify

| Task | Files |
|------|-------|
| Fix knockout stage | `match_provider.dart`, `knockout_screen.dart`, `world_cup_fixtures.dart` |
| Fix team data | `world_cup_local_data.dart`, `world_cup_players_data.dart` |
| Fix API issues | `thesportsdb_service.dart`, `api_config.dart` |
| Add new screens | `presentation/screens/`, `app_router.dart`, `app.dart` |
| Modify providers | `presentation/providers/` |
| Change data models | `data/models/` (freezed — run build_runner after) |

## Build Commands

```bash
# Generate freezed code
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Build APK
flutter build apk --release
```

## Localization

English (EN) and Spanish (ES) via `L10n` class in `core/localization/app_localizations.dart`. Language toggled via settings provider.
