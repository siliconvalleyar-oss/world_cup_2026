# World Cup 2026 — Documentación Completa

## Visión General

**World Cup 2026 Premium** es una aplicación móvil desarrollada en Flutter para seguir la Copa Mundial de la FIFA 2026. Ofrece información en tiempo real sobre partidos, equipos, jugadores, posiciones, estadios y noticias, con soporte bilingüe (Inglés/Español) y modo oscuro/claro.

| Dato | Valor |
|------|-------|
| Versión actual | `1.0.3+5` |
| Países sede | Estados Unidos, Canadá, México |
| Equipos | 48 (12 grupos de 4) |
| Fecha inicio | 11 de junio de 2026 |
| Fecha final | 19 de julio de 2026 |
| Estadios | 16 sedes en 3 países |

---

## Instalación

### Requisitos previos

- Flutter SDK ^3.12.0
- Dart SDK ^3.12.0
- Android Studio / Xcode (para emuladores)
- Dispositivo Android o iOS

### Pasos

```bash
# 1. Clonar el repositorio
git clone https://github.com/siliconvalleyar-oss/world_cup_2026.git
cd world_cup_2026

# 2. Instalar dependencias
flutter pub get

# 3. Generar código (freezed + json_serializable)
dart run build_runner build --delete-conflicting-outputs

# 4. Ejecutar en emulador/dispositivo
flutter run

# 5. Compilar APK (release)
flutter build apk --release

# El APK se genera en: build/app/outputs/flutter-apk/app-release.apk
# Copiar a APK/ con la versión:
cp build/app/outputs/flutter-apk/app-release.apk APK/world_cup_2026_v1.0.3+5.apk
```

---

## Arquitectura

```
lib/
├── main.dart                          # Entry point: Hive init + ProviderScope
├── app/app.dart                       # MaterialApp.router + GoRouter + ScaffoldWithNavBar
├── core/
│   ├── config/api_config.dart         # TheSportsDB base URL + league ID 4429
│   ├── constants/
│   │   ├── api_endpoints.dart         # Endpoints API (no usados)
│   │   ├── app_constants.dart         # Colores, info del torneo, paths de assets
│   │   └── hive_constants.dart
│   ├── network/
│   │   ├── dio_client.dart            # Cliente HTTP singleton con interceptors
│   │   ├── api_response.dart          # Wrapper de respuesta
│   │   └── interceptors/              # auth, cache, logging, retry
│   ├── services/                      # connectivity, hive, notification
│   ├── localization/app_localizations.dart  # Traducciones EN/ES
│   ├── errors/                        # Failure + AppException
│   ├── extensions/                    # context, string
│   ├── design_system/                 # colors, typography, spacing, glass, shadows
│   ├── theme/app_theme.dart           # Tema oscuro
│   └── widgets/                       # Widgets reutilizables del core
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── world_cup_local_data.dart    # 48 equipos + standings + 15 estadios
│   │   │   ├── world_cup_fixtures.dart      # 72 partidos fase de grupos
│   │   │   ├── world_cup_players_data.dart  # 75 jugadores (15 equipos)
│   │   │   └── world_cup_scorers.dart       # 15 goleadores
│   │   └── remote/
│   │       ├── thesportsdb_service.dart     # Servicio API principal
│   │       └── *_remote_datasource.dart     # Datasources abstractos
│   ├── models/                        # Modelos Freezed (Team, Match, Group, Standing, etc.)
│   └── repositories/                  # Implementación con Either<Failure, T>
├── domain/
│   ├── entities/                      # Entidades plain Dart
│   ├── repositories/                  # Interfaces abstractas
│   └── usecases/
├── features/                          # Módulos de features (directorios vacíos)
└── presentation/
    ├── providers/                     # Riverpod providers
    ├── screens/                       # Todas las pantallas
    ├── router/app_router.dart         # GoRouter (duplicado, no usado)
    └── widgets/                       # Widgets reutilizables de UI
```

### Flujo de Datos

```
TheSportsDB API ──→ TheSportsDBService ──→ Merge API + Local ──→ Providers ──→ Screens
                         │
                         ├── getMatches()        → fixtures locales + eventos API
                         ├── getTeamsFromStandings() → 48 equipos locales + tabla API
                         ├── getGroups()         → grupos locales + standings API
                         ├── getNews()           → eventos pasados API OR fallback local
                         └── getVenues()         → 15 estadios locales + eventos API
```

