# Issues — World Cup 2026

## CRITICAL

### 1. Duplicate Team IDs
**File**: `lib/data/datasources/local/world_cup_local_data.dart`

ID `136477` is reused for 4 different teams:
- Cape Verde (Group H, line 55)
- Curaçao (Group E, line 38)
- Jordan (Group J, line 68)
- DR Congo (Group K, line 73)

ID `136516` reused for:
- Sweden (Group F, line 43)
- Norway (Group I, line 60)

ID `136471` reused for:
- Haiti (Group C, line 26)
- Paraguay (Group D, line 31)

**Impact**: In `getTeamsFromStandings()` and `getGroups()`, teams are stored in a Map by ID. Duplicate IDs cause teams to overwrite each other. Groups E, H, J, K lose a team each.

**Fix**: Assign unique IDs to all 48 teams.

---

### 2. Knockout Stage Completely Empty
**File**: `lib/presentation/providers/match_provider.dart:57-62`

```dart
final knockoutMatchesProvider = Provider<AsyncValue<List<MatchModel>>>((ref) {
  final matchesAsync = ref.watch(matchListProvider);
  return matchesAsync.whenData(
    (matches) => matches.where((m) => m.group == null).toList(),
  );
});
```

ALL 72 fixtures in `world_cup_fixtures.dart` have a `group` value (A-L). No knockout fixtures exist. Screen always shows "No knockout matches yet".

**Fix**: Add knockout fixtures with `group: null` or implement a `stage` field.

---

### 3. Player-Team ID Mismatches
**File**: `lib/data/datasources/local/world_cup_players_data.dart`

| Player Team | player.teamId | Actual team ID |
|-------------|---------------|----------------|
| France | `133909` | `133913` |
| Spain | `134504` | `133909` (France!) |
| England | `134499` | `133914` |
| Portugal | `134502` | `133908` |
| Netherlands | `134505` | `133905` |
| Italy | `134511` | N/A (not qualified) |
| Japan | `134513` | `134503` |
| South Korea | `134498` | `134517` |
| Uruguay | `134522` | `134504` (Spain!) |

**Impact**: `playersByTeamProvider` returns wrong players. Team detail screens show incorrect player lists.

---

### 4. Italy Players But Italy Not Qualified
**File**: `lib/data/datasources/local/world_cup_players_data.dart:63-68`

Italy has 5 players (p041-p045) with teamId `134511`. But `134511` is Iran's ID in the local data. Italy did not qualify for the 2026 World Cup.

---

## HIGH

### 5. Duplicate GoRouter Definitions
**Files**: `lib/app/app.dart:29-182` AND `lib/presentation/router/app_router.dart:24-125`

Two complete GoRouter definitions exist. The app uses the one in `app.dart`. `app_router.dart` is imported but unused, causing confusion.

---

### 6. API Silent Failures
**File**: `lib/data/datasources/remote/thesportsdb_service.dart`

Lines 37, 119, 210, 350: `catch (_) {}` — all API errors silently swallowed. No logging, no user feedback. App falls back to stale local data.

---

### 7. Incorrect FIFA Tiebreakers
**File**: `lib/data/datasources/local/world_cup_local_data.dart:224-228`

Sorting uses only points → goal difference. FIFA rules also require: goals scored, head-to-head record, fair play points, drawing of lots.

---

## MEDIUM

### 8. StandingsScreen Hardcodes 12 Tabs
**File**: `lib/presentation/screens/standings/standings_screen.dart:28`

Always creates 12 tabs regardless of actual group count or data availability.

---

### 9. Fixture Dates May Be Wrong
**File**: `lib/data/datasources/local/world_cup_fixtures.dart`

Hardcoded dates may not match actual FIFA schedule. API data is available but `_mergeMatch()` always prefers local dates.

---

### 10. No Error Feedback to Users
All providers catch errors and return `AsyncValue.data([])`. Users see empty screens with no error message.

---

## LOW

### 11. Unused ApiEndpoints Class
**File**: `lib/core/constants/api_endpoints.dart`

Defines REST API for `api.worldcup2026.app` which doesn't exist (HTTP 000). Never used.

### 12. No Asset Declarations in pubspec.yaml
Assets directory exists but pubspec.yaml doesn't declare `assets:` section.

### 13. Scorer Data Inconsistent
`world_cup_scorers.dart` has different goal counts than `world_cup_players_data.dart` for same players (e.g., Messi: 5 goals in scorers vs 2 in players).
