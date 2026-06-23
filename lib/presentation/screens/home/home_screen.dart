import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/data/models/match_model.dart';
import 'package:world_cup_2026/data/models/news_model.dart';
import 'package:world_cup_2026/data/models/team_model.dart';
import 'package:world_cup_2026/presentation/providers/match_provider.dart';
import 'package:world_cup_2026/presentation/providers/team_provider.dart';
import 'package:world_cup_2026/presentation/providers/news_provider.dart';
import 'package:world_cup_2026/presentation/widgets/glassmorphism_card.dart';
import 'package:world_cup_2026/presentation/widgets/match_card.dart';
import 'package:world_cup_2026/presentation/widgets/section_header.dart';
import 'package:world_cup_2026/presentation/widgets/empty_state.dart';
import 'package:world_cup_2026/presentation/widgets/shimmer_loading.dart';
import 'package:world_cup_2026/presentation/widgets/team_flag.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> _onRefresh() async {
    await Future.wait([
      ref.read(matchListProvider.notifier).loadMatches(),
      ref.read(newsListProvider.notifier).loadNews(),
      ref.read(teamListProvider.notifier).loadTeams(),
    ]);
  }

  void _safeRefresh(ProviderBase provider) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.invalidate(provider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final liveMatches = ref.watch(liveMatchesProvider);
    final matchList = ref.watch(matchListProvider);
    final newsList = ref.watch(newsListProvider);
    final teamList = ref.watch(teamListProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 80,
            floating: true,
            pinned: true,
            backgroundColor: AppConstants.backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sports_soccer,
                    color: AppConstants.primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'World Cup 2026',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
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
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppConstants.primaryColor,
              backgroundColor: AppConstants.cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLiveMatchesSection(liveMatches),
                  const SizedBox(height: 24),
                  _buildUpcomingMatchesSection(matchList),
                  const SizedBox(height: 24),
                  _buildRecentResultsSection(matchList),
                  const SizedBox(height: 24),
                  _buildFeaturedNewsSection(newsList),
                  const SizedBox(height: 24),
                  _buildFeaturedTeamsSection(teamList),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMatchesSection(AsyncValue<List<MatchModel>> matches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Live Matches',
          showSeeAll: false,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: matches.when(
            data: (liveMatches) {
              if (liveMatches.isEmpty) {
                return const Center(
                  child: EmptyState(
                    icon: Icons.sports_soccer,
                    title: 'No live matches',
                    subtitle: 'Check back during match time',
                  ),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: liveMatches.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: MatchCard(
                      match: liveMatches[index],
                      onTap: () => context.push(
                          '/match/${liveMatches[index].id}'),
                    ),
                  ).animate().fadeIn(
                      delay: Duration(milliseconds: 100 * index),
                      duration: 300.ms);
                },
              );
            },
            loading: () => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: ShimmerLoading(pattern: ShimmerPattern.card),
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
        ),
      ],
    );
  }

  Widget _buildUpcomingMatchesSection(AsyncValue<List<MatchModel>> matches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Upcoming Matches',
          onSeeAll: () => context.push('/fixture'),
        ),
        const SizedBox(height: 12),
        matches.when(
          data: (allMatches) {
            final upcoming = allMatches
                .where((m) => m.status == 'scheduled')
                .take(5)
                .toList();
            if (upcoming.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: EmptyState(
                  icon: Icons.event,
                  title: 'No upcoming matches',
                  subtitle: 'Matches will appear here soon',
                ),
              );
            }
            return Column(
              children: List.generate(upcoming.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  child: MatchCard(
                    match: upcoming[index],
                    onTap: () =>
                        context.push('/match/${upcoming[index].id}'),
                  ),
                ).animate().fadeIn(
                    delay: Duration(milliseconds: 100 * index),
                    duration: 300.ms);
              }),
            );
          },
          loading: () => Column(
            children: List.generate(3, (index) {
              return const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ShimmerLoading(pattern: ShimmerPattern.card),
              );
            }),
          ),
          error: (_, __) => const Padding(
            padding: EdgeInsets.all(16),
            child: EmptyState(
              icon: Icons.wifi_off,
              title: 'Connection error',
              subtitle: 'Pull to refresh',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentResultsSection(AsyncValue<List<MatchModel>> matches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Recent Results',
          showSeeAll: false,
        ),
        const SizedBox(height: 12),
        matches.when(
          data: (allMatches) {
            final recent = allMatches
                .where((m) => m.status == 'finished' || m.status == 'ft')
                .take(5)
                .toList();
            if (recent.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: EmptyState(
                  icon: Icons.sports,
                  title: 'No recent results',
                  subtitle: 'Results will appear after matches',
                ),
              );
            }
            return Column(
              children: List.generate(recent.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  child: MatchCard(
                    match: recent[index],
                    onTap: () =>
                        context.push('/match/${recent[index].id}'),
                  ),
                ).animate().fadeIn(
                    delay: Duration(milliseconds: 100 * index),
                    duration: 300.ms);
              }),
            );
          },
          loading: () => Column(
            children: List.generate(3, (index) {
              return const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ShimmerLoading(pattern: ShimmerPattern.card),
              );
            }),
          ),
          error: (_, __) => const Padding(
            padding: EdgeInsets.all(16),
            child: EmptyState(
              icon: Icons.wifi_off,
              title: 'Connection error',
              subtitle: 'Pull to refresh',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedNewsSection(AsyncValue<List<NewsModel>> news) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Featured News',
          onSeeAll: () => context.push('/news'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: news.when(
            data: (newsList) {
              if (newsList.isEmpty) {
                return const Center(
                  child: EmptyState(
                    icon: Icons.newspaper,
                    title: 'No news available',
                    subtitle: 'Stay tuned for updates',
                  ),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: newsList.length.clamp(0, 5),
                itemBuilder: (context, index) {
                  final article = newsList[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () =>
                          context.push('/news/${article.id}'),
                      child: GlassmorphismCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                              child: article.imageUrl != null
                                  ? Image.network(
                                      article.imageUrl!,
                                      height: 120,
                                      width: 280,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, url, error) =>
                                          Container(
                                        height: 120,
                                        width: 280,
                                        color: AppConstants.cardColor,
                                        child: const Icon(Icons.error),
                                      ),
                                    )
                                  : Container(
                                      height: 120,
                                      width: 280,
                                      color: AppConstants.cardColor,
                                      child: const Icon(Icons.article,
                                          color: AppConstants.secondaryTextColor),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMM d, yyyy').format(article.publishedAt),
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
                      ),
                    ),
                  ).animate().fadeIn(
                      delay: Duration(milliseconds: 150 * index),
                      duration: 300.ms);
                },
              );
            },
            loading: () => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: ShimmerLoading(pattern: ShimmerPattern.card),
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
        ),
      ],
    );
  }

  Widget _buildFeaturedTeamsSection(AsyncValue<List<TeamModel>> teams) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Featured Teams',
          onSeeAll: () => context.push('/teams'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: teams.when(
            data: (teamList) {
              if (teamList.isEmpty) {
                return const Center(
                  child: EmptyState(
                    icon: Icons.flag,
                    title: 'No teams available',
                  ),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: teamList.length.clamp(0, 8),
                itemBuilder: (context, index) {
                  final team = teamList[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () =>
                          context.push('/team/${team.id}'),
                      child: GlassmorphismCard(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TeamFlag(
                              imageUrl: team.flag,
                              teamName: team.name,
                              size: 60,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              team.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            if (team.fifaRanking != null)
                              Text(
                                '#${team.fifaRanking}',
                                style: const TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(
                      delay: Duration(milliseconds: 100 * index),
                      duration: 300.ms);
                },
              );
            },
            loading: () => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: ShimmerLoading(pattern: ShimmerPattern.card),
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
        ),
      ],
    );
  }
}
