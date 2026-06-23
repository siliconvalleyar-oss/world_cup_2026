import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/venue_model.dart';
import 'api_provider.dart';

final stadiumListProvider = StateNotifierProvider<StadiumListNotifier, AsyncValue<List<VenueModel>>>((ref) {
  return StadiumListNotifier(ref);
});

final stadiumDetailProvider = FutureProvider.family<VenueModel?, String>((ref, id) async {
  final asyncStadiums = ref.watch(stadiumListProvider);
  final stadiums = asyncStadiums.when(
    data: (data) => data,
    loading: () => <VenueModel>[],
    error: (_, __) => <VenueModel>[],
  );
  try {
    return stadiums.firstWhere((s) => s.id == id);
  } catch (_) {
    return null;
  }
});

final stadiumSearchProvider = StateProvider<String>((ref) => '');

final filteredStadiumProvider = Provider<AsyncValue<List<VenueModel>>>((ref) {
  final query = ref.watch(stadiumSearchProvider);
  final stadiumsAsync = ref.watch(stadiumListProvider);
  if (query.isEmpty) return stadiumsAsync;
  return stadiumsAsync.whenData(
    (stadiums) => stadiums.where((s) {
      final q = query.toLowerCase();
      final name = s.name.toLowerCase();
      final city = s.city.toLowerCase();
      return name.contains(q) || city.contains(q);
    }).toList(),
  );
});

class StadiumListNotifier extends StateNotifier<AsyncValue<List<VenueModel>>> {
  final Ref ref;

  StadiumListNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadStadiums();
  }

  Future<void> loadStadiums() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(theSportsDBServiceProvider);
      final venues = await service.getVenues();
      state = AsyncValue.data(venues);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await loadStadiums();
  }
}
