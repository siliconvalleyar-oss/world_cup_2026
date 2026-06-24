import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/data/models/player_model.dart';
import 'package:world_cup_2026/presentation/providers/player_provider.dart';
import 'package:world_cup_2026/presentation/providers/team_provider.dart';
import 'package:world_cup_2026/presentation/widgets/glassmorphism_card.dart';
import 'package:world_cup_2026/presentation/widgets/empty_state.dart';
import 'package:world_cup_2026/presentation/widgets/shimmer_loading.dart';

class PlayersScreen extends ConsumerStatefulWidget {
  const PlayersScreen({super.key});

  @override
  ConsumerState<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends ConsumerState<PlayersScreen> {
  String _searchQuery = '';
  String? _selectedPosition;
  String? _selectedTeamId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playersAsync = ref.watch(playerListProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        title: const Text(
          'Players',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilters(),
          Expanded(
            child: playersAsync.when(
              data: (players) {
                final filteredPlayers = _filterPlayers(players);
                if (filteredPlayers.isEmpty) {
                  return const EmptyState(
                    icon: Icons.person,
                    title: 'No players found',
                    subtitle: 'Try adjusting your filters',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(playerListProvider.notifier).loadPlayers();
                  },
                  color: AppConstants.primaryColor,
                  backgroundColor: AppConstants.cardColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredPlayers.length,
                    itemBuilder: (context, index) {
                      final player = filteredPlayers[index];
                      return _buildPlayerCard(player, index);
                    },
                  ),
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
                child: EmptyState(icon: Icons.wifi_off, title: 'Connection error', subtitle: 'Pull to refresh'),
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
          hintText: 'Search players...',
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

  Widget _buildFilters() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildPositionFilter(),
          const SizedBox(width: 8),
          _buildTeamFilter(),
        ],
      ),
    );
  }

  Widget _buildPositionFilter() {
    final positions = ['All', 'Goalkeeper', 'Defender', 'Midfielder', 'Forward'];
    return DropdownButton<String>(
      value: _selectedPosition ?? 'All',
      dropdownColor: AppConstants.cardColor,
      style: const TextStyle(color: Colors.white),
      underline: const SizedBox(),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      items: positions.map((position) {
        return DropdownMenuItem(
          value: position,
          child: Text(position),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedPosition = value == 'All' ? null : value;
        });
      },
    );
  }

  Widget _buildTeamFilter() {
    final teamsAsync = ref.watch(teamListProvider);
    return teamsAsync.when(
      data: (teams) {
        return DropdownButton<String>(
          value: _selectedTeamId,
          dropdownColor: AppConstants.cardColor,
          style: const TextStyle(color: Colors.white),
          underline: const SizedBox(),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          hint: const Text('All Teams',
              style: TextStyle(color: AppConstants.secondaryTextColor)),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('All Teams'),
            ),
            ...teams.map((team) => DropdownMenuItem(
                  value: team.id,
                  child: Text(team.name),
                )),
          ],
          onChanged: (value) {
            setState(() => _selectedTeamId = value);
          },
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }

  List<PlayerModel> _filterPlayers(List<PlayerModel> players) {
    return players.where((player) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!player.name.toLowerCase().contains(query)) {
          return false;
        }
      }
      if (_selectedPosition != null && player.position != _selectedPosition) {
        return false;
      }
      if (_selectedTeamId != null && player.teamId != _selectedTeamId) {
        return false;
      }
      return true;
    }).toList();
  }

  Widget _buildPlayerCard(PlayerModel player, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassmorphismCard(
        child: InkWell(
          onTap: () => context.push('/player/${player.id}'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipOval(
                  child: player.photo != null && player.photo!.isNotEmpty
                      ? Image.network(
                          player.photo!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, url, error) => Container(
                            width: 60,
                            height: 60,
                            color: AppConstants.cardColor,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          color: AppConstants.cardColor,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            player.position ?? '',
                            style: const TextStyle(
                              color: AppConstants.primaryColor,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (player.teamName != null)
                            Expanded(
                              child: Text(
                                player.teamName!,
                                style: const TextStyle(
                                  color: AppConstants.secondaryTextColor,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (player.goals > 0)
                      _buildStatBadge('${player.goals}', 'Goals', Colors.green),
                    if (player.assists > 0)
                      _buildStatBadge(
                          '${player.assists}', 'Assists', Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(
        delay: Duration(milliseconds: 50 * index), duration: 300.ms);
  }

  Widget _buildStatBadge(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.7),
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}
