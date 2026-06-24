---
name: world-cup-2026
description: Use when working on the World Cup 2026 Flutter app — fixing bugs, adding features, debugging API issues, understanding data flow, or modifying knockout/groups/teams/matches/screens
---

# World Cup 2026 — Flutter App Knowledge Base

## Project Overview

Flutter app for FIFA World Cup 2026. Uses Riverpod + GoRouter + Dio + Hive + Freezed. Architecture: clean architecture with data/domain/presentation layers.

- **SDK**: Dart ^3.12.0, Flutter 3.44.1 stable
- **State Management**: flutter_riverpod
- **Routing**: go_router
- **HTTP**: dio
- **Local Storage**: hive + hive_flutter
- **Code Gen**: freezed + json_serializable

## Build & Deploy Rules (CRITICAL)

### Mandatory in every build

1. **Increment version** in `pubspec.yaml` (+1 to build number): `1.0.3+4` → `1.0.3+5`
2. **Sync** `lib/core/constants/app_constants.dart` with pubspec
3. **Create git tag**: `git tag v1.0.3+5`
4. **Copy APK** to `APK/world_cup_2026_v1.0.3+5.apk`
5. **Install with retry**: If `adb install -r` fails, retry **5 times with 1 min wait**:
   ```bash
   for i in 1 2 3 4 5; do
     adb install -r build/app/outputs/flutter-apk/app-release.apk && break
     sleep 60
   done
   ```
6. **NEVER uninstall first** — use `-r` flag to replace. Uninstall loses Hive data.

### Pre-build checklist

- [ ] `pubspec.yaml` version incremented
- [ ] `app_constants.dart` synced
- [ ] `dart run build_runner build --delete-conflicting-outputs` run
- [ ] `flutter analyze` — 0 errors
- [ ] APK built, copied, installed with retry
- [ ] Git commit + tag + push

## Directory Structure

```
lib/
├── main.dart                          # Entry: Hive init + ProviderScope
├── app/app.dart                       # MaterialApp.router + GoRouter + ScaffoldWithNavBar
├── core/
│   ├── config/api_config.dart         # TheSportsDB base URL + league ID 4429
│   ├── constants/
│   │   ├── app_constants.dart         # Colors, version, tournament info
│   │   └── hive_constants.dart
│   ├── network/
│   │   ├── dio_client.dart            # Singleton Dio with interceptors
│   │   └── interceptors/              # auth, cache, logging, retry
│   ├── localization/app_localizations.dart  # EN/ES via L10n
│   ├── design_system/                 # colors, typography, glass, shadows
│   ├── theme/app_theme.dart
│   └── widgets/
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── world_cup_local_data.dart    # 48 teams + standings + venues
│   │   │   └── world_cup_fixtures.dart      # 72 group + 16 knockout matches
│   │   └── remote/
│   │       └── thesportsdb_service.dart     # MAIN API (TheSportsDB)
│   ├── models/                        # freezed models
│   └── repositories/
├── domain/
│   ├── entities/
│   └── repositories/
└── presentation/
    ├── providers/                     # Riverpod providers
    │   ├── api_provider.dart
    │   ├── match_provider.dart        # matchListProvider, knockoutMatchesProvider
    │   ├── team_provider.dart
    │   ├── standing_provider.dart
    │   ├── player_provider.dart
    │   ├── news_provider.dart
    │   ├── stadium_provider.dart
    │   ├── settings_provider.dart
    │   └── favorites_provider.dart
    ├── screens/
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
    ├── router/app_router.dart
    └── widgets/                       # MatchCard, EmptyState, ShimmerLoading, etc.
```

## API Configuration

### Active API: TheSportsDB (FREE)
- **Base URL**: `https://www.thesportsdb.com/api/v1/json/3`
- **League ID**: `4429` (FIFA World Cup)
- **Season**: `2026`
- **Endpoints**:
  - `/eventsseason.php?id=4429&s=2026` — matches
  - `/lookuptable.php?l=4429&s=2026` — standings
  - `/eventsnextleague.php?id=4429` — next matches
  - `/eventspastleague.php?id=4429` — past events (news)

## Data Flow

```
TheSportsDB API → TheSportsDBService → merges with local data → Providers → Screens
                         │
                         ├── getMatches()        → local fixtures + API events
                         ├── getTeamsFromStandings() → local 48 teams + API table
                         ├── getGroups()         → local groups + API standings
                         ├── getNews()           → API past events OR local fallback
                         └── getVenues()         → local 15 venues + API events
```

## Runtime Errors — FIXED

### 1. ref.refresh() in error callbacks (CRITICAL)
**Problem**: Calling `ref.refresh()` inside `.error` callbacks during widget build causes `_elements.contains(element)` assertion crash.
**Fix**: Replace `AppErrorWidget(onRetry: () => ref.refresh(provider))` with static `EmptyState` widget.
**Files fixed**: 12 screens (teams, fixture, standings, players, knockout, match_detail, team_detail, player_detail, stadiums, news, stadium_detail, news_detail)

### 2. SliverList with error widgets
**Problem**: Non-sliver widgets inside `SliverList` cause `RenderViewport expected RenderSliver` cascade.
**Fix**: Use `SliverToBoxAdapter` instead of `SliverList(delegate: SliverChildListDelegate(...))`.

### 3. BorderRadius.symmetric removed in Flutter 3.44
**Fix**: Use `BorderRadius.all(Radius.circular(...))` instead.

### 4. ConnectivityResult API changed
**Fix**: `connectivity_plus` now returns `List<ConnectivityResult>`. Use `.any((r) => r != ConnectivityResult.none)`.

### 5. Import path api_config.dart
**Fix**: File is at `core/config/api_config.dart`, not `core/network/`.

### 6. Hive requires hive_flutter
**Fix**: Import `hive_flutter` for `initFlutter()`, not just `hive`.

## Known Issues — NOT YET FIXED

### CRITICAL: Duplicate Team IDs
ID `136477` reused for Cape Verde, Curaçao, Jordan, DR Congo. Only last survives in maps.

### CRITICAL: Player-Team ID Mismatches
Players reference wrong team IDs (France `133909` vs actual `133913`, etc.)

### HIGH: Italy Players Without Italy Team
5 Italy players exist but Italy didn't qualify. ID `134511` is actually Iran.

### MEDIUM: No Standings Tiebreaker
Sort by points + GD only. Missing: goals scored, head-to-head, fair play.

## Key Files to Modify

| Task | Files |
|------|-------|
| Fix knockout stage | `match_provider.dart`, `knockout_screen.dart`, `world_cup_fixtures.dart` |
| Fix team data | `world_cup_local_data.dart` |
| Fix API issues | `thesportsdb_service.dart`, `api_config.dart` |
| Add new screens | `presentation/screens/`, `app_router.dart` |
| Modify providers | `presentation/providers/` |
| Change models | `data/models/` (freezed — run build_runner after) |

## Git & Device

- **Remote**: `https://github.com/siliconvalleyar-oss/world_cup_2026.git`
- **ADB Device**: Check with `adb devices` before install
- **Package**: `com.worldcup2026.world_cup_2026`
- **Language**: Always respond in Spanish
