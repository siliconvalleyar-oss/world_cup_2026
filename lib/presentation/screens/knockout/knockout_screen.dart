import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/data/models/match_model.dart';
import 'package:world_cup_2026/data/models/team_model.dart';
import 'package:world_cup_2026/presentation/providers/match_provider.dart';
import 'package:world_cup_2026/presentation/widgets/glassmorphism_card.dart';
import 'package:world_cup_2026/presentation/widgets/team_flag.dart';
import 'package:world_cup_2026/presentation/widgets/empty_state.dart';
import 'package:intl/intl.dart';

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
          'Round of 32',
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
                    'Round of 32 will begin after Matchday 3',
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
        error: (_, __) => const Center(
          child: EmptyState(icon: Icons.wifi_off, title: 'Connection error', subtitle: 'Pull to refresh'),
        ),
      ),
    );
  }

  Widget _buildBracket(List<MatchModel> matches) {
    final confirmedMatches = matches.where((m) => m.status == 'scheduled').toList();
    final pendingMatches = matches.where((m) => m.status == 'pending').toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (confirmedMatches.isNotEmpty) ...[
          _buildSectionHeader('Confirmed Fixtures', Icons.check_circle, AppConstants.secondaryColor),
          const SizedBox(height: 12),
          ...confirmedMatches.map((match) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildMatchCard(match, isConfirmed: true),
          )),
          const SizedBox(height: 24),
        ],
        if (pendingMatches.isNotEmpty) ...[
          _buildSectionHeader('Pending Qualifiers', Icons.hourglass_empty, AppConstants.secondaryTextColor),
          const SizedBox(height: 12),
          ...pendingMatches.map((match) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildMatchCard(match, isConfirmed: false),
          )),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildMatchCard(MatchModel match, {required bool isConfirmed}) {
    final isHomeWinner = match.status == 'finished' && match.homeScore > match.awayScore;
    final isAwayWinner = match.status == 'finished' && match.awayScore > match.homeScore;
    final isTBD = match.homeTeam == null || match.awayTeam == null;

    return GestureDetector(
      onTap: () => context.push('/match/${match.id}'),
      child: GlassmorphismCard(
        borderColor: isConfirmed
            ? AppConstants.secondaryColor.withValues(alpha: 0.3)
            : AppConstants.secondaryTextColor.withValues(alpha: 0.2),
        child: Column(
          children: [
            if (match.date != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: AppConstants.secondaryTextColor),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('EEE, MMM d').format(match.date),
                      style: const TextStyle(
                        color: AppConstants.secondaryTextColor,
                        fontSize: 11,
                      ),
                    ),
                    if (match.time != null) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.access_time, size: 12, color: AppConstants.secondaryTextColor),
                      const SizedBox(width: 4),
                      Text(
                        match.time!,
                        style: const TextStyle(
                          color: AppConstants.secondaryTextColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            _buildTeamRow(
              team: match.homeTeam,
              teamName: match.homeTeam?.name ?? 'TBD',
              flag: match.homeTeam?.flag,
              score: match.homeScore,
              isWinner: isHomeWinner,
              isConfirmed: isConfirmed,
              isTBD: match.homeTeam == null,
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
              team: match.awayTeam,
              teamName: match.awayTeam?.name ?? 'TBD',
              flag: match.awayTeam?.flag,
              score: match.awayScore,
              isWinner: isAwayWinner,
              isConfirmed: isConfirmed,
              isTBD: match.awayTeam == null,
            ),
            if (match.venue != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 12, color: AppConstants.secondaryTextColor),
                    const SizedBox(width: 4),
                    Text(
                      match.venue!.name,
                      style: const TextStyle(
                        color: AppConstants.secondaryTextColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildTeamRow({
    TeamModel? team,
    required String teamName,
    String? flag,
    required int score,
    required bool isWinner,
    required bool isConfirmed,
    required bool isTBD,
  }) {
    final opacity = isTBD ? 0.5 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isWinner
            ? BoxDecoration(
                color: AppConstants.secondaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Row(
          children: [
            if (!isTBD)
              TeamFlag(imageUrl: flag, teamName: teamName, size: 28)
            else
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppConstants.cardColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.question_mark, size: 16, color: AppConstants.secondaryTextColor),
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isTBD ? 'TBD' : teamName,
                style: TextStyle(
                  color: isWinner
                      ? AppConstants.secondaryColor
                      : isTBD
                          ? AppConstants.secondaryTextColor
                          : Colors.white,
                  fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!isTBD)
              Text(
                '$score',
                style: TextStyle(
                  color: isWinner ? AppConstants.secondaryColor : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            else
              const Text(
                '-',
                style: TextStyle(
                  color: AppConstants.secondaryTextColor,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
