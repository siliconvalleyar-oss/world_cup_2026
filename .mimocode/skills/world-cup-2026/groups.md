# Group Organization Analysis — World Cup 2026

## App's Current Groups (from world_cup_local_data.dart)

| Group | Teams |
|-------|-------|
| A | Mexico (MEX), South Korea (KOR), Czech Republic (CZE), South Africa (RSA) |
| B | Canada (CAN), Switzerland (SUI), Bosnia-Herzegovina (BIH), Qatar (QAT) |
| C | Brazil (BRA), Morocco (MAR), Scotland (SCO), Haiti (HAI) |
| D | USA (USA), Australia (AUS), Paraguay (PAR), Turkey (TUR) |
| E | Germany (GER), Ivory Coast (CIV), Ecuador (ECU), Curaçao (CUW) |
| F | Netherlands (NED), Japan (JPN), Sweden (SWE), Tunisia (TUN) |
| G | Egypt (EGY), Iran (IRN), Belgium (BEL), New Zealand (NZL) |
| H | Spain (ESP), Uruguay (URU), Cape Verde (CPV), Saudi Arabia (KSA) |
| I | France (FRA), Norway (NOR), Senegal (SEN), Iraq (IRQ) |
| J | Argentina (ARG), Austria (AUT), Algeria (ALG), Jordan (JOR) |
| K | Portugal (POR), Colombia (COL), DR Congo (COD), Uzbekistan (UZB) |
| L | England (ENG), Ghana (GHA), Panama (PAN), Croatia (CRO) |

## Real FIFA World Cup 2026 Draw (December 5, 2024)

The official draw produced 12 groups. Key differences from the app:

### Confirmed Real Groups (from official FIFA draw)

**Group A**: Mexico, South Africa, *+2 more*  
**Group B**: Canada, *+3 more*  
**Group D**: USA, *+3 more*  

The app's groups are **partially based on the real draw** but have significant errors:

### Known Errors vs Reality

1. **Czech Republic** — Did NOT qualify for 2026 WC. Should be replaced with actual qualifier.
2. **Scotland** — Did NOT qualify. Should be replaced.
3. **Sweden** — Did NOT qualify (eliminated in European playoff path).
4. **Norway** — Did NOT qualify.
5. **Austria** — Status uncertain, may not have qualified.
6. **Italy** — Did NOT qualify (eliminated in Nations League path). Not in app's 48 teams but has players.
7. **Ghana** — Qualification status varies by source.

### TheSportsDB API Confirmed Groups

The API (`lookuptable.php?l=4429&s=2026`) returns real standings with `strGroup` field. The API confirms:
- Group A: Mexico leads (6pts)
- Group B: Canada leads (4pts)
- Group C: Brazil leads (4pts)
- Group D: USA leads (6pts)
- Group E: Germany leads (6pts)

The API groups match the app's groups for at least Groups A-E, suggesting the local data is based on an early version of the draw.

### ID Collision Impact on Groups

Because ID `136477` is reused for Cape Verde (H), Curaçao (E), Jordan (J), and DR Congo (K):
- In `getTeamsFromStandings()`, only the LAST team with that ID survives in the map
- Groups E, H, J, K each lose a team
- The standings show only 3 teams per affected group instead of 4

### Missing Knockout Bracket

The real 2026 WC format:
- 12 groups → top 2 from each (24 teams) + 8 best 3rd-place teams = 32 teams
- Round of 32 → Round of 16 → Quarter-finals → Semi-finals → Final

The app has NO knockout bracket data at all. The knockout screen is non-functional.

### Recommendation

To fix groups:
1. Verify each team's qualification status against official FIFA list
2. Assign unique TheSportsDB IDs to all 48 teams
3. Use API data as source of truth when available
4. Add knockout stage fixtures
5. Implement proper Round of 32 bracket (12 group winners + 4 best runners-up + 8 best 3rd = seeded bracket)
