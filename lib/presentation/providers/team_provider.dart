import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/team_model.dart';
import 'api_provider.dart';

final teamListProvider = StateNotifierProvider<TeamListNotifier, AsyncValue<List<TeamModel>>>((ref) {
  return TeamListNotifier(ref);
});

final teamDetailProvider = FutureProvider.family<TeamModel?, String>((ref, id) async {
  final asyncTeams = ref.watch(teamListProvider);
  final teams = asyncTeams.when(
    data: (data) => data,
    loading: () => <TeamModel>[],
    error: (_, __) => <TeamModel>[],
  );
  try {
    return teams.firstWhere((t) => t.id == id);
  } catch (_) {
    return null;
  }
});

final teamSearchProvider = StateProvider<String>((ref) => '');

final filteredTeamProvider = Provider<AsyncValue<List<TeamModel>>>((ref) {
  final query = ref.watch(teamSearchProvider);
  final teamsAsync = ref.watch(teamListProvider);
  if (query.isEmpty) return teamsAsync;
  return teamsAsync.whenData(
    (teams) => teams.where((t) {
      final q = query.toLowerCase();
      final name = t.name.toLowerCase();
      final code = t.code?.toLowerCase() ?? '';
      return name.contains(q) || code.contains(q);
    }).toList(),
  );
});

class TeamListNotifier extends StateNotifier<AsyncValue<List<TeamModel>>> {
  final Ref ref;

  TeamListNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadTeams();
  }

  Future<void> loadTeams() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(theSportsDBServiceProvider);
      final teams = await service.getTeamsFromStandings();
      state = AsyncValue.data(teams);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await loadTeams();
  }
}
