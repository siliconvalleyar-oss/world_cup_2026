import 'package:world_cup_2026/core/network/dio_client.dart';
import 'package:world_cup_2026/data/models/group_model.dart';
import 'package:world_cup_2026/data/models/standing_model.dart';

abstract class StandingRemoteDataSource {
  Future<List<GroupModel>> getGroups();
  Future<List<StandingModel>> getStandings();
}

class StandingRemoteDataSourceImpl implements StandingRemoteDataSource {
  final DioClient _dioClient;

  StandingRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<GroupModel>> getGroups() async {
    final response = await _dioClient.get<List<dynamic>>('/groups');
    if (response.data == null) return [];
    return (response.data as List)
        .map((json) => GroupModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<StandingModel>> getStandings() async {
    final response = await _dioClient.get<List<dynamic>>('/standings');
    if (response.data == null) return [];
    return (response.data as List)
        .map((json) => StandingModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
