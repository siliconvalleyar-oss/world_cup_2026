import 'package:world_cup_2026/core/network/dio_client.dart';
import 'package:world_cup_2026/data/models/team_model.dart';

abstract class TeamRemoteDataSource {
  Future<List<TeamModel>> getTeams({Map<String, dynamic>? queryParameters});
  Future<TeamModel> getTeamById(String id);
}

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource {
  final DioClient _dioClient;

  TeamRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<TeamModel>> getTeams({Map<String, dynamic>? queryParameters}) async {
    final response = await _dioClient.get<List<dynamic>>(
      '/teams',
      queryParameters: queryParameters,
    );
    if (response.data == null) return [];
    return (response.data as List)
        .map((json) => TeamModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TeamModel> getTeamById(String id) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/teams/$id',
    );
    return TeamModel.fromJson(response.data!);
  }
}
