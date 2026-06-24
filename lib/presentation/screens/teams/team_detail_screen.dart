import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/data/models/team_model.dart';
import 'package:world_cup_2026/presentation/providers/team_provider.dart';
import 'package:world_cup_2026/presentation/providers/favorites_provider.dart';
import 'package:world_cup_2026/presentation/widgets/glassmorphism_card.dart';
import 'package:world_cup_2026/presentation/widgets/team_flag.dart';
import 'package:world_cup_2026/presentation/widgets/empty_state.dart';

class TeamDetailScreen extends ConsumerWidget {
  final String teamId;

  const TeamDetailScreen({super.key, required this.teamId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamAsync = ref.watch(teamDetailProvider(teamId));
    final notifier = ref.read(favoritesProvider.notifier);
    final isFavorite = notifier.isFavorite(teamId);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: teamAsync.when(
        data: (team) {
          if (team == null) {
            return const Center(child: EmptyState(icon: Icons.person_off, title: 'Team not found', subtitle: ''));
          }
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(context, ref, team, isFavorite, notifier),
              SliverToBoxAdapter(
                child: _buildTeamInfo(team),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppConstants.primaryColor),
        ),
        error: (_, __) => const Center(
          child: EmptyState(icon: Icons.wifi_off, title: 'Connection error', subtitle: 'Pull to refresh'),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, WidgetRef ref, TeamModel team, bool isFavorite, FavoritesNotifier notifier) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppConstants.backgroundColor,
      actions: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Colors.amber : Colors.white,
          ),
          onPressed: () {
            notifier.toggleFavorite(FavoriteItem(
              id: team.id,
              type: FavoriteType.team,
              name: team.name,
              imageUrl: team.flag,
            ));
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A1A2E),
                AppConstants.backgroundColor,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                TeamFlag(imageUrl: team.flag, teamName: team.name, size: 120)
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      duration: 500.ms,
                      curve: Curves.elasticOut,
                    ),
                const SizedBox(height: 16),
                Text(
                  team.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                if (team.confederation != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    team.confederation!,
                    style: const TextStyle(
                      color: AppConstants.secondaryTextColor,
                      fontSize: 16,
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamInfo(TeamModel team) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GlassmorphismCard(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Ranking', team.fifaRanking != null ? '#${team.fifaRanking}' : 'N/A'),
                _buildStatItem('Group', team.group ?? 'N/A'),
                _buildStatItem('Confederation', team.confederation ?? 'N/A'),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppConstants.cardColor),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person, color: AppConstants.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Coach: ${team.coach ?? 'TBD'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppConstants.cardColor),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('W', '${team.wins}'),
                _buildStatItem('D', '${team.draws}'),
                _buildStatItem('L', '${team.losses}'),
                _buildStatItem('GF', '${team.goalsFor}'),
                _buildStatItem('GA', '${team.goalsAgainst}'),
                _buildStatItem('Pts', '${team.points}'),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppConstants.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppConstants.secondaryTextColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
