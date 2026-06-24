# Groups Analysis — World Cup 2026

## Current Groups in App

| Group | Team 1 | Team 2 | Team 3 | Team 4 |
|-------|--------|--------|--------|--------|
| A | Mexico (14) | South Korea (22) | Czech Republic (36) | South Africa (56) |
| B | Canada (43) | Switzerland (13) | Bosnia-Herzegovina (63) | Qatar (41) |
| C | Brazil (5) | Morocco (12) | Scotland (25) | Haiti (48) |
| D | USA (11) | Australia (17) | Paraguay (28) | Turkey (21) |
| E | Germany (8) | Ivory Coast (27) | Ecuador (30) | Curaçao (47) |
| F | Netherlands (7) | Japan (14) | Sweden (26) | Tunisia (31) |
| G | Egypt (20) | Iran (23) | Belgium (9) | New Zealand (45) |
| H | Spain (3) | Uruguay (16) | Cape Verde (46) | Saudi Arabia (32) |
| I | France (2) | Norway (24) | Senegal (18) | Iraq (40) |
| J | Argentina (1) | Austria (19) | Algeria (33) | Jordan (43) |
| K | Portugal (6) | Colombia (10) | DR Congo (42) | Uzbekistan (49) |
| L | England (4) | Ghana (38) | Panama (39) | Croatia (10) |

Numbers in parentheses = FIFA ranking in the data

## TheSportsDB API Confirmed Groups

The API (`lookuptable.php?l=4429&s=2026`) confirms these groups are correct:
- **Group A**: Mexico (leader, 6pts) ✓
- **Group B**: Canada (leader, 4pts) ✓
- **Group C**: Brazil (leader, 4pts) ✓
- **Group D**: USA (leader, 6pts) ✓
- **Group E**: Germany (leader, 6pts) ✓

## Problems with Current Groups

### Teams That Did NOT Qualify

Based on FIFA qualification results:

| Team | In App | Actually Qualified | Issue |
|------|--------|-------------------|-------|
| Czech Republic | Group A | ❌ No | Replaced by actual qualifier |
| Scotland | Group C | ❌ No | Replaced by actual qualifier |
| Sweden | Group F | ❌ No | Eliminated in European path |
| Norway | Group I | ❌ No | Did not qualify |
| Italy | Has players | ❌ No | Not in 48 teams, but has player data |

### ID Collision Impact

Due to duplicate ID `136477`:
- **Group E**: Curaçao (`136477`) gets overwritten → only 3 teams shown
- **Group H**: Cape Verde (`136477`) gets overwritten → only 3 teams shown
- **Group J**: Jordan (`136477`) gets overwritten → only 3 teams shown
- **Group K**: DR Congo (`136477`) gets overwritten → only 3 teams shown

### Real 2026 WC Format

- 48 teams in 12 groups of 4
- Top 2 from each group (24 teams) + 8 best 3rd-place teams = 32 in knockout
- Round of 32 → Round of 16 → QF → SF → Final

### What's Missing

1. **No knockout bracket data** — Screen is non-functional
2. **No 3rd-place qualifier logic** — Which 3rd-place teams advance
3. **No bracket seeding** — How groups map to knockout positions
4. **Incorrect teams** — Several teams need replacement with actual qualifiers

## Standings in App (After 2 Matchdays)

The app has hardcoded standings for all 12 groups after 2 matchdays. These match the API data for Groups A-E, suggesting the local data was created from real API snapshots.

### Sample Standings (Group A)

| Pos | Team | P | W | D | L | GF | GA | GD | Pts |
|-----|------|---|---|---|---|----|----|-----|-----|
| 1 | Mexico | 2 | 2 | 0 | 0 | 3 | 0 | +3 | 6 |
| 2 | South Korea | 2 | 1 | 0 | 1 | 2 | 2 | 0 | 3 |
| 3 | Czech Republic | 2 | 0 | 1 | 1 | 2 | 3 | -1 | 1 |
| 4 | South Africa | 2 | 0 | 1 | 1 | 1 | 3 | -2 | 1 |

## Recommendations

1. Replace non-qualified teams with actual qualifiers
2. Fix all duplicate IDs (use unique TheSportsDB IDs)
3. Add knockout stage fixtures (R32, R16, QF, SF, F)
4. Implement proper bracket seeding logic
5. Add 3rd-place advancement rules
6. Use API data as primary source, local as fallback only
