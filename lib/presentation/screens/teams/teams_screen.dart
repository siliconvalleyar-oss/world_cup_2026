import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/core/localization/app_localizations.dart';
import 'package:world_cup_2026/data/models/team_model.dart';
import 'package:world_cup_2026/presentation/providers/team_provider.dart';
import 'package:world_cup_2026/presentation/providers/settings_provider.dart';
import 'package:world_cup_2026/presentation/widgets/glassmorphism_card.dart';
import 'package:world_cup_2026/presentation/widgets/team_flag.dart';
import 'package:world_cup_2026/presentation/widgets/empty_state.dart';
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
    final settings = ref.watch(settingsProvider);
    final isDark = settings.themeMode == ThemeMode.dark;
    final l10n = L10n.of(context);
    final bgColor = isDark ? AppConstants.backgroundColor : const Color(0xFFF5F5F5);
    final textColor = isDark ? Colors.white : const Color(0xFF0A0A0A);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(l10n.tabTeams, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          _buildSearchBar(l10n, isDark),
          _buildGroupFilter(l10n, isDark),
          Expanded(
            child: teamsAsync.when(
              data: (teams) {
                final filteredTeams = _filterTeams(teams);
                if (filteredTeams.isEmpty) {
                  return EmptyState(icon: Icons.flag, title: l10n.noTeamsFound, subtitle: '');
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.read(teamListProvider.notifier).loadTeams(),
                  color: AppConstants.primaryColor,
                  backgroundColor: AppConstants.cardColor,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.85, crossAxisSpacing: 12, mainAxisSpacing: 12),
                    itemCount: filteredTeams.length,
                    itemBuilder: (context, index) => _buildTeamCard(filteredTeams[index], index, isDark),
                  ),
                );
              },
              loading: () => GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.85, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemCount: 8,
                itemBuilder: (context, index) => const ShimmerLoading(pattern: ShimmerPattern.card),
              ),
              error: (_, __) => Center(
                child: EmptyState(icon: Icons.wifi_off, title: l10n.connectionError, subtitle: l10n.pullToRefresh)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(L10n l10n, bool isDark) {
    final fillColor = isDark ? AppConstants.cardColor : const Color(0xFFEEEEEE);
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0A0A0A)),
        decoration: InputDecoration(
          hintText: l10n.searchTeams,
          hintStyle: TextStyle(color: AppConstants.secondaryTextColor),
          prefixIcon: Icon(Icons.search, color: AppConstants.primaryColor),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(icon: Icon(Icons.clear, color: AppConstants.secondaryTextColor),
                  onPressed: () { _searchController.clear(); setState(() => _searchQuery = ''); })
              : null,
          filled: true, fillColor: fillColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppConstants.primaryColor)),
        ),
      ),
    );
  }

  Widget _buildGroupFilter(L10n l10n, bool isDark) {
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
              label: Text(group ?? l10n.all,
                style: TextStyle(color: isSelected ? Colors.white : AppConstants.secondaryTextColor, fontSize: 12)),
              selectedColor: AppConstants.primaryColor,
              backgroundColor: isDark ? AppConstants.cardColor : const Color(0xFFEEEEEE),
              checkmarkColor: Colors.white,
              onSelected: (selected) => setState(() { _selectedGroup = selected ? group : null; }),
            ),
          );
        },
      ),
    );
  }

  List<TeamModel> _filterTeams(List<TeamModel> teams) {
    return teams.where((team) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!team.name.toLowerCase().contains(q) && !(team.code?.toLowerCase().contains(q) ?? false)) return false;
      }
      if (_selectedGroup != null && team.group != _selectedGroup) return false;
      return true;
    }).toList();
  }

  Widget _buildTeamCard(TeamModel team, int index, bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF0A0A0A);
    return GestureDetector(
      onTap: () => context.push('/team/${team.id}'),
      child: GlassmorphismCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TeamFlag(imageUrl: team.flag, teamName: team.name, size: 70),
            const SizedBox(height: 12),
            Text(team.name,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            if (team.fifaRanking != null)
              Text('#${team.fifaRanking}',
                style: const TextStyle(color: AppConstants.primaryColor, fontSize: 12)),
            const SizedBox(height: 4),
            if (team.group != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppConstants.secondaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8)),
                child: Text('${L10n.of(context).group} ${team.group}',
                  style: const TextStyle(color: AppConstants.secondaryColor, fontSize: 10)),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 50 * index), duration: 300.ms);
  }
}
