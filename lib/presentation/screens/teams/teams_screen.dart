import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/data/models/team_model.dart';
import 'package:world_cup_2026/presentation/providers/team_provider.dart';
import 'package:world_cup_2026/presentation/widgets/glassmorphism_card.dart';
import 'package:world_cup_2026/presentation/widgets/team_flag.dart';
import 'package:world_cup_2026/presentation/widgets/empty_state.dart';
import 'package:world_cup_2026/presentation/widgets/error_widget.dart';
import 'package:world_cup_2026/presentation/widgets/shimmer_loading.dart';

class TeamsScreen extends ConsumerStatefulWidget {
  const TeamsScreen({super.key});

  @override
  ConsumerState<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends ConsumerState<TeamsScreen> {
  String _searchQuery = '';
  String? _selectedGroup;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamsAsync = ref.watch(teamListProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        title: const Text(
          'Teams',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildGroupFilter(),
          Expanded(
            child: teamsAsync.when(
              data: (teams) {
                final filteredTeams = _filterTeams(teams);
                if (filteredTeams.isEmpty) {
                  return const EmptyState(
                    icon: Icons.flag,
                    title: 'No teams found',
                    subtitle: 'Try adjusting your search',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(teamListProvider.notifier).loadTeams();
                  },
                  color: AppConstants.primaryColor,
                  backgroundColor: AppConstants.cardColor,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredTeams.length,
                    itemBuilder: (context, index) {
                      final team = filteredTeams[index];
                      return _buildTeamCard(team, index);
                    },
                  ),
                );
              },
              loading: () => GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return const ShimmerLoading(
                    pattern: ShimmerPattern.card,
                  );
                },
              ),
              error: (error, stack) => Center(
                child: AppErrorWidget(
                  message: error.toString(),
                  onRetry: () => ref.refresh(teamListProvider),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search teams...',
          hintStyle: const TextStyle(color: AppConstants.secondaryTextColor),
          prefixIcon:
              const Icon(Icons.search, color: AppConstants.primaryColor),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear,
                      color: AppConstants.secondaryTextColor),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: AppConstants.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppConstants.primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 13,
        itemBuilder: (context, index) {
          final group = index == 0 ? null : String.fromCharCode(64 + index);
          final isSelected = _selectedGroup == group;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(
                group ?? 'All',
                style: TextStyle(
                  color: isSelected ? Colors.white : AppConstants.secondaryTextColor,
                  fontSize: 12,
                ),
              ),
              selectedColor: AppConstants.primaryColor,
              backgroundColor: AppConstants.cardColor,
              checkmarkColor: Colors.white,
              onSelected: (selected) {
                setState(() {
                  _selectedGroup = selected ? group : null;
                });
              },
            ),
          );
        },
      ),
    );
  }

  List<TeamModel> _filterTeams(List<TeamModel> teams) {
    return teams.where((team) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!team.name.toLowerCase().contains(query) &&
            !(team.code?.toLowerCase().contains(query) ?? false)) {
          return false;
        }
      }
      if (_selectedGroup != null && team.group != _selectedGroup) {
        return false;
      }
      return true;
    }).toList();
  }

  Widget _buildTeamCard(TeamModel team, int index) {
    return GestureDetector(
      onTap: () => context.push('/team/${team.id}'),
      child: GlassmorphismCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TeamFlag(imageUrl: team.flag, teamName: team.name, size: 70),
            const SizedBox(height: 12),
            Text(
              team.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            if (team.fifaRanking != null)
              Text(
                '#${team.fifaRanking}',
                style: const TextStyle(
                  color: AppConstants.primaryColor,
                  fontSize: 12,
                ),
              ),
            const SizedBox(height: 4),
            if (team.group != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppConstants.secondaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Group ${team.group}',
                  style: const TextStyle(
                    color: AppConstants.secondaryColor,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(
        delay: Duration(milliseconds: 50 * index), duration: 300.ms);
  }
}
