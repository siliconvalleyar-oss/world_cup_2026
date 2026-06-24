# API Configuration — World Cup 2026

## Active API: TheSportsDB

### Base Configuration

```dart
// lib/core/config/api_config.dart
baseUrl: "https://www.thesportsdb.com/api/v1/json/3"
apiKey: "3"  // Free tier key
worldCupLeagueId: 4429
worldCupSeason: "2026"
```

### Endpoints Used

| Endpoint | Parameters | Returns | Used In |
|----------|-----------|---------|---------|
| `/eventsseason.php` | `id=4429, s=2026` | List of match events | `getMatches()`, `getVenues()` |
| `/lookuptable.php` | `l=4429, s=2026` | Standings table | `getTeamsFromStandings()`, `getGroups()` |
| `/eventsnextleague.php` | `id=4429` | Upcoming matches | `getNextMatches()` |
| `/eventspastleague.php` | `id=4429` | Past events | `getNews()` |

### API Response Format

**eventsseason.php** returns:
```json
{
  "events": [{
    "idEvent": "2391728",
    "strEvent": "Mexico vs South Africa",
    "strHomeTeam": "Mexico",
    "strAwayTeam": "South Africa",
    "idHomeTeam": "134497",
    "idAwayTeam": "136482",
    "intRound": "1",
    "intHomeScore": "2",
    "intAwayScore": "0",
    "strTimestamp": "2026-06-11T19:00:00",
    "strVenue": "Estadio Azteca",
    "strStatus": "FT",
    "strGroup": "Group A",
    "strHomeTeamBadge": "https://...",
    "strAwayTeamBadge": "https://..."
  }]
}
```

**lookuptable.php** returns:
```json
{
  "table": [{
    "idTeam": "134497",
    "strTeam": "Mexico",
    "strGroup": "Group A",
    "intRank": "1",
    "intPlayed": "2",
    "intWin": "2",
    "intDraw": "0",
    "intLoss": "0",
    "intGoalsFor": "3",
    "intGoalsAgainst": "0",
    "intPoints": "6",
    "strDescription": "Round of 32"
  }]
}
```

### Status Mapping

TheSportsDB → App:
| API Status | App Status |
|-----------|-----------|
| `FT` | `finished` |
| `NS` | `scheduled` |
| `1H`, `2H`, `HT`, `ET`, `P`, `LIVE` | `live` |
| `PST` | `postponed` |

### Data Merge Strategy

The `TheSportsDBService` merges API data with local hardcoded data:
1. Load all local data first (teams, fixtures, venues)
2. Call API endpoints
3. For matches: local fixtures are base, API data enriches scores/status
4. For teams: local 48 teams are base, API adds live standings
5. For groups: local groups are base, API standings override positions
6. For venues: local 15 venues are base, API adds images

## UNUSED API: api.worldcup2026.app

Defined in `lib/core/constants/api_endpoints.dart`:
```dart
static const String baseUrl = 'https://api.worldcup2026.app/v1';
```

This API **does not exist** (returns HTTP 000 / connection refused). The endpoints defined include:
- `/matches`, `/teams`, `/players`, `/groups`, `/standings`
- `/stadiums`, `/news`, `/stats`
- `/notifications`, `/user`

None of these are used anywhere in the codebase.

## Network Stack

```
DioClient (singleton)
├── AuthInterceptor    → Adds Bearer token header
├── CacheInterceptor   → Hive-based HTTP cache (5min default)
├── LoggingInterceptor → Request/response logging
└── RetryInterceptor   → Auto-retry on failure (3 attempts)
```

### Error Handling

DioException types mapped to AppException:
- `connectionTimeout/sendTimeout/receiveTimeout` → TimeoutException
- `connectionError` → NetworkException
- `badResponse` (5xx) → ServerException
- `badResponse` (4xx) → ApiException
- Default → AppException
