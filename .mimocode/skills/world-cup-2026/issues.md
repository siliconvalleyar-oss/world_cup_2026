# Known Issues — World Cup 2026 App

## CRITICAL: Duplicate Team IDs

The hardcoded local data reuses the same ID for completely different teams:

| ID | Used for | Groups |
|----|----------|--------|
| `136477` | Cape Verde, Curaçao, Jordan, DR Congo | H, E, J, K |
| `136516` | Sweden, Norway | F, I |
| `136471` | Haiti, Paraguay | C, D |

**Impact**: Teams overwrite each other in maps. Only the last team with a given ID survives. The `_teamsData` list has 48 entries but many are lost due to ID collisions in `teamsMap`.

**Fix**: Assign unique IDs to every team. Use the actual TheSportsDB team IDs.

---

## CRITICAL: Knockout Stage Empty

`knockoutMatchesProvider` in `match_provider.dart:57-62`:
```dart
final knockoutMatchesProvider = Provider<AsyncValue<List<MatchModel>>>((ref) {
  final matchesAsync = ref.watch(matchListProvider);
  return matchesAsync.whenData(
    (matches) => matches.where((m) => m.group == null).toList(),
  );
});
```

**Problem**: ALL 72 matches in `world_cup_fixtures.dart` have a group assigned (A-L). No knockout fixtures exist. The knockout screen always shows "No knockout matches yet".

**Fix**: Add knockout fixtures (Round of 32, R16, QF, SF, F) with `group: null` or a dedicated `stage` field.

---

## CRITICAL: Player-Team ID Mismatches

Players in `world_cup_players_data.dart` reference wrong team IDs:

| Player Team | Player teamId | Actual Team ID in world_cup_local_data |
|-------------|---------------|----------------------------------------|
| France | `133909` | `133913` |
| Spain | `134504` | `133909` (France's ID!) |
| England | `134499` | `133914` |
| Portugal | `134502` | `133908` |
| Netherlands | `134505` | `133905` |
| Italy | `134511` | N/A (Italy NOT in tournament) |
| Japan | `134513` | `134503` (Ghana has `134513`) |
| South Korea | `134498` | `134517` |
| Uruguay | `134522` | `134504` (Spain's ID!) |

**Impact**: `playersByTeamProvider` returns wrong players for teams. Team detail screens show wrong player lists.

---

## HIGH: Italy Players Exist But Italy Not Qualified

`world_cup_players_data.dart` defines 5 Italy players (p041-p045) with teamId `134511`. But `world_cup_local_data.dart` has Belgium at `134515` — Italy is not in the 48 qualified teams. The ID `134511` is actually Iran's ID.

**Impact**: Italy players appear under Iran's team.

---

## HIGH: Duplicate Router Definitions

GoRouter is defined in BOTH:
- `lib/app/app.dart` (lines 29-182) — used by `WorldCupApp`
- `lib/presentation/router/app_router.dart` (lines 24-125) — UNUSED

The `app_router.dart` version is imported in some files but the app actually uses the one in `app.dart`. This causes confusion and potential inconsistencies.

---

## HIGH: API Silent Failures

Every catch block in `thesportsdb_service.dart` swallows errors:
```dart
} catch (_) {}  // Lines 37, 119, 210, 350
```

No logging, no error propagation. If the API is down, the app silently falls back to stale local data with no user feedback.

---

## MEDIUM: No standings sorting by goal difference then goals scored

`world_cup_local_data.dart:224-228` sorts by points then goal difference only. FIFA tiebreaker rules also include: goals scored, head-to-head, fair play points. Current sort may produce incorrect standings.

---

## MEDIUM: StandingsScreen hardcodes 12 tabs

`standings_screen.dart:28`: `_tabController = TabController(length: 12, vsync: this)` — always 12 tabs even if groups have different data or are incomplete.

---

## MEDIUM: Fixture dates may be wrong

Local fixture dates in `world_cup_fixtures.dart` are hardcoded and may not match the actual FIFA schedule. API data (when available) would be more accurate but is merged poorly — local dates always win due to `_mergeMatch` logic.

---

## LOW: Unused ApiEndpoints class

`core/constants/api_endpoints.dart` defines a complete REST API for `api.worldcup2026.app` that doesn't exist (returns HTTP 000). This file is never used but adds confusion.

---

## LOW: No error handling in providers

All providers catch errors and return `AsyncValue.data([])`:
```dart
} catch (e, st) {
  if (mounted) state = AsyncValue.data([]);
}
```

Users see empty screens with no indication of what went wrong.

---

## LOW: Assets directory structure

`pubspec.yaml` doesn't declare asset paths. The `assets/` directory exists with `fonts/`, `icons/`, `images/` but no JSON data files. All data is hardcoded in Dart files.
