import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/presentation/providers/favorites_provider.dart';
import 'package:world_cup_2026/presentation/providers/team_provider.dart';
import 'package:world_cup_2026/presentation/providers/player_provider.dart';
import 'package:world_cup_2026/presentation/providers/match_provider.dart';
import 'package:world_cup_2026/presentation/widgets/glassmorphism_card.dart';
import 'package:world_cup_2026/presentation/widgets/team_flag.dart';
import 'package:world_cup_2026/presentation/widgets/match_card.dart';
import 'package:world_cup_2026/presentation/widgets/empty_state.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final favoriteTeams = favorites.items.where((i) => i.type == FavoriteType.team).toList();
    final favoritePlayers = favorites.items.where((i) => i.type == FavoriteType.player).toList();
    final favoriteMatches = favorites.items.where((i) => i.type == FavoriteType.match).toList();

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppConstants.primaryColor,
          labelColor: Colors.white,
          unselectedLabelColor: AppConstants.secondaryTextColor,
          tabs: [
            Tab(text: 'Teams (${favoriteTeams.length})'),
            Tab(text: 'Players (${favoritePlayers.length})'),
            Tab(text: 'Matches (${favoriteMatches.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTeamsTab(favoriteTeams),
          _buildPlayersTab(favoritePlayers),
          _buildMatchesTab(favoriteMatches),
        ],
      ),
    );
  }

  Widget _buildTeamsTab(List<FavoriteItem> teamItems) {
    if (teamItems.isEmpty) {
      return const EmptyState(
        icon: Icons.star_border,
        title: 'No favorite teams',
        subtitle: 'Tap the star on a team to add it here',
      );
    }

    final teamsAsync = ref.watch(teamListProvider);
    return teamsAsync.when(
      data: (allTeams) {
        final favoriteTeams =
            allTeams.where((t) => teamItems.any((fi) => fi.id == t.id)).toList();
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favoriteTeams.length,
          itemBuilder: (context, index) {
            final team = favoriteTeams[index];
            return _buildTeamCard(team, index);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppConstants.primaryColor),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget _buildPlayersTab(List<FavoriteItem> playerItems) {
    if (playerItems.isEmpty) {
      return const EmptyState(
        icon: Icons.star_border,
        title: 'No favorite players',
        subtitle: 'Tap the star on a player to add it here',
      );
    }

    final playersAsync = ref.watch(playerListProvider);
    return playersAsync.when(
      data: (allPlayers) {
        final favoritePlayers =
            allPlayers.where((p) => playerItems.any((fi) => fi.id == p.id)).toList();
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favoritePlayers.length,
          itemBuilder: (context, index) {
            final player = favoritePlayers[index];
            return _buildPlayerCard(player, index);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppConstants.primaryColor),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget _buildMatchesTab(List<FavoriteItem> matchItems) {
    if (matchItems.isEmpty) {
      return const EmptyState(
        icon: Icons.star_border,
        title: 'No favorite matches',
        subtitle: 'Tap the star on a match to add it here',
      );
    }

    final matchesAsync = ref.watch(matchListProvider);
    return matchesAsync.when(
      data: (allMatches) {
        final favoriteMatches =
            allMatches.where((m) => matchItems.any((fi) => fi.id == m.id)).toList();
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favoriteMatches.length,
          itemBuilder: (context, index) {
            final match = favoriteMatches[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MatchCard(
                match: match,
                onTap: () => context.push('/match/${match.id}'),
              ),
            ).animate().fadeIn(
                delay: Duration(milliseconds: 100 * index),
                duration: 300.ms);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppConstants.primaryColor),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget _buildTeamCard(dynamic team, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassmorphismCard(
        child: InkWell(
          onTap: () => context.push('/team/${team.id}'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                TeamFlag(imageUrl: team.flag, teamName: team.name, size: 50),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Group ${team.group ?? 'N/A'}${team.fifaRanking != null ? ' • #${team.fifaRanking}' : ''}',
                        style: const TextStyle(
                          color: AppConstants.secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.star, color: Colors.amber),
                  onPressed: () {
                    ref
                        .read(favoritesProvider.notifier)
                        .toggleFavorite(FavoriteItem(
                          id: team.id,
                          type: FavoriteType.team,
                          name: team.name,
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(
        delay: Duration(milliseconds: 100 * index), duration: 300.ms);
  }

  Widget _buildPlayerCard(dynamic player, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassmorphismCard(
        child: InkWell(
          onTap: () => context.push('/player/${player.id}'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipOval(
                  child: player.photo != null && player.photo!.isNotEmpty
                      ? Image.network(
                          player.photo!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, url, error) => Container(
                            width: 50,
                            height: 50,
                            color: AppConstants.cardColor,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          color: AppConstants.cardColor,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            player.position ?? '',
                            style: const TextStyle(
                              color: AppConstants.primaryColor,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (player.teamName != null)
                            Expanded(
                              child: Text(
                                player.teamName!,
                                style: const TextStyle(
                                  color: AppConstants.secondaryTextColor,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.star, color: Colors.amber),
                  onPressed: () {
                    ref
                        .read(favoritesProvider.notifier)
                        .toggleFavorite(FavoriteItem(
                          id: player.id,
                          type: FavoriteType.player,
                          name: player.name,
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(
        delay: Duration(milliseconds: 100 * index), duration: 300.ms);
  }
}
