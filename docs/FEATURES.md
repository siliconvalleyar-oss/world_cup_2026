# Features — World Cup 2026

## Home Screen
**File**: `lib/presentation/screens/home/home_screen.dart`

Pantalla principal con 5 secciones:
1. **Live Matches** — Horizontal scroll de partidos en vivo (API)
2. **Upcoming Matches** — Próximos 5 partidos programados
3. **Recent Results** — Últimos 5 partidos finalizados
4. **Featured News** — Horizontal scroll de noticias (API)
5. **Featured Teams** — Horizontal scroll de 12 equipos destacados

Soporta pull-to-refresh que recarga matches, news y teams.

## Fixture Screen
**File**: `lib/presentation/screens/fixture/fixture_screen.dart`

Dos vistas:
- **By Date** — Partidos agrupados por día, con indicador "HOY"
- **By Group** — Partidos agrupados por grupo (ExpansionTile)

Incluye barra de búsqueda y filtros por grupo/fecha.

## Standings Screen
**File**: `lib/presentation/screens/standings/standings_screen.dart`

12 tabs (A-L) con tabla de posiciones por grupo:
- Posición, Equipo, PJ, PG, PE, PP, GF, GC, DG, Pts
- Top 2 equipos destacados en verde (clasificados)
- Click en equipo → detalle del equipo

## Teams Screen
**File**: `lib/presentation/screens/teams/teams_screen.dart`

Grid de 2 columnas con tarjetas de equipo:
- Bandera, nombre, ranking FIFA, grupo
- Búsqueda por nombre/código
- Filtro por grupo (chips horizontales)
- Click → TeamDetailScreen

## Team Detail Screen
**File**: `lib/presentation/screens/teams/team_detail_screen.dart`

Información completa del equipo:
- Bandera grande, nombre, confederación
- Ranking FIFA, entrenador
- Estadísticas (PJ, PG, PE, PP, GF, GC, DG, Pts)
- Lista de jugadores del equipo

## Players Screen
**File**: `lib/presentation/screens/players/players_screen.dart`

Lista de jugadores con búsqueda:
- Nombre, posición, equipo, goles, asistencias
- Click → PlayerDetailScreen

**Nota**: Solo carga datos locales (75 jugadores hardcoded). No usa API.

## Player Detail Screen
**File**: `lib/presentation/screens/players/player_detail_screen.dart`

Detalle del jugador:
- Foto, nombre, posición, número
- Edad, nacionalidad, equipo
- Estadísticas: goles, asistencias, minutos jugados

## Match Detail Screen
**File**: `lib/presentation/screens/matches/match_detail_screen.dart`

Detalle del partido:
- Equipos con banderas y scores
- Estado (live/finished/scheduled)
- Fecha, hora, estadio, árbitro
- Eventos del partido (goles, tarjetas, cambios)
- Estadísticas del partido
- Alineaciones

## Knockout Screen
**File**: `lib/presentation/screens/knockout/knockout_screen.dart`

Bracket de eliminatorias:
- Lista de partidos de knockout
- Indicador de ganador (verde)
- Click → MatchDetailScreen

**⚠️ PROBLEMA**: Siempre vacío porque no hay fixtures de knockout.

## Stadiums Screen
**File**: `lib/presentation/screens/stadiums/stadiums_screen.dart`

Grid de 15 estadios:
- Nombre, ciudad, país, capacidad
- Click → StadiumDetailScreen

## Stadium Detail Screen
**File**: `lib/presentation/screens/stadiums/stadium_detail_screen.dart`

Detalle del estadio:
- Nombre, ubicación, capacidad
- Mapa (Google Maps)
- Coordenadas

## News Screen
**File**: `lib/presentation/screens/news/news_screen.dart`

Lista de noticias del torneo:
- Título, resumen, imagen, fecha
- Click → NewsDetailScreen

**Fuente**: API (eventspastleague) o fallback local (5 noticias hardcoded)

## Settings Screen
**File**: `lib/presentation/screens/settings/settings_screen.dart`

Configuración:
- Modo oscuro/claro (toggle)
- Idioma (EN/ES)
- Notificaciones push

## Favorites Screen
**File**: `lib/presentation/screens/favorites/favorites_screen.dart`

Equipos y jugadores favoritos guardados en Hive.

## Splash Screen
**File**: `lib/presentation/screens/splash/splash_screen.dart`

Pantalla de carga animada (2.5s):
- Logo con gradiente y sombra
- Título "World Cup 2026"
- Subtítulo "Premium Edition"
- Barra de progreso
- Texto de estado ("Initializing...", "Loading data...", "Ready!")
- Navegación automática a /home

## Reusable Widgets

| Widget | File | Description |
|--------|------|-------------|
| `GlassmorphismCard` | `widgets/glassmorphism_card.dart` | Tarjeta con efecto glass |
| `LiquidBottomBar` | `widgets/liquid_bottom_bar.dart` | Bottom nav bar animada |
| `MatchCard` | `widgets/match_card.dart` | Tarjeta de partido |
| `TeamFlag` | `widgets/team_flag.dart` | Bandera del equipo |
| `ScoreDisplay` | `widgets/score_display.dart` | Display de score |
| `ShimmerLoading` | `widgets/shimmer_loading.dart` | Loading skeleton |
| `AppErrorWidget` | `widgets/error_widget.dart` | Widget de error |
| `LiveIndicator` | `widgets/live_indicator.dart` | Indicador "EN VIVO" |
| `EmptyState` | `widgets/empty_state.dart` | Estado vacío |
| `SectionHeader` | `widgets/section_header.dart` | Header de sección |

## Navigation

**Bottom Nav** (ShellRoute):
| Index | Tab | Route |
|-------|-----|-------|
| 0 | Home | `/home` |
| 1 | Fixture | `/fixture` |
| 2 | Standings | `/standings` |
| 3 | Favorites | `/favorites` |
| 4 | Settings | `/settings` |

**Standalone Routes**:
- `/teams` — Lista de equipos
- `/team/:id` — Detalle de equipo
- `/players` — Lista de jugadores
- `/player/:id` — Detalle de jugador
- `/match/:id` — Detalle de partido
- `/knockout` — Bracket de eliminatorias
- `/stadiums` — Lista de estadios
- `/stadium/:id` — Detalle de estadio
- `/news` — Lista de noticias
- `/news/:id` — Detalle de noticia
