import 'package:world_cup_2026/core/network/dio_client.dart';
import 'package:world_cup_2026/data/models/match_model.dart';

abstract class MatchRemoteDataSource {
  Future<List<MatchModel>> getMatches({Map<String, dynamic>? queryParameters});
  Future<MatchModel> getMatchById(String id);
  Future<List<MatchModel>> getLiveMatches();
  Future<List<MatchModel>> getMatchesByGroup(String group);
}

class MatchRemoteDataSourceImpl implements MatchRemoteDataSource {
  final DioClient _dioClient;

  MatchRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<MatchModel>> getMatches({Map<String, dynamic>? queryParameters}) async {
    final response = await _dioClient.get<List<dynamic>>(
      '/matches',
      queryParameters: queryParameters,
    );
    if (response.data == null) return [];
    return (response.data as List)
        .map((json) => MatchModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MatchModel> getMatchById(String id) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/matches/$id',
    );
    return MatchModel.fromJson(response.data!);
  }

  @override
  Future<List<MatchModel>> getLiveMatches() async {
    final response = await _dioClient.get<List<dynamic>>(
      '/matches',
      queryParameters: {'status': 'live'},
    );
    if (response.data == null) return [];
    return (response.data as List)
        .map((json) => MatchModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MatchModel>> getMatchesByGroup(String group) async {
    final response = await _dioClient.get<List<dynamic>>(
      '/matches',
      queryParameters: {'group': group},
    );
    if (response.data == null) return [];
    return (response.data as List)
        .map((json) => MatchModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
