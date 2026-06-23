import 'package:flutter/material.dart';

import '../../core/design_system/app_colors.dart';
import '../../core/design_system/app_typography.dart';

class ScoreDisplay extends StatelessWidget {
  final String homeTeamName;
  final String awayTeamName;
  final int homeScore;
  final int awayScore;
  final String? homeFlag;
  final String? awayFlag;
  final bool showTeamNames;
  final bool compact;
  final bool live;

  const ScoreDisplay({
    super.key,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeScore,
    required this.awayScore,
    this.homeFlag,
    this.awayFlag,
    this.showTeamNames = true,
    this.compact = false,
    this.live = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) return _buildCompact();
    return _buildFull();
  }

  Widget _buildFull() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _teamColumn(homeTeamName, homeFlag, isHome: true),
            _scoreColumn(),
            _teamColumn(awayTeamName, awayFlag, isHome: false),
          ],
        ),
      ],
    );
  }

  Widget _teamColumn(String name, String? flag, {required bool isHome}) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showTeamNames) ...[
            Text(
              name,
              style: AppTypography.titleSmall,
              textAlign: isHome ? TextAlign.right : TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _scoreColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            '$homeScore',
            style: AppTypography.displaySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: live ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '-',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            '$awayScore',
            style: AppTypography.displaySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: live ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompact() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$homeScore',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: live ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '-',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$awayScore',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: live ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
