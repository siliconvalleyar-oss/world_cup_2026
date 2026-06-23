import 'dart:convert';

import 'package:world_cup_2026/core/services/hive_service.dart';
import 'package:world_cup_2026/data/models/match_model.dart';

abstract class MatchLocalDataSource {
  Future<List<MatchModel>> getCachedMatches();
  Future<void> cacheMatches(List<MatchModel> matches);
  Future<MatchModel?> getCachedMatch(String id);
  Future<void> cacheMatch(MatchModel match);
}

class MatchLocalDataSourceImpl implements MatchLocalDataSource {
  final HiveService _hiveService;

  static const String _matchesKey = 'cached_matches';

  MatchLocalDataSourceImpl(this._hiveService);

  @override
  Future<List<MatchModel>> getCachedMatches() async {
    final data = await _hiveService.get<String>(_matchesKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list
        .map((json) => MatchModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheMatches(List<MatchModel> matches) async {
    final jsonList = matches.map((m) => m.toJson()).toList();
    await _hiveService.set<String>(
      _matchesKey,
      jsonEncode(jsonList),
      expiration: const Duration(minutes: 15),
    );
  }

  @override
  Future<MatchModel?> getCachedMatch(String id) async {
    final data = await _hiveService.get<String>('match_$id');
    if (data == null) return null;
    return MatchModel.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  @override
  Future<void> cacheMatch(MatchModel match) async {
    await _hiveService.set<String>(
      'match_${match.id}',
      jsonEncode(match.toJson()),
      expiration: const Duration(minutes: 15),
    );
  }
}