---

## Pantallas y Navegación

### Bottom Navigation Bar (ShellRoute)

| Índice | Tab | Ruta | Descripción |
|--------|-----|------|-------------|
| 0 | Inicio | `/home` | Dashboard principal con 5 secciones |
| 1 | Calendario | `/fixture` | Partidos por fecha o por grupo |
| 2 | Posiciones | `/standings` | Tabla de posiciones 12 grupos |
| 3 | Favoritos | `/favorites` | Equipos y jugadores guardados |
| 4 | Configuración | `/settings` | Tema, idioma, notificaciones |

### Rutas Independientes

| Ruta | Pantalla | Descripción |
|------|----------|-------------|
| `/teams` | TeamsScreen | Grid de 48 equipos con búsqueda y filtro |
| `/team/:id` | TeamDetailScreen | Detalle completo del equipo |
| `/players` | PlayersScreen | Lista de jugadores con búsqueda |
| `/player/:id` | PlayerDetailScreen | Detalle del jugador |
| `/match/:id` | MatchDetailScreen | Detalle del partido (3 tabs) |
| `/knockout` | KnockoutScreen | Bracket de eliminatorias |
| `/stadiums` | StadiumsScreen | Grid de 16 estadios |
| `/stadium/:id` | StadiumDetailScreen | Detalle + mapa del estadio |
| `/news` | NewsScreen | Lista de noticias |
| `/news/:id` | NewsDetailScreen | Detalle de noticia |

---

## Funcionalidades Detalladas

### Home Screen (`/home`)

Pantalla principal con 5 secciones en scroll vertical:

1. **Partidos en Vivo** — Scroll horizontal de partidos con estado `live`. Muestra banderas, scores y indicador "EN VIVO".
2. **Próximos Partidos** — Los 5 próximos partidos programados. Click → detalle.
3. **Resultados Recientes** — Los 5 últimos partidos finalizados con scores.
4. **Noticias Destacadas** — Scroll horizontal de noticias con imagen, título y fecha.
5. **Equipos Destacados** — Scroll horizontal de 12 equipos con bandera y ranking FIFA.

Soporta **pull-to-refresh** que recarga partidos, noticias y equipos simultáneamente.

### Fixture Screen (`/fixture`)

Dos vistas disponibles mediante tabs:

**Por Fecha:**
- Partidos agrupados por día
- Indicador "HOY" en el día actual
- Conteo de partidos por día
- Scroll vertical con todos los días

**Por Grupo:**
- ExpansionTile por cada grupo (A-L)
- Cada grupo muestra sus 6 partidos
- Los primeros 3 grupos expandidos por defecto

**Búsqueda y Filtros:**
- Barra de búsqueda por nombre de equipo o estadio
- Filtro por grupo específico
- Filtro por fecha específica
- Botón para limpiar filtros

### Standings Screen (`/standings`)

12 tabs (A a L) con tabla de posiciones:

| Columna | Descripción |
|---------|-------------|
| Pos | Posición (1-4) |
| Equipo | Bandera + nombre |
| PJ | Partidos jugados |
| PG | Partidos ganados |
| PE | Partidos empatados |
| PP | Partidos perdidos |
| GF | Goles a favor |
| GC | Goles en contra |
| DG | Diferencia de goles |
| Pts | Puntos |

- Top 2 equipos destacados en **verde** (clasificados a octavos)
- Click en equipo → TeamDetailScreen
- Leyenda: Verde = Clasificado, Gris = Eliminado

### Teams Screen (`/teams`)

Grid de 2 columnas con tarjetas de equipo:

- Bandera del equipo (desde TheSportsDB)
- Nombre del equipo
- Ranking FIFA
- Grupo asignado (badge verde)
- **Búsqueda** por nombre o código del equipo
- **Filtro por grupo** (chips horizontales: Todos, A, B, C... L)
- Click → TeamDetailScreen

### Team Detail Screen (`/team/:id`)

- Bandera grande del equipo
- Nombre y código del equipo
- Confederación y ranking FIFA
- Entrenador
- Estadísticas: PJ, PG, PE, PP, GF, GC, DG, Pts
- Lista de jugadores del equipo

### Match Detail Screen (`/match/:id`)

3 tabs con información completa:

