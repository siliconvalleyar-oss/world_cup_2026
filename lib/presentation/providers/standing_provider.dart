import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/group_model.dart';
import '../../data/models/standing_model.dart';
import 'api_provider.dart';

final groupListProvider = StateNotifierProvider<GroupListNotifier, AsyncValue<List<GroupModel>>>((ref) {
  return GroupListNotifier(ref);
});

final selectedGroupProvider = StateProvider<String?>((ref) => null);

final standingsProvider = Provider<AsyncValue<List<GroupModel>>>((ref) {
  return ref.watch(groupListProvider);
});

final groupStandingsProvider = FutureProvider.family<List<StandingModel>, String>((ref, groupId) async {
  final asyncGroups = ref.watch(groupListProvider);
  final groups = asyncGroups.when(
    data: (data) => data,
    loading: () => <GroupModel>[],
    error: (_, __) => <GroupModel>[],
  );
  try {
    final group = groups.firstWhere((g) => g.id == groupId || g.name == groupId);
    return group.teams;
  } catch (_) {
    return [];
  }
});

final filteredStandingsProvider = Provider<AsyncValue<List<GroupModel>>>((ref) {
  final selectedGroup = ref.watch(selectedGroupProvider);
  final groupsAsync = ref.watch(groupListProvider);
  if (selectedGroup == null) return groupsAsync;
  return groupsAsync.whenData(
    (groups) => groups.where((g) => g.id == selectedGroup || g.name == selectedGroup).toList(),
  );
});

class GroupListNotifier extends StateNotifier<AsyncValue<List<GroupModel>>> {
  final Ref ref;

  GroupListNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadGroups();
  }

  Future<void> loadGroups() async {
    try {
      final service = ref.read(theSportsDBServiceProvider);
      final groups = await service.getGroups();
      if (mounted) state = AsyncValue.data(groups);
    } catch (e, st) {
      if (mounted) state = AsyncValue.data([]);
    }
  }

  Future<void> refresh() async {
    await loadGroups();
  }
}
