import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../core/design_system/app_colors.dart';
import '../../core/design_system/app_typography.dart';
import '../../data/models/match_model.dart';
import 'glassmorphism_card.dart';
import 'live_indicator.dart';
import 'team_flag.dart';

class MatchCard extends StatelessWidget {
  final MatchModel match;
  final VoidCallback? onTap;

  const MatchCard({
    super.key,
    required this.match,
    this.onTap,
  });

  bool get isLive =>
      match.status == 'live' || match.status == 'in_play' || match.status == 'halftime';
  bool get isFinished =>
      match.status == 'finished' || match.status == 'ft';
  bool get isScheduled => match.status == 'scheduled';

  @override
  Widget build(BuildContext context) {
    return GlassmorphismCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildScoreRow(),
          const SizedBox(height: 8),
          _buildFooter(),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildHeader() {
    if (isLive) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LiveIndicator(),
          const SizedBox(width: 8),
          Text(
            match.time ?? 'LIVE',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.liveIndicator,
            ),
          ),
        ],
      );
    }
    if (isFinished) {
      return Text(
        'FULL TIME',
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textSecondary,
          letterSpacing: 1.5,
        ),
      );
    }
    if (match.group != null) {
      return Text(
        'Group ${match.group}',
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.primary,
          letterSpacing: 1.0,
        ),
      );
    }
    return Text(
      DateFormat('MMM d, HH:mm').format(match.date),
      style: AppTypography.labelSmall.copyWith(
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildScoreRow() {
    return Row(
      children: [
        Expanded(
          child: _TeamInfo(
            name: match.homeTeam?.name ?? 'TBD',
            flag: match.homeTeam?.flag,
            alignment: CrossAxisAlignment.end,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${match.homeScore} - ${match.awayScore}',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: isLive ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: _TeamInfo(
            name: match.awayTeam?.name ?? 'TBD',
            flag: match.awayTeam?.flag,
            alignment: CrossAxisAlignment.start,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    if (match.venue != null) {
      return Text(
        match.venue!.name,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    return const SizedBox.shrink();
  }
}

class _TeamInfo extends StatelessWidget {
  final String name;
  final String? flag;
  final CrossAxisAlignment alignment;

  const _TeamInfo({
    required this.name,
    this.flag,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        TeamFlag(
          imageUrl: flag,
          teamName: name,
          size: 40,
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
          textAlign: alignment == CrossAxisAlignment.end
              ? TextAlign.end
              : TextAlign.start,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
