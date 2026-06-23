import 'package:world_cup_2026/core/network/dio_client.dart';
import 'package:world_cup_2026/data/models/player_model.dart';

abstract class PlayerRemoteDataSource {
  Future<List<PlayerModel>> getPlayers({Map<String, dynamic>? queryParameters});
  Future<PlayerModel> getPlayerById(String id);
  Future<List<PlayerModel>> getPlayersByTeam(String teamId);
}

class PlayerRemoteDataSourceImpl implements PlayerRemoteDataSource {
  final DioClient _dioClient;

  PlayerRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<PlayerModel>> getPlayers({Map<String, dynamic>? queryParameters}) async {
    final response = await _dioClient.get<List<dynamic>>(
      '/players',
      queryParameters: queryParameters,
    );
    if (response.data == null) return [];
    return (response.data as List)
        .map((json) => PlayerModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PlayerModel> getPlayerById(String id) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/players/$id',
    );
    return PlayerModel.fromJson(response.data!);
  }

  @override
  Future<List<PlayerModel>> getPlayersByTeam(String teamId) async {
    final response = await _dioClient.get<List<dynamic>>(
      '/players',
      queryParameters: {'team_id': teamId},
    );
    if (response.data == null) return [];
    return (response.data as List)
        .map((json) => PlayerModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
