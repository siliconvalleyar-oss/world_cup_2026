import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/data/datasources/local/world_cup_fixtures.dart';
import 'package:world_cup_2026/data/models/group_model.dart';
import 'package:world_cup_2026/data/models/match_model.dart';
import 'package:world_cup_2026/data/models/standing_model.dart';
import 'package:world_cup_2026/presentation/providers/standing_provider.dart';
import 'package:world_cup_2026/presentation/widgets/team_flag.dart';

class BracketTreeScreen extends ConsumerStatefulWidget {
  const BracketTreeScreen({super.key});

  @override
  ConsumerState<BracketTreeScreen> createState() => _BracketTreeScreenState();
}

class _BracketTreeScreenState extends ConsumerState<BracketTreeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppConstants.primaryColor,
              unselectedLabelColor: AppConstants.secondaryTextColor,
              indicatorColor: AppConstants.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 14),
              tabs: const [
                Tab(text: 'Fase de Grupos'),
                Tab(text: 'Clasificados'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGroupPhaseTab(),
                _buildClasificadosTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupPhaseTab() {
    final groupsAsync = ref.watch(groupListProvider);
    return groupsAsync.when(
      data: (groups) {
        if (groups.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor));
        }
        return _buildGroupGrid(groups);
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor)),
      error: (_, __) => const Center(child: Text('Error', style: TextStyle(color: AppConstants.secondaryTextColor))),
    );
  }

  Widget _buildGroupGrid(List<GroupModel> groups) {
    final sortedGroups = List<GroupModel>.from(groups)
      ..sort((a, b) => a.id.compareTo(b.id));

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.82,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: sortedGroups.length,
      itemBuilder: (context, index) => _buildGroupCard(sortedGroups[index]),
    );
  }

  Widget _buildGroupCard(GroupModel group) {
    final sortedTeams = List<StandingModel>.from(group.teams)
      ..sort((a, b) {
        final cmp = b.points.compareTo(a.points);
        if (cmp != 0) return cmp;
        final cmp2 = b.goalDifference.compareTo(a.goalDifference);
        if (cmp2 != 0) return cmp2;
        return b.goalsFor.compareTo(a.goalsFor);
      });

    return Container(
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.primaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(
              'Grupo ${group.id}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              itemCount: sortedTeams.length,
              itemBuilder: (context, index) {
                final standing = sortedTeams[index];
                final isQualified = index < 2;
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                  decoration: BoxDecoration(
                    color: isQualified
                        ? AppConstants.secondaryColor.withValues(alpha: 0.1)
                        : null,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 14,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isQualified
                                ? AppConstants.secondaryColor
                                : AppConstants.secondaryTextColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (standing.team?.flag != null)
                        TeamFlag(
                          imageUrl: standing.team!.flag!,
                          teamName: standing.team?.name ?? '',
                          size: 14,
                          shape: TeamFlagShape.circular,
                          showBorder: false,
                        )
                      else
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppConstants.secondaryTextColor.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          standing.team?.name ?? '???',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isQualified ? Colors.white : AppConstants.secondaryTextColor,
                            fontSize: 10,
                            fontWeight: isQualified ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        '${standing.points}',
                        style: TextStyle(
                          color: isQualified ? AppConstants.secondaryColor : AppConstants.secondaryTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClasificadosTab() {
    final groupsAsync = ref.watch(groupListProvider);
    return groupsAsync.when(
      data: (groups) {
        if (groups.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor));
        }
        return _buildBracketTree(groups);
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor)),
      error: (_, __) => const Center(child: Text('Error', style: TextStyle(color: AppConstants.secondaryTextColor))),
    );
  }

  Widget _buildBracketTree(List<GroupModel> groups) {
    final bracketData = _computeBracket(groups);
    final knockoutMatches = WorldCupFixtures.getKnockoutMatches();

    final r32Left = bracketData['left']!;
    final r32Right = bracketData['right']!;

    final allR32 = [...r32Left, ...r32Right];

    final r16Matches = _buildStageMatches('round_of_16', knockoutMatches, allR32);
    final qfMatches = _buildStageMatches('quarter_final', knockoutMatches, r16Matches);
    final sfMatches = _buildStageMatches('semi_final', knockoutMatches, qfMatches);
    final finalMatch = _buildStageMatches('final', knockoutMatches, sfMatches);
    final thirdMatch = _buildStageMatches('third_place', knockoutMatches, sfMatches);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildStageSection('Octavos de Final - R32', '3 jul - 7 jul 2026', allR32, Icons.sports_soccer),
            _buildArrow(),
            _buildStageSection('Cuartos de Final - R16', '9 jul - 10 jul 2026', r16Matches, Icons.sports_soccer),
            _buildArrow(),
            _buildStageSection('Semifinales - CF', '14 jul - 15 jul 2026', qfMatches, Icons.sports_soccer),
            _buildArrow(),
            _buildStageSection('Semifinal - SF', '18 jul - 19 jul 2026', sfMatches, Icons.emoji_events),
            _buildArrow(),
            if (thirdMatch.isNotEmpty)
              _buildSingleMatchCard(thirdMatch.first, 'Tercer Puesto', isThird: true),
            if (thirdMatch.isNotEmpty) const SizedBox(height: 8),
            if (finalMatch.isNotEmpty)
              _buildSingleMatchCard(finalMatch.first, 'FINAL', isFinal: true),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  List<MatchModel> _buildStageMatches(
    String stage,
    List<MatchModel> knockoutFixtures,
    List<MatchModel> previousStage,
  ) {
    final fixtures = knockoutFixtures.where((m) => m.stage == stage).toList();
    if (previousStage.isEmpty) return fixtures;

    final result = <MatchModel>[];
    for (int i = 0; i < fixtures.length; i++) {
      final fixture = fixtures[i];
      final topIdx = i * 2;
      final botIdx = i * 2 + 1;

      final home = topIdx < previousStage.length ? _getWinner(previousStage[topIdx]) : null;
      final away = botIdx < previousStage.length ? _getWinner(previousStage[botIdx]) : null;

      result.add(MatchModel(
        id: fixture.id,
        homeTeamId: home?.teamId ?? fixture.homeTeamId,
        awayTeamId: away?.teamId ?? fixture.awayTeamId,
        homeTeam: home?.team ?? fixture.homeTeam,
        awayTeam: away?.team ?? fixture.awayTeam,
        homeScore: fixture.homeScore,
        awayScore: fixture.awayScore,
        status: fixture.status,
        stage: fixture.stage,
        date: fixture.date,
        time: fixture.time,
        venue: fixture.venue,
      ));
    }
    return result;
  }

  StandingModel? _getWinner(MatchModel match) {
    if (match.status == 'finished' || match.status == 'ft') {
      if (match.homeScore > match.awayScore) {
        return StandingModel(teamId: match.homeTeamId, team: match.homeTeam);
      } else if (match.awayScore > match.homeScore) {
        return StandingModel(teamId: match.awayTeamId, team: match.awayTeam);
      }
    }
    if (match.homeTeamId.isNotEmpty) {
      return StandingModel(teamId: match.homeTeamId, team: match.homeTeam);
    }
    return null;
  }

  Widget _buildStageSection(String title, String dateRange, List<MatchModel> matches, IconData icon) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppConstants.primaryColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dateRange,
                      style: TextStyle(
                        color: AppConstants.secondaryTextColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${matches.length}',
                  style: const TextStyle(
                    color: AppConstants.primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...matches.map((m) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: _buildMatchCard(m),
        )),
      ],
    );
  }

  Widget _buildMatchCard(MatchModel match) {
    final isFinished = match.status == 'finished' || match.status == 'ft';
    final homeWin = isFinished && match.homeScore > match.awayScore;
    final awayWin = isFinished && match.awayScore > match.homeScore;
    final hasHome = match.homeTeamId.isNotEmpty;
    final hasAway = match.awayTeamId.isNotEmpty;
    final isKnockout = match.stage != 'group_stage';

    String dateStr = '';
    String timeStr = '';
    try {
      dateStr = DateFormat('dd MMM', 'es').format(match.date);
      if (match.time != null) {
        timeStr = match.time!;
      } else {
        timeStr = DateFormat('HH:mm').format(match.date);
      }
    } catch (_) {
      dateStr = DateFormat('dd MMM').format(match.date);
      timeStr = DateFormat('HH:mm').format(match.date);
    }

    return GestureDetector(
      onTap: () {
        if (isKnockout) {
          context.push('/match/${match.id}');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppConstants.cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isFinished
                ? (homeWin || awayWin
                    ? AppConstants.secondaryColor.withValues(alpha: 0.4)
                    : AppConstants.secondaryTextColor.withValues(alpha: 0.2))
                : AppConstants.secondaryTextColor.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 10, color: AppConstants.secondaryTextColor),
                const SizedBox(width: 4),
                Text(
                  '$dateStr  •  $timeStr',
                  style: TextStyle(
                    color: AppConstants.secondaryTextColor,
                    fontSize: 10,
                  ),
                ),
                if (match.venue != null) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.stadium, size: 10, color: AppConstants.secondaryTextColor),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      match.venue?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppConstants.secondaryTextColor,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            _buildTeamRow(
              teamName: match.homeTeam?.name,
              flag: match.homeTeam?.flag,
              score: match.homeScore,
              isWinner: homeWin,
              isFinished: isFinished,
              hasTeam: hasHome,
              isHome: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(child: Divider(color: AppConstants.secondaryTextColor.withValues(alpha: 0.2))),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isFinished
                          ? AppConstants.secondaryColor.withValues(alpha: 0.15)
                          : AppConstants.secondaryTextColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isFinished ? '${match.homeScore} - ${match.awayScore}' : 'VS',
                      style: TextStyle(
                        color: isFinished ? AppConstants.secondaryColor : AppConstants.secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppConstants.secondaryTextColor.withValues(alpha: 0.2))),
                ],
              ),
            ),
            _buildTeamRow(
              teamName: match.awayTeam?.name,
              flag: match.awayTeam?.flag,
              score: match.awayScore,
              isWinner: awayWin,
              isFinished: isFinished,
              hasTeam: hasAway,
              isHome: false,
            ),
            if (isFinished && (homeWin || awayWin))
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppConstants.secondaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 12, color: AppConstants.secondaryColor),
                    const SizedBox(width: 4),
                    Text(
                      'Clasifica: ${homeWin ? (match.homeTeam?.name ?? '???') : (match.awayTeam?.name ?? '???')}',
                      style: TextStyle(
                        color: AppConstants.secondaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamRow({
    required String? teamName,
    required String? flag,
    required int score,
    required bool isWinner,
    required bool isFinished,
    required bool hasTeam,
    required bool isHome,
  }) {
    final displayName = hasTeam ? (teamName ?? '???') : 'Por definir (TBD)';
    final isEmpty = !hasTeam;

    return Row(
      children: [
        if (flag != null && hasTeam)
          TeamFlag(
            imageUrl: flag,
            teamName: teamName ?? '',
            size: 22,
            shape: TeamFlagShape.circular,
            showBorder: false,
          )
        else
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppConstants.secondaryTextColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(Icons.question_mark, size: 10, color: AppConstants.secondaryTextColor),
          ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isEmpty
                  ? AppConstants.secondaryTextColor
                  : isWinner
                      ? AppConstants.secondaryColor
                      : Colors.white,
              fontSize: 13,
              fontWeight: isWinner
                  ? FontWeight.bold
                  : isEmpty
                      ? FontWeight.normal
                      : FontWeight.w500,
            ),
          ),
        ),
        if (isFinished && hasTeam)
          Container(
            width: 28,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isWinner
                  ? AppConstants.secondaryColor.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$score',
              style: TextStyle(
                color: isWinner ? AppConstants.secondaryColor : AppConstants.secondaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSingleMatchCard(MatchModel match, String title, {bool isFinal = false, bool isThird = false}) {
    final isFinished = match.status == 'finished' || match.status == 'ft';
    final homeWin = isFinished && match.homeScore > match.awayScore;
    final awayWin = isFinished && match.awayScore > match.homeScore;

    final borderColor = isFinal
        ? const Color(0xFFFFD700)
        : isThird
            ? const Color(0xFFCD7F32)
            : AppConstants.primaryColor;

    String dateStr = '';
    String timeStr = '';
    try {
      dateStr = DateFormat('dd MMM', 'es').format(match.date);
      timeStr = match.time ?? DateFormat('HH:mm').format(match.date);
    } catch (_) {
      dateStr = DateFormat('dd MMM').format(match.date);
      timeStr = DateFormat('HH:mm').format(match.date);
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isFinal
            ? const Color(0xFF1A1500)
            : isThird
                ? const Color(0xFF151008)
                : AppConstants.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor.withValues(alpha: 0.6), width: 2),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.15),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: borderColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: borderColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today, size: 11, color: AppConstants.secondaryTextColor),
              const SizedBox(width: 4),
              Text(
                '$dateStr  •  $timeStr',
                style: TextStyle(color: AppConstants.secondaryTextColor, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTeamRow(
            teamName: match.homeTeam?.name,
            flag: match.homeTeam?.flag,
            score: match.homeScore,
            isWinner: homeWin,
            isFinished: isFinished,
            hasTeam: match.homeTeamId.isNotEmpty,
            isHome: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(child: Divider(color: borderColor.withValues(alpha: 0.3))),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: isFinished
                        ? borderColor.withValues(alpha: 0.2)
                        : borderColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isFinished ? '${match.homeScore} - ${match.awayScore}' : 'VS',
                    style: TextStyle(
                      color: borderColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: borderColor.withValues(alpha: 0.3))),
              ],
            ),
          ),
          _buildTeamRow(
            teamName: match.awayTeam?.name,
            flag: match.awayTeam?.flag,
            score: match.awayScore,
            isWinner: awayWin,
            isFinished: isFinished,
            hasTeam: match.awayTeamId.isNotEmpty,
            isHome: false,
          ),
          if (isFinished && (homeWin || awayWin))
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: borderColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_events, size: 14, color: borderColor),
                  const SizedBox(width: 6),
                  Text(
                    'Campeón: ${homeWin ? (match.homeTeam?.name ?? '???') : (match.awayTeam?.name ?? '???')}',
                    style: TextStyle(
                      color: borderColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildArrow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 2,
            height: 20,
            color: AppConstants.primaryColor.withValues(alpha: 0.3),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: AppConstants.primaryColor.withValues(alpha: 0.5),
            size: 20,
          ),
        ],
      ),
    );
  }

  Map<String, List<MatchModel>> _computeBracket(List<GroupModel> groups) {
    final groupMap = <String, List<StandingModel>>{};
    for (final g in groups) {
      final sorted = List<StandingModel>.from(g.teams)
        ..sort((a, b) {
          final cmp = b.points.compareTo(a.points);
          if (cmp != 0) return cmp;
          final cmp2 = b.goalDifference.compareTo(a.goalDifference);
          if (cmp2 != 0) return cmp2;
          return b.goalsFor.compareTo(a.goalsFor);
        });
      groupMap[g.id] = sorted;
    }

    final first = <String, StandingModel>{};
    final second = <String, StandingModel>{};
    final third = <StandingModel>[];

    for (final entry in groupMap.entries) {
      final teams = entry.value;
      if (teams.isNotEmpty) first[entry.key] = teams[0];
      if (teams.length >= 2) second[entry.key] = teams[1];
      if (teams.length >= 3) third.add(teams[2]);
    }

    third.sort((a, b) {
      final cmp = b.points.compareTo(a.points);
      if (cmp != 0) return cmp;
      final cmp2 = b.goalDifference.compareTo(a.goalDifference);
      if (cmp2 != 0) return cmp2;
      return b.goalsFor.compareTo(a.goalsFor);
    });
    final bestThird = third.take(8).toList();

    StandingModel? findFirst(String group) => first[group];
    StandingModel? findSecond(String group) => second[group];
    StandingModel? findThird(int index) => index < bestThird.length ? bestThird[index] : null;

    final knockoutFixtures = WorldCupFixtures.getKnockoutMatches();
    final r32Fixtures = knockoutFixtures.where((m) => m.stage == 'round_of_32').toList();

    MatchModel buildMatch(int fixtureIndex, String id, StandingModel? home, StandingModel? away, String stage) {
      final fixture = fixtureIndex < r32Fixtures.length ? r32Fixtures[fixtureIndex] : null;
      return MatchModel(
        id: id,
        homeTeamId: home?.teamId ?? fixture?.homeTeamId ?? '',
        awayTeamId: away?.teamId ?? fixture?.awayTeamId ?? '',
        homeTeam: home?.team ?? fixture?.homeTeam,
        awayTeam: away?.team ?? fixture?.awayTeam,
        homeScore: fixture?.homeScore ?? 0,
        awayScore: fixture?.awayScore ?? 0,
        status: fixture?.status ?? 'pending',
        date: fixture?.date ?? DateTime(2026, 7, 1),
        time: fixture?.time,
        stage: stage,
        venue: fixture?.venue,
      );
    }

    final left = [
      buildMatch(0, 'R32_01', findFirst('A'), findSecond('B'), 'round_of_32'),
      buildMatch(1, 'R32_02', findFirst('C'), findSecond('D'), 'round_of_32'),
      buildMatch(2, 'R32_03', findFirst('E'), findSecond('F'), 'round_of_32'),
      buildMatch(3, 'R32_04', findFirst('G'), findSecond('H'), 'round_of_32'),
      buildMatch(4, 'R32_05', findFirst('B'), findSecond('A'), 'round_of_32'),
      buildMatch(5, 'R32_06', findFirst('D'), findSecond('C'), 'round_of_32'),
      buildMatch(6, 'R32_07', findFirst('F'), findSecond('E'), 'round_of_32'),
      buildMatch(7, 'R32_08', findFirst('H'), findSecond('G'), 'round_of_32'),
    ];

    final right = [
      buildMatch(8, 'R32_09', findFirst('I'), findSecond('J'), 'round_of_32'),
      buildMatch(9, 'R32_10', findFirst('K'), findSecond('L'), 'round_of_32'),
      buildMatch(10, 'R32_11', findFirst('J'), findSecond('I'), 'round_of_32'),
      buildMatch(11, 'R32_12', findFirst('L'), findSecond('K'), 'round_of_32'),
      buildMatch(12, 'R32_13', findThird(0), findThird(1), 'round_of_32'),
      buildMatch(13, 'R32_14', findThird(2), findThird(3), 'round_of_32'),
      buildMatch(14, 'R32_15', findThird(4), findThird(5), 'round_of_32'),
      buildMatch(15, 'R32_16', findThird(6), findThird(7), 'round_of_32'),
    ];

    final finalMatch = buildMatch(16, 'FINAL', null, null, 'final');
    final thirdMatch = buildMatch(17, 'THIRD', null, null, 'third_place');

    return {'left': left, 'right': right, 'final': [finalMatch], 'third': [thirdMatch]};
  }
}
