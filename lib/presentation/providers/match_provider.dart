import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/match_model.dart';
import 'api_provider.dart';

final matchListProvider = StateNotifierProvider<MatchListNotifier, AsyncValue<List<MatchModel>>>((ref) {
  return MatchListNotifier(ref);
});

final matchDetailProvider = FutureProvider.family<MatchModel?, String>((ref, id) async {
  final asyncMatches = ref.watch(matchListProvider);
  final matches = asyncMatches.when(
    data: (data) => data,
    loading: () => <MatchModel>[],
    error: (_, __) => <MatchModel>[],
  );
  try {
    return matches.firstWhere((m) => m.id == id);
  } catch (_) {
    return null;
  }
});

final liveMatchesProvider = Provider<AsyncValue<List<MatchModel>>>((ref) {
  final matchesAsync = ref.watch(matchListProvider);
  return matchesAsync.whenData(
    (matches) => matches.where((m) => m.status == 'live' || m.status == 'in_play').toList(),
  );
});

final matchesByGroupProvider = FutureProvider.family<List<MatchModel>, String>((ref, group) async {
  final asyncMatches = ref.watch(matchListProvider);
  final matches = asyncMatches.when(
    data: (data) => data,
    loading: () => <MatchModel>[],
    error: (_, __) => <MatchModel>[],
  );
  return matches.where((m) => m.group == group).toList();
});

final matchSearchProvider = StateProvider<String>((ref) => '');

final filteredMatchProvider = Provider<AsyncValue<List<MatchModel>>>((ref) {
  final query = ref.watch(matchSearchProvider);
  final matchesAsync = ref.watch(matchListProvider);
  if (query.isEmpty) return matchesAsync;
  return matchesAsync.whenData(
    (matches) => matches.where((m) {
      final q = query.toLowerCase();
      final homeName = m.homeTeam?.name.toLowerCase() ?? '';
      final awayName = m.awayTeam?.name.toLowerCase() ?? '';
      return homeName.contains(q) || awayName.contains(q);
    }).toList(),
  );
});

final knockoutMatchesProvider = Provider<AsyncValue<List<MatchModel>>>((ref) {
  final matchesAsync = ref.watch(matchListProvider);
  return matchesAsync.whenData(
    (matches) => matches.where((m) => m.stage != 'group_stage').toList(),
  );
});

class MatchListNotifier extends StateNotifier<AsyncValue<List<MatchModel>>> {
  final Ref ref;

  MatchListNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadMatches();
  }

  Future<void> loadMatches() async {
    try {
      final service = ref.read(theSportsDBServiceProvider);
      final matches = await service.getMatches();
      if (mounted) state = AsyncValue.data(matches);
    } catch (e, st) {
      if (mounted) state = AsyncValue.data([]);
    }
  }

  Future<void> refresh() async {
    await loadMatches();
  }
}
