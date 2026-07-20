import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home/home_screen.dart';
import '../screens/fixture/fixture_screen.dart';
import '../screens/standings/standings_screen.dart';
import '../screens/teams/teams_screen.dart';
import '../screens/matches/match_detail_screen.dart';
import '../screens/players/players_screen.dart';
import '../screens/players/player_detail_screen.dart';
import '../screens/teams/team_detail_screen.dart';
import '../screens/stadiums/stadiums_screen.dart';
import '../screens/stadiums/stadium_detail_screen.dart';
import '../screens/news/news_screen.dart';
import '../screens/news/news_detail_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/knockout/knockout_screen.dart';
import '../screens/knockout/bracket_tree_screen.dart';
import '../screens/top_scorers/top_scorers_screen.dart';
import '../widgets/liquid_bottom_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
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
          path: '/teams',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TeamsScreen(),
          ),
        ),
        GoRoute(
          path: '/bracket-tree',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BracketTreeScreen(),
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
    GoRoute(
      path: '/bracket-tree',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const BracketTreeScreen(),
    ),
    GoRoute(
      path: '/top-scorers',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TopScorersScreen(),
    ),
  ],
);

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
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/fixture')) return 1;
    if (location.startsWith('/bracket-tree')) return 2;
    if (location.startsWith('/standings')) return 3;
    if (location.startsWith('/teams')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
      case 1:
        context.go('/fixture');
      case 2:
        context.go('/bracket-tree');
      case 3:
        context.go('/standings');
      case 4:
        context.go('/teams');
    }
  }
}
