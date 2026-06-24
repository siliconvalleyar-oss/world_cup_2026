# Data Layer — World Cup 2026

## Local Data Sources

### world_cup_local_data.dart

48 equipos hardcoded organizados en 12 grupos (A-L), 4 equipos por grupo.

**Estructura por equipo:**
```dart
{
  'id': '134497',        // TheSportsDB team ID
  'name': 'Mexico',
  'code': 'MEX',
  'group': 'A',
  'ranking': 14,         // FIFA ranking
  'confederation': 'CONCACAF',
  'flag': 'https://...', // Badge URL
  'coach': 'Javier Aguirre'
}
```

**15 estadios:**
```dart
{
  'id': '1',
  'name': 'Estadio Azteca',
  'city': 'Mexico City',
  'country': 'Mexico',
  'capacity': 87000,
  'latitude': 19.3030,
  'longitude': -99.1505
}
```

**Standings pre-cargados** (2 jornadas jugadas en datos hardcoded)

### world_cup_fixtures.dart

72 partidos de fase de grupos (6 por grupo × 12 grupos).

**Estructura:**
```dart
_MatchFixture(
  'GA01',              // fixture ID
  '134497',            // home team ID (Mexico)
  '136482',            // away team ID (South Africa)
  '2026-06-11T19:00:00', // date/time
  1,                   // matchday
  'A',                 // group
  2, 0,               // home/away score
  '1',                 // venue ID (Estadio Azteca)
  isScheduled: false   // finished = true
)
```

**Jornada 1**: Jun 11-17 (todos con resultado)
**Jornada 2**: Jun 18-23 (todos con resultado)
**Jornada 3**: Jun 24-27 (todos scheduled, sin resultado)

### world_cup_players_data.dart

75 jugadores de 15 equipos (5 por equipo):
- Argentina, Brazil, France, Germany, Spain, England
- Portugal, Netherlands, Italy (ERROR: no qualificado), Belgium
- USA, Mexico, Uruguay, Japan, South Korea

### world_cup_scorers.dart

15 goleadores con name, team, goals, position, nationality.

## Remote Data Source: TheSportsDB

### thesportsdb_service.dart

Servicio principal que combina datos API + locales.

**Métodos:**
| Method | API Call | Local Fallback | Returns |
|--------|----------|----------------|---------|
| `getMatches()` | eventsseason.php | world_cup_fixtures | List<MatchModel> |
| `getTeamsFromStandings()` | lookuptable.php | world_cup_local_data | List<TeamModel> |
| `getGroups()` | lookuptable.php | world_cup_local_data | List<GroupModel> |
| `getNews()` | eventspastleague.php | hardcoded news | List<NewsModel> |
| `getVenues()` | eventsseason.php | world_cup_local_data | List<VenueModel> |
| `getNextMatches()` | eventsnextleague.php | none | List<MatchModel> |

## Models (Freezed)

### TeamModel
```dart
@freezed
class TeamModel with _$TeamModel {
  const factory TeamModel({
    required String id,
    required String name,
    String? code,
    String? flag,
    String? confederation,
    int? fifaRanking,
    String? group,
    String? coach,
    @Default(0) int wins,
    @Default(0) int draws,
    @Default(0) int losses,
    @Default(0) int goalsFor,
    @Default(0) int goalsAgainst,
    @Default(0) int points,
  }) = _TeamModel;
}
```

### MatchModel
```dart
@freezed
class MatchModel with _$MatchModel {
  const factory MatchModel({
    required String id,
    required String homeTeamId,
    required String awayTeamId,
    TeamModel? homeTeam,
    TeamModel? awayTeam,
    @Default(0) int homeScore,
    @Default(0) int awayScore,
    @Default('scheduled') String status,
    int? matchday,
    String? group,
    VenueModel? venue,
    String? referee,
    required DateTime date,
    String? time,
    List<EventModel>? events,
    MatchStatistics? statistics,
    Lineups? lineups,
  }) = _MatchModel;
}
```

### GroupModel
```dart
@freezed
class GroupModel with _$GroupModel {
  const factory GroupModel({
    required String id,
    required String name,
    @Default([]) List<StandingModel> teams,
  }) = _GroupModel;
}
```

### StandingModel
```dart
@freezed
class StandingModel with _$StandingModel {
  const factory StandingModel({
    required String teamId,
    TeamModel? team,
    @Default(0) int played,
    @Default(0) int won,
    @Default(0) int drawn,
    @Default(0) int lost,
    @Default(0) int goalsFor,
    @Default(0) int goalsAgainst,
    @Default(0) int goalDifference,
    @Default(0) int points,
    @Default(0) int position,
  }) = _StandingModel;
}
```

## Repositories

### MatchRepositoryImpl
- Try: `_remoteDataSource.getMatches()` → cache → `Right(entities)`
- Catch: `_localDataSource.getCachedMatches()` → `Right(entities)` or `Left(failure)`

### TeamRepositoryImpl
- Same pattern: remote → cache → failure

Both use `Either<Failure, T>` from dartz for functional error handling.

## Data Flow Diagram

```
┌─────────────────────┐
│  TheSportsDB API    │
│  (eventsseason,     │
│   lookuptable, etc) │
└─────────┬───────────┘
          │ HTTP GET
          ▼
┌─────────────────────┐
│ TheSportsDBService  │
│                     │
│ 1. Call API         │
│ 2. Load local data  │
│ 3. Merge:          │
│    API overrides    │
│    local when avail │
└─────────┬───────────┘
          │ List<Model>
          ▼
┌─────────────────────┐
│ Riverpod Providers  │
│                     │
│ StateNotifier       │
│ AsyncValue<List<T>> │
└─────────┬───────────┘
          │ AsyncValue
          ▼
┌─────────────────────┐
│ UI Screens          │
│                     │
│ .when(              │
│   data: (list) =>  │
│   loading: =>      │
│   error: =>        │
│ )                  │
└─────────────────────┘
```
