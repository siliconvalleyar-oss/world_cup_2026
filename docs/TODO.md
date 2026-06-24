# TODO — World Cup 2026

## Urgente — Datos Incorrectos

- [ ] **Fix duplicate team ID `136477`** — Reasignar IDs únicos a Cape Verde, Curaçao, Jordan, DR Congo en `world_cup_local_data.dart`
- [ ] **Fix duplicate team ID `136516`** — Sweden y Norway comparten ID, asignar único
- [ ] **Fix duplicate team ID `136471`** — Haiti y Paraguay comparten ID, asignar único
- [ ] **Fix player-team ID mismatches** — 9 equipos con IDs incorrectos en `world_cup_players_data.dart`:
  - France: `133909` → `133913`
  - Spain: `134504` → `133909`
  - England: `134499` → `133914`
  - Portugal: `134502` → `133908`
  - Netherlands: `134505` → `133905`
  - Japan: `134513` → `134503`
  - South Korea: `134498` → `134517`
  - Uruguay: `134522` → `134504`
  - Italy: eliminar (no clasificó)
- [ ] **Remove Italy players** — Italia no clasificó al Mundial, eliminar p041-p045
- [ ] **Sync scorer goals with player goals** — Diferencias entre `world_cup_scorers.dart` y `world_cup_players_data.dart`

## Urgente — Funcionalidad Rota

- [ ] **Implement knockout stage fixtures** — Agregar fixtures R32, R16, QF, SF, F en `world_cup_fixtures.dart` con `group: null`
- [ ] **Fix knockoutMatchesProvider** — Verificar filtro `group == null` funcione con nuevos fixtures
- [ ] **Fix standings tiebreakers** — Agregar goals scored, head-to-head, fair play a `world_cup_local_data.dart:224`

## Alta — Arquitectura

- [ ] **Remove duplicate GoRouter** — Eliminar `app_router.dart` o `app.dart` router, mantener solo uno
- [ ] **Add error logging** — Reemplazar `catch (_) {}` por logs en `thesportsdb_service.dart`
- [ ] **Add user-facing error messages** — Providers deben mostrar errores en UI, no datos vacíos
- [ ] **Remove unused `ApiEndpoints` class** — `api_endpoints.dart` define API inexistente
- [ ] **Wire up `MatchRemoteDataSource` and `TeamRemoteDataSource`** — Actualmente no se usan, TheSportsDBService los reemplaza

## Media — Features Pendientes

- [ ] **Add player remote datasource** — Actualmente solo carga datos locales
- [ ] **Add live match polling** — Auto-refresh cada 60s cuando hay partidos en vivo
- [ ] **Add match notifications** — Push cuando empieza un partido del equipo favorito
- [ ] **Add favorite teams persistence** — Guardar/cargar de Hive
- [ ] **Add favorite players persistence** — Guardar/cargar de Hive
- [ ] **Add pull-to-refresh en todos los screens** — Algunos screens no lo tienen
- [ ] **Add search en standings** — Filtrar equipos en la tabla
- [ ] **Add team statistics tab** — Goles, posesión promedio, formación más usada
- [ ] **Add head-to-head records** — Historial entre dos equipos
- [ ] **Add tournament bracket visualization** — Bracket visual no solo lista

## Media — UI/UX

- [ ] **Fix StandingsScreen 12 hardcoded tabs** — Hacer dinámico según datos reales
- [ ] **Add loading skeleton en todos los screens** — Algunos no tienen shimmer
- [ ] **Add empty state en todos los screens** — Todos deben tener EmptyState widget
- [ ] **Add match countdown timer** — Para partidos scheduled
- [ ] **Add team form indicator** — W/D/L en los últimos 5 partidos
- [ ] **Add group permutation calculator** — Qué necesita cada equipo para clasificar

## Baja — Calidad

- [ ] **Add unit tests** — Tests para TheSportsDBService, providers, models
- [ ] **Add widget tests** — Tests para pantallas principales
- [ ] **Add integration tests** — Flujo completo home → match → team
- [ ] **Fix `flutter analyze` warnings** — Revisar todos los warnings
- [ ] **Add `.env` for API key** — Mover API key a variable de entorno
- [ ] **Add Firebase configuration** — Configurar `google-services.json` y `GoogleService-Info.plist`
- [ ] **Add asset declarations in pubspec.yaml** — Declarar `assets:` section
- [ ] **Verify fixture dates against FIFA schedule** — Fechas hardcodeadas pueden estar mal
- [ ] **Add proper 3rd-place advancement logic** — Cuáles terceros pasan a R32

## Baja — Mantenimiento

- [ ] **Update README.md in project root** — Actualizar con info real del proyecto
- [ ] **Add CONTRIBUTING.md** — Guía para contribuidores
- [ ] **Add CHANGELOG.md** — Historial de cambios por versión
- [ ] **Add .editorconfig** — Configuración de formato de código
- [ ] **Clean up unused imports** — Verificar imports no usados en todos los archivos
- [ ] **Remove `error/` folder** — Screenshots de WhatsApp no deberían estar en el repo
