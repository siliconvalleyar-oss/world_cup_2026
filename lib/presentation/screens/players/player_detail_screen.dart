import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/data/models/player_model.dart';
import 'package:world_cup_2026/presentation/providers/player_provider.dart';
import 'package:world_cup_2026/presentation/providers/favorites_provider.dart';
import 'package:world_cup_2026/presentation/widgets/glassmorphism_card.dart';
import 'package:world_cup_2026/presentation/widgets/empty_state.dart';

class PlayerDetailScreen extends ConsumerWidget {
  final String playerId;

  const PlayerDetailScreen({super.key, required this.playerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerAsync = ref.watch(playerDetailProvider(playerId));
    final notifier = ref.read(favoritesProvider.notifier);
    final isFavorite = notifier.isFavorite(playerId);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: playerAsync.when(
        data: (player) {
          if (player == null) {
            return const Center(child: EmptyState(icon: Icons.person_off, title: 'Player not found', subtitle: ''));
          }
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(context, player, isFavorite, notifier),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildPlayerInfo(player),
                    _buildStatsSection(player),
                  ],
                ),
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

  Widget _buildSliverAppBar(BuildContext context, PlayerModel player, bool isFavorite, FavoritesNotifier notifier) {
    return SliverAppBar(
      expandedHeight: 300,
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
              id: player.id,
              type: FavoriteType.player,
              name: player.name,
              imageUrl: player.photo,
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
                ClipOval(
                  child: player.photo != null && player.photo!.isNotEmpty
                      ? Image.network(
                          player.photo!,
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (context, url, error) => Container(
                            width: 140,
                            height: 140,
                            color: AppConstants.cardColor,
                            child: const Icon(Icons.person, size: 60, color: Colors.white),
                          ),
                        )
                      : Container(
                          width: 140,
                          height: 140,
                          color: AppConstants.cardColor,
                          child: const Icon(Icons.person, size: 60, color: Colors.white),
                        ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      duration: 500.ms,
                      curve: Curves.elasticOut,
                    ),
                const SizedBox(height: 16),
                Text(
                  player.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (player.teamName != null)
                      Text(
                        player.teamName!,
                        style: const TextStyle(
                          color: AppConstants.secondaryTextColor,
                          fontSize: 16,
                        ),
                      ),
                  ],
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerInfo(PlayerModel player) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GlassmorphismCard(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(Icons.cake, player.age != null ? '${player.age} years' : 'N/A'),
                _buildInfoItem(Icons.location_on, player.nationality ?? 'N/A'),
                _buildInfoItem(Icons.tag, player.number != null ? '#${player.number}' : 'N/A'),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppConstants.cardColor),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(Icons.sports_soccer, player.position ?? 'N/A'),
                _buildInfoItem(Icons.timer, '${player.minutesPlayed} min'),
                _buildInfoItem(Icons.star, '${player.goals} goals'),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }

  Widget _buildInfoItem(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, color: AppConstants.primaryColor, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatsSection(PlayerModel player) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Goals',
                  '${player.goals}',
                  Icons.sports_soccer,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Assists',
                  '${player.assists}',
                  Icons.handshake,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Yellow Cards',
                  '${player.yellowCards}',
                  Icons.square,
                  Colors.yellow,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Red Cards',
                  '${player.redCards}',
                  Icons.square,
                  Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return GlassmorphismCard(
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 24,
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
      ),
    );
  }
}
