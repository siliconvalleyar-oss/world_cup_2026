import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/core/theme/app_theme.dart';
import 'package:world_cup_2026/presentation/providers/settings_provider.dart';
import 'package:world_cup_2026/presentation/screens/splash/splash_screen.dart';
import 'package:world_cup_2026/presentation/screens/home/home_screen.dart';
import 'package:world_cup_2026/presentation/screens/fixture/fixture_screen.dart';
import 'package:world_cup_2026/presentation/screens/matches/match_detail_screen.dart';
import 'package:world_cup_2026/presentation/screens/standings/standings_screen.dart';
import 'package:world_cup_2026/presentation/screens/knockout/knockout_screen.dart';
import 'package:world_cup_2026/presentation/screens/teams/teams_screen.dart';
import 'package:world_cup_2026/presentation/screens/teams/team_detail_screen.dart';
import 'package:world_cup_2026/presentation/screens/players/players_screen.dart';
import 'package:world_cup_2026/presentation/screens/players/player_detail_screen.dart';
import 'package:world_cup_2026/presentation/screens/stadiums/stadiums_screen.dart';
import 'package:world_cup_2026/presentation/screens/stadiums/stadium_detail_screen.dart';
import 'package:world_cup_2026/presentation/screens/news/news_screen.dart';
import 'package:world_cup_2026/presentation/screens/news/news_detail_screen.dart';
import 'package:world_cup_2026/presentation/screens/favorites/favorites_screen.dart';
import 'package:world_cup_2026/presentation/screens/settings/settings_screen.dart';
import 'package:world_cup_2026/presentation/widgets/liquid_bottom_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/fixture',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FixtureScreen(),
            ),
          ),
          GoRoute(
            path: '/standings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StandingsScreen(),
            ),
          ),
          GoRoute(
            path: '/favorites',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FavoritesScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/match/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => MatchDetailScreen(
          matchId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/teams',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TeamsScreen(),
      ),
      GoRoute(
        path: '/team/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => TeamDetailScreen(
          teamId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/players',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PlayersScreen(),
      ),
      GoRoute(
        path: '/player/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => PlayerDetailScreen(
          playerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/stadiums',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const StadiumsScreen(),
      ),
      GoRoute(
        path: '/stadium/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => StadiumDetailScreen(
          stadiumId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/news',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NewsScreen(),
      ),
      GoRoute(
        path: '/news/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => NewsDetailScreen(
          articleId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/knockout',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const KnockoutScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppConstants.primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.toString() ?? '',
              style: const TextStyle(
                color: AppConstants.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Go Home',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ),
  );
});

class WorldCupApp extends ConsumerWidget {
  const WorldCupApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final settings = ref.watch(settingsProvider);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF0A0A0A),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return MaterialApp.router(
      title: 'World Cup 2026',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      routerConfig: goRouter,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
    );
  }
}

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: LiquidBottomBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/fixture')) return 1;
    if (location.startsWith('/standings')) return 2;
    if (location.startsWith('/favorites')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/fixture');
        break;
      case 2:
        context.go('/standings');
        break;
      case 3:
        context.go('/favorites');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }
}
