import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/data/models/player_model.dart';
import 'package:world_cup_2026/presentation/providers/player_provider.dart';
import 'package:world_cup_2026/presentation/widgets/empty_state.dart';
import 'package:world_cup_2026/presentation/widgets/glassmorphism_card.dart';
import 'package:world_cup_2026/presentation/widgets/shimmer_loading.dart';

class TopScorersScreen extends ConsumerWidget {
  const TopScorersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scorersAsync = ref.watch(topScorersLeaderboardProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        title: const Text(
          'Top Scorers',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: scorersAsync.when(
        data: (scorers) {
          if (scorers.isEmpty) {
            return const EmptyState(
              icon: Icons.sports_soccer,
              title: 'No scorers yet',
              subtitle: 'Goals will appear after matches are played',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: scorers.length,
            itemBuilder: (context, index) {
              final player = scorers[index];
              final position = index + 1;
              return _buildScorerRow(player, position, index);
            },
          );
        },
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 10,
          itemBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: ShimmerLoading(pattern: ShimmerPattern.listTile),
            );
          },
        ),
        error: (_, __) => const Center(
          child: EmptyState(
            icon: Icons.wifi_off,
            title: 'Connection error',
            subtitle: 'Pull to refresh',
          ),
        ),
      ),
    );
  }

  Widget _buildScorerRow(PlayerModel player, int position, int index) {
    final medalColors = {1: const Color(0xFFFFD700), 2: const Color(0xFFC0C0C0), 3: const Color(0xFFCD7F32)};
    final isMedal = position <= 3;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassmorphismCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 36,
              child: isMedal
                  ? Icon(Icons.emoji_events, color: medalColors[position], size: 24)
                  : Text(
                      '$position',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppConstants.secondaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            ClipOval(
              child: player.photo != null && player.photo!.isNotEmpty
                  ? Image.network(
                      player.photo!,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (context, url, error) => _defaultAvatar(),
                    )
                  : _defaultAvatar(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  if (player.teamName != null && player.teamName!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        player.teamName!,
                        style: const TextStyle(
                          color: AppConstants.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${player.goals}',
                style: const TextStyle(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
      delay: Duration(milliseconds: 50 * index),
      duration: 300.ms,
    );
  }

  Widget _defaultAvatar() {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: AppConstants.cardColor,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: AppConstants.secondaryTextColor, size: 24),
    );
  }
}
