import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/data/models/standing_model.dart';
import 'package:world_cup_2026/presentation/providers/standing_provider.dart';
import 'package:world_cup_2026/presentation/widgets/glassmorphism_card.dart';
import 'package:world_cup_2026/presentation/widgets/team_flag.dart';
import 'package:world_cup_2026/presentation/widgets/error_widget.dart';

class StandingsScreen extends ConsumerStatefulWidget {
  const StandingsScreen({super.key});

  @override
  ConsumerState<StandingsScreen> createState() => _StandingsScreenState();
}

class _StandingsScreenState extends ConsumerState<StandingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 12, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final standingsAsync = ref.watch(standingsProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        title: const Text(
          'Standings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppConstants.primaryColor,
          labelColor: Colors.white,
          unselectedLabelColor: AppConstants.secondaryTextColor,
          tabs: List.generate(
            12,
            (index) => Tab(text: String.fromCharCode(65 + index)),
          ),
        ),
      ),
      body: standingsAsync.when(
        data: (groups) => TabBarView(
          controller: _tabController,
          children: List.generate(12, (index) {
            final groupLetter = String.fromCharCode(65 + index);
            final group = groups.where((g) => g.name == groupLetter).firstOrNull;
            return _buildGroupStandings(groupLetter, group?.teams ?? []);
          }),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppConstants.primaryColor),
        ),
        error: (error, stack) => Center(
          child: AppErrorWidget(
            message: error.toString(),
            onRetry: () => ref.refresh(groupListProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupStandings(String groupLetter, List<StandingModel> standings) {
    if (standings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.table_chart,
              size: 64,
              color: AppConstants.secondaryTextColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Group $groupLetter',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No standings available',
              style: TextStyle(color: AppConstants.secondaryTextColor),
            ),
          ],
        ),
      );
    }

    final sortedStandings = List<StandingModel>.from(standings)
      ..sort((a, b) {
        final cmp = b.points.compareTo(a.points);
        if (cmp != 0) return cmp;
        return b.goalDifference.compareTo(a.goalDifference);
      });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Group $groupLetter',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 16),
          _buildTableHeader(),
          const SizedBox(height: 8),
          ...List.generate(sortedStandings.length, (index) {
            final standing = sortedStandings[index];
            final isQualified = index < 2;
            return _buildStandingRow(standing, index + 1, isQualified, index);
          }),
          const SizedBox(height: 24),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return GlassmorphismCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: const Row(
        children: [
          SizedBox(width: 30, child: _HeaderText('Pos')),
          SizedBox(width: 12),
          Expanded(flex: 3, child: _HeaderText('Team')),
          Expanded(child: _HeaderText('P', center: true)),
          Expanded(child: _HeaderText('W', center: true)),
          Expanded(child: _HeaderText('D', center: true)),
          Expanded(child: _HeaderText('L', center: true)),
          Expanded(child: _HeaderText('GF', center: true)),
          Expanded(child: _HeaderText('GA', center: true)),
          Expanded(child: _HeaderText('GD', center: true)),
          Expanded(
            child: _HeaderText('Pts', center: true),
          ),
        ],
      ),
    );
  }

  Widget _buildStandingRow(
      StandingModel standing, int position, bool isQualified, int index) {
    final teamName = standing.team?.name ?? standing.teamId;
    final teamFlag = standing.team?.flag;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassmorphismCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        borderColor: isQualified
            ? AppConstants.secondaryColor.withValues(alpha: 0.5)
            : null,
        child: InkWell(
          onTap: () => context.push('/team/${standing.teamId}'),
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isQualified
                        ? AppConstants.secondaryColor
                        : AppConstants.cardColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '$position',
                      style: TextStyle(
                        color: isQualified ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    TeamFlag(imageUrl: teamFlag, teamName: teamName, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        teamName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _StatCell('${standing.played}'),
              ),
              Expanded(
                child: _StatCell('${standing.won}'),
              ),
              Expanded(
                child: _StatCell('${standing.drawn}'),
              ),
              Expanded(
                child: _StatCell('${standing.lost}'),
              ),
              Expanded(
                child: _StatCell('${standing.goalsFor}'),
              ),
              Expanded(
                child: _StatCell('${standing.goalsAgainst}'),
              ),
              Expanded(
                child: _StatCell(
                  '${standing.goalDifference >= 0 ? '+' : ''}${standing.goalDifference}',
                  color: standing.goalDifference > 0
                      ? AppConstants.secondaryColor
                      : standing.goalDifference < 0
                          ? Colors.red
                          : Colors.white,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${standing.points}',
                    style: const TextStyle(
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(
          delay: Duration(milliseconds: 50 * index), duration: 300.ms),
    );
  }

  Widget _buildLegend() {
    return GlassmorphismCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legend',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppConstants.secondaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Qualified to Round of 16',
                style: TextStyle(
                  color: AppConstants.secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppConstants.cardColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppConstants.secondaryTextColor.withValues(alpha: 0.3),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Eliminated',
                style: TextStyle(
                  color: AppConstants.secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  final bool center;

  const _HeaderText(this.text, {this.center = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppConstants.secondaryTextColor,
        fontWeight: FontWeight.bold,
        fontSize: 11,
      ),
      textAlign: center ? TextAlign.center : TextAlign.left,
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final Color? color;

  const _StatCell(this.value, {this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }
}
