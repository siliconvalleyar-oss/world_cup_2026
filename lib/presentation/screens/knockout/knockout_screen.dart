import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/data/models/match_model.dart';
import 'package:world_cup_2026/presentation/providers/match_provider.dart';
import 'package:world_cup_2026/presentation/widgets/glassmorphism_card.dart';
import 'package:world_cup_2026/presentation/widgets/team_flag.dart';
import 'package:world_cup_2026/presentation/widgets/error_widget.dart';

class KnockoutScreen extends ConsumerStatefulWidget {
  const KnockoutScreen({super.key});

  @override
  ConsumerState<KnockoutScreen> createState() => _KnockoutScreenState();
}

class _KnockoutScreenState extends ConsumerState<KnockoutScreen> {
  @override
  Widget build(BuildContext context) {
    final knockoutMatches = ref.watch(knockoutMatchesProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        title: const Text(
          'Knockout Stage',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: knockoutMatches.when(
        data: (matches) {
          if (matches.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, size: 64, color: AppConstants.secondaryTextColor),
                  SizedBox(height: 16),
                  Text(
                    'No knockout matches yet',
                    style: TextStyle(color: AppConstants.secondaryTextColor, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Knockout matches will appear here',
                    style: TextStyle(color: AppConstants.secondaryTextColor),
                  ),
                ],
              ),
            );
          }
          return _buildBracket(matches);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppConstants.primaryColor),
        ),
        error: (error, stack) => Center(
          child: AppErrorWidget(
            message: error.toString(),
            onRetry: () => ref.refresh(knockoutMatchesProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildBracket(List<MatchModel> matches) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildMatchCard(match),
        );
      },
    );
  }

  Widget _buildMatchCard(MatchModel match) {
    final isHomeWinner = match.status == 'finished' && match.homeScore > match.awayScore;
    final isAwayWinner = match.status == 'finished' && match.awayScore > match.homeScore;

    return GestureDetector(
      onTap: () => context.push('/match/${match.id}'),
      child: GlassmorphismCard(
        child: Column(
          children: [
            _buildTeamRow(
              teamName: match.homeTeam?.name ?? 'TBD',
              flag: match.homeTeam?.flag,
              score: match.homeScore,
              isWinner: isHomeWinner,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(child: Divider(color: AppConstants.cardColor)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'VS',
                      style: TextStyle(
                        color: AppConstants.secondaryTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppConstants.cardColor)),
                ],
              ),
            ),
            _buildTeamRow(
              teamName: match.awayTeam?.name ?? 'TBD',
              flag: match.awayTeam?.flag,
              score: match.awayScore,
              isWinner: isAwayWinner,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildTeamRow({
    required String teamName,
    String? flag,
    required int score,
    required bool isWinner,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: isWinner
          ? BoxDecoration(
              color: AppConstants.secondaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Row(
        children: [
          TeamFlag(imageUrl: flag, teamName: teamName, size: 28),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              teamName,
              style: TextStyle(
                color: isWinner ? AppConstants.secondaryColor : Colors.white,
                fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$score',
            style: TextStyle(
              color: isWinner ? AppConstants.secondaryColor : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