**Tab 1: Timeline**
- Cronología de eventos del partido
- Goles (ícono verde ⚽)
- Tarjetas amarillas/rojas
- Sustituciones
- Minuto de cada evento

**Tab 2: Stats**
- Posesión de balón (barras comparativas)
- Tiros / Tiros a puerta
- Córners
- Faltas
- Tarjetas amarillas/rojas
- Fueras de juego

**Tab 3: Lineups**
- Alineación titular de cada equipo
- Formación táctica
- Número y posición de cada jugador

**Header del partido:**
- Banderas grandes de ambos equipos
- Score central con indicador de estado
- Fecha, hora, estadio y árbitro
- Indicador "EN VIVO" cuando el partido está en juego

### Knockout Screen (`/knockout`)

Bracket de eliminatorias:
- Lista de partidos de knockout
- Indicador de ganador (verde)
- Click → MatchDetailScreen

**⚠️ Estado actual**: Vacío — no hay fixtures de knockout definidos.

### Stadiums Screen (`/stadiums`)

Grid de estadios con:
- Nombre del estadio
- Ciudad y país
- Capacidad
- Click → StadiumDetailScreen

### Stadium Detail Screen (`/stadium/:id`)

- Nombre y foto del estadio
- Ubicación (ciudad, país)
- Capacidad
- Mapa integrado (Google Maps)
- Coordenadas GPS

### News Screen (`/news`)

Lista cronológica de noticias:
- Imagen (si disponible)
- Título y resumen
- Fecha de publicación
- Fuente: API (eventos pasados) o fallback local
- Click → NewsDetailScreen

### Settings Screen (`/settings`)

4 secciones:

**Apariencia:**
- Modo Oscuro/Claro (toggle switch)

**Idioma:**
- English / Español (radio buttons)

**Notificaciones:**
- Notificaciones Push (toggle switch)

**Acerca de:**
- Logo de la app
- Nombre: "World Cup 2026 Premium"
- Versión

### Favorites Screen (`/favorites`)

Equipos y jugadores marcados como favoritos, persistidos en Hive local.

### Splash Screen

Pantalla de carga animada (2.5 segundos):
- Logo circular con gradiente y sombra
- Título "World Cup 2026"
- Subtítulo "Premium Edition"
- Barra de progreso
- Texto de estado: "Initializing..." → "Loading data..." → "Ready!"
- Navegación automática a `/home`

---

## API

### TheSportsDB (API activa)

| Configuración | Valor |
|---------------|-------|
| Base URL | `https://www.thesportsdb.com/api/v1/json/3` |
| API Key | `3` (tier gratuito) |
| League ID | `4429` (FIFA World Cup) |
| Season | `2026` |

**Endpoints utilizados:**

| Endpoint | Parámetros | Retorna |
|----------|-----------|---------|
| `/eventsseason.php` | `id=4429, s=2026` | Lista de eventos (partidos) |
| `/lookuptable.php` | `l=4429, s=2026` | Tabla de posiciones |
| `/eventsnextleague.php` | `id=4429` | Próximos partidos |
| `/eventspastleague.php` | `id=4429` | Eventos pasados (noticias) |

**Merge de datos:**
1. Datos locales se cargan primero (fallback)
2. Se llama a la API
3. Los datos de la API sobreescriben los locales cuando están disponibles
4. Si la API falla, se usan datos locales silenciosamente

---

## Stack Tecnológico

| Componente | Tecnología | Versión |
|------------|-----------|---------|
| Framework | Flutter | 3.x |
| Lenguaje | Dart | ^3.12.0 |
| State Management | flutter_riverpod | ^2.6.1 |
| Routing | go_router | ^14.8.1 |
| HTTP Client | dio | ^5.7.0 |
| Local Storage | hive + hive_flutter | ^2.2.3 |
| Code Generation | freezed + json_serializable | ^2.5.8 / ^6.9.4 |
| Animations | flutter_animate | ^4.5.2 |
| Imágenes | cached_network_image | ^3.4.1 |
| Shimmer | shimmer | ^3.0.0 |
| SVG | flutter_svg | ^2.0.17 |
| Fechas | intl | ^0.20.2 |
| Functional | dartz | ^0.10.1 |
| Equatable | equatable | ^2.0.7 |
| Firebase | firebase_core + messaging + analytics | ^3.12.1 |

---

## Modelos de Datos

