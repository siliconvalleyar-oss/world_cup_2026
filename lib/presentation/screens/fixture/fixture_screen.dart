import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/core/localization/app_localizations.dart';
import 'package:world_cup_2026/data/models/match_model.dart';
import 'package:world_cup_2026/data/models/group_model.dart';
import 'package:world_cup_2026/presentation/providers/match_provider.dart';
import 'package:world_cup_2026/presentation/providers/standing_provider.dart';
import 'package:world_cup_2026/presentation/providers/settings_provider.dart';
import 'package:world_cup_2026/presentation/widgets/match_card.dart';
import 'package:world_cup_2026/presentation/widgets/empty_state.dart';
import 'package:world_cup_2026/presentation/widgets/error_widget.dart';
import 'package:world_cup_2026/presentation/widgets/shimmer_loading.dart';
import 'package:intl/intl.dart';

enum FixtureFilter { byDate, byGroup }

class FixtureScreen extends ConsumerStatefulWidget {
  const FixtureScreen({super.key});
  @override
  ConsumerState<FixtureScreen> createState() => _FixtureScreenState();
}

class _FixtureScreenState extends ConsumerState<FixtureScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FixtureFilter _currentFilter = FixtureFilter.byDate;
  String? _selectedGroupId;
  DateTime? _selectedDate;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentFilter = _tabController.index == 0 ? FixtureFilter.byDate : FixtureFilter.byGroup;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() { _selectedGroupId = null; _selectedDate = null; _searchQuery = ''; _searchController.clear(); });
  }

  @override
  Widget build(BuildContext context) {
    final matchesAsync = ref.watch(matchListProvider);
    final groupsAsync = ref.watch(groupListProvider);
    final settings = ref.watch(settingsProvider);
    final isDark = settings.themeMode == ThemeMode.dark;
    final l10n = L10n.of(context);
    final bgColor = isDark ? AppConstants.backgroundColor : const Color(0xFFF5F5F5);
    final textColor = isDark ? Colors.white : const Color(0xFF0A0A0A);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(l10n.fixtures, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppConstants.primaryColor,
          labelColor: textColor,
          unselectedLabelColor: AppConstants.secondaryTextColor,
          tabs: [Tab(text: l10n.byDate), Tab(text: l10n.byGroup)],
        ),
        actions: [
          if (_selectedGroupId != null || _selectedDate != null)
            IconButton(icon: const Icon(Icons.clear, color: Colors.red), onPressed: _clearFilters),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(l10n, isDark),
          Expanded(
            child: matchesAsync.when(
              data: (matches) {
                final filteredMatches = _filterMatches(matches);
                if (filteredMatches.isEmpty) {
                  return EmptyState(
                    icon: Icons.event_busy, title: l10n.noMatchesFound, subtitle: l10n.tryAdjusting);
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.read(matchListProvider.notifier).loadMatches(),
                  color: AppConstants.primaryColor,
                  backgroundColor: AppConstants.cardColor,
                  child: _currentFilter == FixtureFilter.byDate
                      ? _buildByDateList(filteredMatches, l10n, isDark)
                      : _buildByGroupList(filteredMatches, groupsAsync, l10n, isDark),
                );
              },
              loading: () => ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ShimmerLoading(pattern: ShimmerPattern.card),
                ),
              ),
              error: (error, stack) => Center(
                child: AppErrorWidget(message: error.toString(), onRetry: () => ref.refresh(matchListProvider)),
              ),
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
          hintText: l10n.searchMatches,
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

  List<MatchModel> _filterMatches(List<MatchModel> matches) {
    return matches.where((match) {
      if (_selectedGroupId != null && match.group != _selectedGroupId) return false;
      if (_selectedDate != null) {
        if (match.date.year != _selectedDate!.year || match.date.month != _selectedDate!.month || match.date.day != _selectedDate!.day) return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return (match.homeTeam?.name.toLowerCase().contains(q) ?? false) ||
               (match.awayTeam?.name.toLowerCase().contains(q) ?? false) ||
               (match.venue?.name.toLowerCase().contains(q) ?? false);
      }
      return true;
    }).toList();
  }

  Widget _buildByDateList(List<MatchModel> matches, L10n l10n, bool isDark) {
    final groupedMatches = <String, List<MatchModel>>{};
    for (final match in matches) {
      final dateKey = DateFormat('yyyy-MM-dd').format(match.date);
      groupedMatches.putIfAbsent(dateKey, () => []).add(match);
    }
    final sortedDates = groupedMatches.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final dayMatches = groupedMatches[date]!;
        final dateTime = DateTime.parse(date);
        final isToday = DateUtils.isSameDay(dateTime, DateTime.now());
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: isToday ? AppConstants.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
              child: Row(children: [
                if (isToday) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppConstants.primaryColor, borderRadius: BorderRadius.circular(8)),
                  child: Text(l10n.today, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                if (isToday) const SizedBox(width: 8),
                Text(DateFormat('EEEE, MMMM d, yyyy').format(dateTime),
                  style: TextStyle(color: isToday ? AppConstants.primaryColor : (isDark ? Colors.white : const Color(0xFF0A0A0A)),
                    fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                Text(l10n.matchCount(dayMatches.length),
                  style: TextStyle(color: AppConstants.secondaryTextColor, fontSize: 12)),
              ]),
            ),
            ...List.generate(dayMatches.length, (matchIndex) {
              final match = dayMatches[matchIndex];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: MatchCard(match: match, onTap: () => context.push('/match/${match.id}')),
              ).animate().fadeIn(delay: Duration(milliseconds: 50 * matchIndex), duration: 300.ms);
            }),
          ],
        );
      },
    );
  }

  Widget _buildByGroupList(List<MatchModel> matches, AsyncValue<List<GroupModel>> groupsAsync, L10n l10n, bool isDark) {
    final bgColor = isDark ? AppConstants.cardColor : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0A0A0A);

    return groupsAsync.when(
      data: (groups) {
        final groupedMatches = <String, List<MatchModel>>{};
        for (final match in matches) {
          final groupId = match.group ?? 'Other';
          groupedMatches.putIfAbsent(groupId, () => []).add(match);
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            final groupMatches = groupedMatches[group.name] ?? [];
            return ExpansionTile(
              initiallyExpanded: index < 3,
              backgroundColor: bgColor,
              collapsedBackgroundColor: bgColor,
              title: Text('${l10n.group} ${group.name}',
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              iconColor: AppConstants.primaryColor,
              collapsedIconColor: textColor,
              children: groupMatches.isEmpty
                  ? [Padding(padding: const EdgeInsets.all(16),
                      child: Text(l10n.noScheduled,
                        style: TextStyle(color: AppConstants.secondaryTextColor)))]
                  : List.generate(groupMatches.length, (matchIndex) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: MatchCard(match: groupMatches[matchIndex],
                          onTap: () => context.push('/match/${groupMatches[matchIndex].id}')),
                      ).animate().fadeIn(delay: Duration(milliseconds: 50 * matchIndex), duration: 300.ms);
                    }),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor)),
      error: (error, stack) => Center(child: AppErrorWidget(
        message: error.toString(), onRetry: () => ref.refresh(groupListProvider))),
    );
  }
}
