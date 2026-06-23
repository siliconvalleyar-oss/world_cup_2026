import 'dart:convert';

import 'package:world_cup_2026/core/services/hive_service.dart';
import 'package:world_cup_2026/data/models/group_model.dart';
import 'package:world_cup_2026/data/models/standing_model.dart';

abstract class StandingLocalDataSource {
  Future<List<GroupModel>> getCachedGroups();
  Future<void> cacheGroups(List<GroupModel> groups);
  Future<List<StandingModel>> getCachedStandings();
  Future<void> cacheStandings(List<StandingModel> standings);
}

class StandingLocalDataSourceImpl implements StandingLocalDataSource {
  final HiveService _hiveService;

  static const String _groupsKey = 'cached_groups';
  static const String _standingsKey = 'cached_standings';

  StandingLocalDataSourceImpl(this._hiveService);

  @override
  Future<List<GroupModel>> getCachedGroups() async {
    final data = await _hiveService.get<String>(_groupsKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list
        .map((json) => GroupModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheGroups(List<GroupModel> groups) async {
    final jsonList = groups.map((g) => g.toJson()).toList();
    await _hiveService.set<String>(
      _groupsKey,
      jsonEncode(jsonList),
      expiration: const Duration(minutes: 30),
    );
  }

  @override
  Future<List<StandingModel>> getCachedStandings() async {
    final data = await _hiveService.get<String>(_standingsKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list
        .map((json) => StandingModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheStandings(List<StandingModel> standings) async {
    final jsonList = standings.map((s) => s.toJson()).toList();
    await _hiveService.set<String>(
      _standingsKey,
      jsonEncode(jsonList),
      expiration: const Duration(minutes: 30),
    );
  }
}