### TeamModel
```dart
{
  id: String,           // TheSportsDB ID único
  name: String,         // "Mexico"
  code: String?,        // "MEX"
  flag: String?,        // URL de la bandera
  confederation: String?, // "CONCACAF"
  fifaRanking: int?,    // 14
  group: String?,       // "A"
  coach: String?,       // "Javier Aguirre"
  wins: int,            // 0
  draws: int,           // 0
  losses: int,          // 0
  goalsFor: int,        // 0
  goalsAgainst: int,    // 0
  points: int,          // 0
}
```

### MatchModel
```dart
{
  id: String,           // ID del evento
  homeTeamId: String,
  awayTeamId: String,
  homeTeam: TeamModel?,
  awayTeam: TeamModel?,
  homeScore: int,       // 0
  awayScore: int,       // 0
  status: String,       // "scheduled" | "live" | "finished" | "postponed"
  matchday: int?,       // 1, 2, 3
  group: String?,       // "A" - null para knockout
  venue: VenueModel?,
  referee: String?,
  date: DateTime,
  time: String?,
  events: List<EventModel>?,
  statistics: MatchStatistics?,
  lineups: Lineups?,
}
```

### GroupModel
```dart
{
  id: String,           // "A"
  name: String,         // "A"
  teams: List<StandingModel>,  // 4 equipos ordenados por posición
}
```

### StandingModel
```dart
{
  teamId: String,
  team: TeamModel?,
  played: int,
  won: int,
  drawn: int,
  lost: int,
  goalsFor: int,
  goalsAgainst: int,
  goalDifference: int,
  points: int,
  position: int,
}
```

---

## Dependencias de Hive

| Box | Uso |
|-----|-----|
| `settings` | Tema, idioma, país, notificaciones |
| `favorites` | Equipos y jugadores favoritos |
| `cache` | Datos cacheados de la API |
| `api_cache` | Respuestas HTTP cacheadas (5 min TTL) |

---

## Problemas Conocidos

| Severidad | Problema | Archivo |
|-----------|----------|---------|
| CRÍTICO | ID `136477` duplicado para 4 equipos | `world_cup_local_data.dart` |
| CRÍTICO | Knockout siempre vacío (no hay fixtures) | `match_provider.dart` |
| CRÍTICO | Player-team ID mismatches (9 equipos afectados) | `world_cup_players_data.dart` |
| ALTO | Italia tiene jugadores pero no clasificó | `world_cup_players_data.dart` |
| ALTO | Router duplicado (app.dart + app_router.dart) | `app.dart` |
| ALTO | Errores API silenciados `catch (_) {}` | `thesportsdb_service.dart` |
| MEDIO | StandingsScreen hardcodea 12 tabs | `standings_screen.dart` |
| MEDIO | Fechas de fixtures pueden estar mal | `world_cup_fixtures.dart` |
| BAJO | ApiEndpoints definido pero no usado | `api_endpoints.dart` |

Ver `ISSUES.md` para la lista completa.

---

## Documentación Adicional

| Archivo | Contenido |
|---------|-----------|
| `ARCHITECTURE.md` | Arquitectura detallada, data flow, state management |
| `API.md` | Configuración de API, endpoints, formatos de respuesta |
| `DATA.md` | Modelos freezed, datasources, repositories |
| `ISSUES.md` | Lista completa de bugs con severidad y ubicación |
| `GROUPS.md` | Análisis de grupos vs sorteo real de FIFA |
| `FEATURES.md` | Documentación de cada pantalla y widget |
| `RULES.md` | Reglas de versioning, coding y checklist pre-build |

---

## Comandos Útiles

```bash
# Desarrollo
flutter run                          # Ejecutar en emulador
flutter run --release                # Ejecutar release
flutter analyze                      # Analizar errores estáticos
flutter test                         # Ejecutar tests

# Build
flutter build apk --debug            # APK debug
flutter build apk --release          # APK release
flutter build appbundle --release    # AAB para Play Store

# Code Generation
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch          # Watch mode (re-genera automáticamente)

# Git
git status                           # Estado actual
git add <files>                      # Agregar archivos
git commit -m "feat: descripción"    # Commit
git tag v1.0.3+5                     # Crear tag
git push origin main                 # Push commits
git push origin v1.0.3+5             # Push tag

# Limpieza
flutter clean                        # Limpiar builds
flutter pub get                      # Re-instalar dependencias
```
