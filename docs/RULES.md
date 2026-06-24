# RULES — World Cup 2026

## Versioning Rules

### Obligatorio en cada compilación

1. **Incrementar versión en `pubspec.yaml`** sumando `0.0.1` a la parte `+build`:
   - `1.0.3+4` → `1.0.3+5` (cada compile)
   - Si hay cambios de feature/major, incrementar `1.0.3` → `1.1.0` o `2.0.0`

2. **Sincronizar `lib/core/constants/app_constants.dart`** con pubspec.yaml:
   ```dart
   static const String appVersion = '1.0.3';   // sin el +build
   static const String appBuildNumber = '5';    // el número después del +
   ```

3. **Crear tag de git** con la versión completa después de compilar:
   ```bash
   git tag v1.0.3+5
   ```

4. **El `android/app/build.gradle.kts`** ya usa `flutter.versionCode` y `flutter.versionName` de pubspec — NO modificar.

### Fuentes de verdad (orden de precedencia)

| Prioridad | Archivo | Campo |
|-----------|---------|-------|
| 1 | `pubspec.yaml` | `version: X.Y.Z+B` |
| 2 | `app_constants.dart` | `appVersion` + `appBuildNumber` |
| 3 | `git tag` | `vX.Y.Z+B` |

Todas deben coincidir SIEMPRE.

---

## Code Rules

### Arquitectura

1. **Clean Architecture**: data → domain → presentation. Nunca importar de presentation en data.
2. **Riverpod providers**: Todo el estado pasa por providers en `lib/presentation/providers/`.
3. **Freezed models**: Cada modelo nuevo debe usar `@freezed` y generar `.freezed.dart` + `.g.dart`.
4. **After modifying models**: SIEMPRE ejecutar `dart run build_runner build --delete-conflicting-outputs`.

### Datos

5. **Nunca hardcodear datos nuevos** sin verificar IDs únicos. Cada equipo/jugador necesita un ID único.
6. **TheSportsDB IDs**: Usar los IDs reales de la API. Nunca reutilizar un ID para equipos distintos.
7. **Merge strategy**: Datos locales son fallback. API tiene prioridad cuando está disponible.

### UI

8. **Bilingual**: Todo texto visible debe pasar por `L10n.of(context)` con EN y ES.
9. **Dark/Light theme**: Usar colores de `AppConstants` o `settingsProvider.isDark`. No hardcodear colores.
10. **GlassmorphismCard**: Usar para todas las tarjetas. No crear containers custom sin glass effect.

### API

11. **Error handling**: NUNCA usar `catch (_) {}`. Al mínimo loguear el error.
12. **Timeouts**: Usar los valores de `ApiConfig` (30s). No crear timeouts nuevos.
13. **Cache**: Respetar el `CacheInterceptor`. No hacer cache manual.

### Testing

14. **Antes de commit**: Verificar que `flutter analyze` no tenga errores.
15. **Antes de build**: Verificar que freezed esté generado.

### Git

16. **Nunca commitear**: `build/`, `.dart_tool/`, `*.g.dart`, `*.freezed.dart` (están en .gitignore).
17. **Commits descriptivos**: `feat:`, `fix:`, `docs:`, `refactor:` al inicio.
18. **Tag después de build exitoso**: `git tag v{version}`.

---

## Checklist Pre-Build

- [ ] `pubspec.yaml` version incrementada (+1 al build number)
- [ ] `app_constants.dart` sincronizado con pubspec
- [ ] `dart run build_runner build --delete-conflicting-outputs` ejecutado
- [ ] `flutter analyze` sin errores
- [ ] APK compilado: `flutter build apk --release`
- [ ] Git tag creado: `git tag v{version}`
