# World Cup 2026 — Flutter Application

## Overview

Aplicación móvil premium para la FIFA World Cup 2026, desarrollada en Flutter con arquitectura clean architecture. Ofrece información en tiempo real sobre partidos, equipos, jugadores, posiciones, estadios y noticias del torneo.

## Características

- **48 equipos** en 12 grupos
- **Partidos en vivo** con actualizaciones de TheSportsDB API
- **Tabla de posiciones** por grupo con clasificación a eliminatorias
- **Detalle de equipos y jugadores** con estadísticas
- **16 estadios** en USA, Canadá y México
- **Noticias** del torneo
- **Soporte bilingüe**: Inglés/Español
- **Modo oscuro/claro**
- **Favoritos** con persistencia local (Hive)
- **Splash screen** con animaciones

## Tech Stack

| Componente | Tecnología |
|------------|-----------|
| Framework | Flutter 3.x (Dart ^3.12.0) |
| State Management | flutter_riverpod ^2.6.1 |
| Routing | go_router ^14.8.1 |
| HTTP Client | dio ^5.7.0 |
| Local Storage | hive ^2.2.3 |
| Code Generation | freezed + json_serializable |
| Animations | flutter_animate ^4.5.2 |
| UI Components | glassmorphism cards, liquid bottom bar |

## Estructura del Proyecto

```
lib/
├── main.dart                 # Entry point
├── app/app.dart              # MaterialApp + GoRouter
├── core/                     # Config, network, services, theme, utils
├── data/                     # datasources, models, repositories
├── domain/                   # entities, repositories (abstract), usecases
├── features/                 # Feature modules (empty dirs)
└── presentation/             # providers, screens, router, widgets
```

## Ejecución

```bash
# Instalar dependencias
flutter pub get

# Generar código (freezed)
dart run build_runner build --delete-conflicting-outputs

# Ejecutar
flutter run

# Build APK
flutter build apk --release
```

## API

La app usa **TheSportsDB** (API gratuita) para obtener datos del torneo:
- Liga ID: `4429` (FIFA World Cup)
- Temporada: `2026`
- Base URL: `https://www.thesportsdb.com/api/v1/json/3`

Los datos locales (hardcoded) sirven como fallback cuando la API no responde.

## Problemas Conocidos

Ver `issues.md` para la lista completa de bugs. Los más críticos:
1. IDs de equipos duplicados (4 equipos comparten ID `136477`)
2. Pantalla de eliminatorias vacía (no hay fixtures de knockout)
3. Mismatches entre IDs de jugadores y equipos
4. Datos de equipos que no calificaron al Mundial

## Docs

- `ARCHITECTURE.md` — Arquitectura detallada
- `API.md` — Endpoints y configuración de API
- `DATA.md` — Capa de datos y modelos
- `ISSUES.md` — Todos los bugs encontrados
- `GROUPS.md` — Análisis de grupos vs realidad
- `FEATURES.md` — Documentación de features
