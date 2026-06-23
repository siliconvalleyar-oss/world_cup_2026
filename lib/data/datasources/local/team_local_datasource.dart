import 'dart:convert';

import 'package:world_cup_2026/core/services/hive_service.dart';
import 'package:world_cup_2026/data/models/team_model.dart';

abstract class TeamLocalDataSource {
  Future<List<TeamModel>> getCachedTeams();
  Future<void> cacheTeams(List<TeamModel> teams);
}

class TeamLocalDataSourceImpl implements TeamLocalDataSource {
  final HiveService _hiveService;

  static const String _teamsKey = 'cached_teams';

  TeamLocalDataSourceImpl(this._hiveService);

  @override
  Future<List<TeamModel>> getCachedTeams() async {
    final data = await _hiveService.get<String>(_teamsKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list
        .map((json) => TeamModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheTeams(List<TeamModel> teams) async {
    final jsonList = teams.map((t) => t.toJson()).toList();
    await _hiveService.set<String>(
      _teamsKey,
      jsonEncode(jsonList),
      expiration: const Duration(minutes: 30),
    );
  }
}
