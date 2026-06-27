import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/player_model.dart';
import '../../data/datasources/local/world_cup_players_data.dart';
import 'api_provider.dart';

final playerListProvider = StateNotifierProvider<PlayerListNotifier, AsyncValue<List<PlayerModel>>>((ref) {
  return PlayerListNotifier();
});

final playerDetailProvider = FutureProvider.family<PlayerModel?, String>((ref, id) async {
  final asyncPlayers = ref.watch(playerListProvider);
  final players = asyncPlayers.when(
    data: (data) => data,
    loading: () => <PlayerModel>[],
    error: (_, __) => <PlayerModel>[],
  );
  try {
    return players.firstWhere((p) => p.id == id);
  } catch (_) {
    return WorldCupPlayersData.getById(id);
  }
});

final playersByTeamProvider = FutureProvider.family<List<PlayerModel>, String>((ref, teamId) async {
  final asyncPlayers = ref.watch(playerListProvider);
  final players = asyncPlayers.when(
    data: (data) => data,
    loading: () => <PlayerModel>[],
    error: (_, __) => <PlayerModel>[],
  );
  final apiPlayers = players.where((p) => p.teamId == teamId).toList();
  if (apiPlayers.isNotEmpty) return apiPlayers;
  return WorldCupPlayersData.getByTeam(teamId);
});

final playerSearchProvider = StateProvider<String>((ref) => '');

final filteredPlayerProvider = Provider<AsyncValue<List<PlayerModel>>>((ref) {
  final query = ref.watch(playerSearchProvider);
  final playersAsync = ref.watch(playerListProvider);
  if (query.isEmpty) return playersAsync;
  return playersAsync.whenData(
    (players) => players.where((p) {
      final q = query.toLowerCase();
      final name = p.name.toLowerCase();
      final teamName = p.teamName?.toLowerCase() ?? '';
      final position = p.position?.toLowerCase() ?? '';
      return name.contains(q) || teamName.contains(q) || position.contains(q);
    }).toList(),
  );
});

final topScorersProvider = Provider<AsyncValue<List<PlayerModel>>>((ref) {
  final playersAsync = ref.watch(playerListProvider);
  return playersAsync.whenData(
    (players) {
      final sorted = List<PlayerModel>.from(players)
        ..sort((a, b) => b.goals.compareTo(a.goals));
      return sorted.take(10).toList();
    },
  );
});

final topAssistsProvider = Provider<AsyncValue<List<PlayerModel>>>((ref) {
  final playersAsync = ref.watch(playerListProvider);
  return playersAsync.whenData(
    (players) {
      final sorted = List<PlayerModel>.from(players)
        ..sort((a, b) => b.assists.compareTo(a.assists));
      return sorted.take(10).toList();
    },
  );
});

final apiTopScorersProvider = FutureProvider<List<PlayerModel>>((ref) async {
  final service = ref.read(theSportsDBServiceProvider);
  return service.getTopScorers();
});

class PlayerListNotifier extends StateNotifier<AsyncValue<List<PlayerModel>>> {
  PlayerListNotifier() : super(const AsyncValue.loading()) {
    loadPlayers();
  }

  Future<void> loadPlayers() async {
    try {
      final players = WorldCupPlayersData.getAll();
      if (mounted) state = AsyncValue.data(players);
    } catch (e, st) {
      if (mounted) state = AsyncValue.data([]);
    }
  }

  Future<void> refresh() async {
    await loadPlayers();
  }
}
