import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/data/models/match_model.dart';
import 'package:world_cup_2026/data/models/event_model.dart';
import 'package:world_cup_2026/presentation/providers/match_provider.dart';
import 'package:world_cup_2026/presentation/widgets/glassmorphism_card.dart';
import 'package:world_cup_2026/presentation/widgets/live_indicator.dart';
import 'package:world_cup_2026/presentation/widgets/team_flag.dart';
import 'package:world_cup_2026/presentation/widgets/score_display.dart';
import 'package:world_cup_2026/presentation/widgets/empty_state.dart';
import 'package:intl/intl.dart';

class MatchDetailScreen extends ConsumerStatefulWidget {
  final String matchId;

  const MatchDetailScreen({super.key, required this.matchId});

  @override
  ConsumerState<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends ConsumerState<MatchDetailScreen>
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
    final matchAsync = ref.watch(matchDetailProvider(widget.matchId));

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: matchAsync.when(
        data: (match) {
          if (match == null) {
            return const Center(
              child: EmptyState(icon: Icons.sports_soccer, title: 'Match not found', subtitle: ''),
            );
          }
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(match),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildMatchHeader(match),
                    _buildMatchInfo(match),
                    _buildTabs(match),
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

  bool _isLive(String status) =>
      status == 'live' || status == 'in_play' || status == 'halftime';

  Widget _buildSliverAppBar(MatchModel match) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppConstants.backgroundColor,
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        TeamFlag(
                          imageUrl: match.homeTeam?.flag,
                          teamName: match.homeTeam?.name ?? 'TBD',
                          size: 80,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          match.homeTeam?.name ?? 'TBD',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),
                    Column(
                      children: [
                        if (_isLive(match.status)) ...[
                          const LiveIndicator(),
                          const SizedBox(height: 8),
                        ],
                        ScoreDisplay(
                          homeTeamName: match.homeTeam?.name ?? 'TBD',
                          awayTeamName: match.awayTeam?.name ?? 'TBD',
                          homeScore: match.homeScore,
                          awayScore: match.awayScore,
                          live: _isLive(match.status),
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),
                    Column(
                      children: [
                        TeamFlag(
                          imageUrl: match.awayTeam?.flag,
                          teamName: match.awayTeam?.name ?? 'TBD',
                          size: 80,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          match.awayTeam?.name ?? 'TBD',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMatchHeader(MatchModel match) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GlassmorphismCard(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  match.status.toUpperCase(),
                  style: const TextStyle(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (match.group != null) ...[
                  const Text(' • '),
                  Text(
                    'Group ${match.group}',
                    style: const TextStyle(
                      color: AppConstants.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, MMMM d, yyyy').format(match.date),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            if (match.time != null)
              Text(
                match.time!,
                style: const TextStyle(
                  color: AppConstants.secondaryTextColor,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildMatchInfo(MatchModel match) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassmorphismCard(
        child: Column(
          children: [
            if (match.venue != null)
              _buildInfoRow(Icons.location_on, 'Venue', match.venue!.name),
            if (match.venue != null)
              const Divider(color: AppConstants.cardColor, height: 1),
            _buildInfoRow(
              Icons.person,
              'Referee',
              match.referee ?? 'TBD',
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.primaryColor, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: AppConstants.secondaryTextColor,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(MatchModel match) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppConstants.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: AppConstants.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: AppConstants.secondaryTextColor,
            tabs: const [
              Tab(text: 'Timeline'),
              Tab(text: 'Stats'),
              Tab(text: 'Lineups'),
            ],
          ),
        ),
        SizedBox(
          height: 500,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTimelineTab(match),
              _buildStatisticsTab(match),
              _buildLineupsTab(match),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineTab(MatchModel match) {
    final events = match.events;
    if (events == null || events.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timeline, size: 64, color: AppConstants.secondaryTextColor),
            SizedBox(height: 16),
            Text(
              'No events yet',
              style: TextStyle(color: AppConstants.secondaryTextColor),
            ),
          ],
        ),
      );
    }

    final sortedEvents = List<EventModel>.from(events)
      ..sort((a, b) => (a.minute ?? 0).compareTo(b.minute ?? 0));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedEvents.length,
      itemBuilder: (context, index) {
        final event = sortedEvents[index];
        return _buildTimelineEvent(event, index);
      },
    );
  }

  Widget _buildTimelineEvent(EventModel event, int index) {
    IconData icon;
    Color color;

    switch (event.type) {
      case 'goal':
        icon = Icons.sports_soccer;
        color = AppConstants.secondaryColor;
      case 'yellow_card':
        icon = Icons.square;
        color = Colors.yellow;
      case 'red_card':
        icon = Icons.square;
        color = Colors.red;
      case 'substitution':
        icon = Icons.swap_horiz;
        color = AppConstants.primaryColor;
      default:
        icon = Icons.info_outline;
        color = AppConstants.secondaryTextColor;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              event.minute != null ? '${event.minute}\'' : '',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.playerName ?? event.description ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (event.description != null && event.playerName != null)
                  Text(
                    event.description!,
                    style: const TextStyle(
                      color: AppConstants.secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
        delay: Duration(milliseconds: 100 * index), duration: 300.ms);
  }

  Widget _buildStatisticsTab(MatchModel match) {
    final stats = match.statistics;
    if (stats == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 64, color: AppConstants.secondaryTextColor),
            SizedBox(height: 16),
            Text(
              'Statistics not available',
              style: TextStyle(color: AppConstants.secondaryTextColor),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatBar('Possession', stats.possessionHome.round(), stats.possessionAway.round(), '%'),
        _buildStatBar('Shots', stats.shotsHome, stats.shotsAway, ''),
        _buildStatBar('Shots on Target', stats.shotsOnTargetHome, stats.shotsOnTargetAway, ''),
        _buildStatBar('Corners', stats.cornersHome, stats.cornersAway, ''),
        _buildStatBar('Fouls', stats.foulsHome, stats.foulsAway, ''),
        _buildStatBar('Yellow Cards', stats.yellowCardsHome, stats.yellowCardsAway, ''),
        _buildStatBar('Red Cards', stats.redCardsHome, stats.redCardsAway, ''),
        _buildStatBar('Offsides', stats.offsidesHome, stats.offsidesAway, ''),
      ],
    );
  }

  Widget _buildStatBar(String label, int homeValue, int awayValue, String suffix) {
    final total = homeValue + awayValue;
    final homePercent = total > 0 ? homeValue / total : 0.5;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$homeValue$suffix',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: AppConstants.secondaryTextColor,
                  fontSize: 12,
                ),
              ),
              Text(
                '$awayValue$suffix',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: homePercent,
                    backgroundColor: AppConstants.cardColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppConstants.primaryColor,
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 1 - homePercent,
                    backgroundColor: AppConstants.cardColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppConstants.secondaryColor,
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineupsTab(MatchModel match) {
    final lineups = match.lineups;
    if (lineups == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups, size: 64, color: AppConstants.secondaryTextColor),
            SizedBox(height: 16),
            Text(
              'Lineups not available',
              style: TextStyle(color: AppConstants.secondaryTextColor),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTeamLineup(
            match.homeTeam?.name ?? 'Home',
            lineups.formation ?? '',
            lineups.homeLineup,
            AppConstants.primaryColor,
          ),
          const SizedBox(height: 32),
          _buildTeamLineup(
            match.awayTeam?.name ?? 'Away',
            lineups.formation ?? '',
            lineups.awayLineup,
            AppConstants.secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamLineup(
      String teamName, String formation, List<dynamic> players, Color color) {
    return GlassmorphismCard(
      child: Column(
        children: [
          Text(
            teamName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (formation.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              formation,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 16),
          ...players.map((player) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Text(
                        player.number?.toString() ?? '',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        player.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      player.position ?? '',
                      style: const TextStyle(
                        color: AppConstants.secondaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
