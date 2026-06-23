import 'package:dio/dio.dart';
import 'package:world_cup_2026/core/config/api_config.dart';
import 'package:world_cup_2026/data/models/match_model.dart';
import 'package:world_cup_2026/data/models/team_model.dart';
import 'package:world_cup_2026/data/models/group_model.dart';
import 'package:world_cup_2026/data/models/standing_model.dart';
import 'package:world_cup_2026/data/models/venue_model.dart';
import 'package:world_cup_2026/data/models/news_model.dart';

class TheSportsDBService {
  final Dio _dio;

  TheSportsDBService()
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ));

  Future<List<MatchModel>> getMatches() async {
    try {
      final response = await _dio.get(
        '/eventsseason.php',
        queryParameters: {
          'id': ApiConfig.worldCupLeagueId,
          's': ApiConfig.worldCupSeason,
        },
      );
      final data = response.data;
      if (data == null || data['events'] == null) return [];
      final events = data['events'] as List;
      return events.map((e) => _parseMatchFromEvent(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<MatchModel>> getNextMatches() async {
    try {
      final response = await _dio.get(
        '/eventsnextleague.php',
        queryParameters: {'id': ApiConfig.worldCupLeagueId},
      );
      final data = response.data;
      if (data == null || data['events'] == null) return [];
      final events = data['events'] as List;
      return events.map((e) => _parseMatchFromEvent(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<TeamModel>> getTeamsFromStandings() async {
    try {
      final response = await _dio.get(
        '/lookuptable.php',
        queryParameters: {
          'l': ApiConfig.worldCupLeagueId,
          's': ApiConfig.worldCupSeason,
        },
      );
      final data = response.data;
      if (data == null || data['table'] == null) return [];
      final table = data['table'] as List;

      final Map<String, Map<String, dynamic>> teamsMap = {};
      for (final row in table) {
        final teamId = row['idTeam']?.toString() ?? '';
        if (teamId.isEmpty) continue;
        if (!teamsMap.containsKey(teamId)) {
          teamsMap[teamId] = {
            'id': teamId,
            'name': row['strTeam']?.toString() ?? '',
            'flag': _cleanBadgeUrl(row['strBadge']?.toString()),
            'group': _extractGroupLetter(row['strGroup']?.toString()),
          };
        }
      }
      return teamsMap.values
          .map((t) => TeamModel(
                id: t['id'] as String,
                name: t['name'] as String,
                flag: t['flag'] as String?,
                group: t['group'] as String?,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<GroupModel>> getGroups() async {
    try {
      final response = await _dio.get(
        '/lookuptable.php',
        queryParameters: {
          'l': ApiConfig.worldCupLeagueId,
          's': ApiConfig.worldCupSeason,
        },
      );
      final data = response.data;
      if (data == null || data['table'] == null) return [];
      final table = data['table'] as List;

      final Map<String, List<StandingModel>> groupsMap = {};
      for (final row in table) {
        final groupLabel = row['strGroup']?.toString() ?? 'Other';
        final groupLetter = _extractGroupLetter(groupLabel) ?? groupLabel;

        final standing = StandingModel(
          teamId: row['idTeam']?.toString() ?? '',
          team: TeamModel(
            id: row['idTeam']?.toString() ?? '',
            name: row['strTeam']?.toString() ?? '',
            flag: _cleanBadgeUrl(row['strBadge']?.toString()),
          ),
          played: _parseInt(row['intPlayed']),
          won: _parseInt(row['intWin']),
          drawn: _parseInt(row['intDraw']),
          lost: _parseInt(row['intLoss']),
          goalsFor: _parseInt(row['intGoalsFor']),
          goalsAgainst: _parseInt(row['intGoalsAgainst']),
          goalDifference: _parseInt(row['intGoalDifference']),
          points: _parseInt(row['intPoints']),
          position: _parseInt(row['intRank']),
        );

        groupsMap.putIfAbsent(groupLetter, () => []);
        groupsMap[groupLetter]!.add(standing);
      }

      final groups = <GroupModel>[];
      final sortedKeys = groupsMap.keys.toList()..sort();
      for (final key in sortedKeys) {
        final standings = groupsMap[key]!;
        standings.sort((a, b) {
          final cmp = b.points.compareTo(a.points);
          if (cmp != 0) return cmp;
          return b.goalDifference.compareTo(a.goalDifference);
        });
        groups.add(GroupModel(
          id: key,
          name: key,
          teams: standings,
        ));
      }
      return groups;
    } catch (e) {
      return [];
    }
  }

  Future<List<NewsModel>> getNews() async {
    try {
      final response = await _dio.get(
        '/eventspastleague.php',
        queryParameters: {'id': ApiConfig.worldCupLeagueId},
      );
      final data = response.data;
      if (data == null || data['events'] == null) return [];
      final events = data['events'] as List;

      return events.take(20).map((e) {
        final eventName = e['strEvent']?.toString() ?? '';
        final homeTeam = e['strHomeTeam']?.toString() ?? '';
        final awayTeam = e['strAwayTeam']?.toString() ?? '';
        final homeScore = e['intHomeScore']?.toString() ?? '0';
        final awayScore = e['intAwayScore']?.toString() ?? '0';
        final dateStr = e['dateEvent']?.toString() ?? '';
        final venue = e['strVenue']?.toString() ?? '';
        final thumb = e['strThumb']?.toString();
        final video = e['strVideo']?.toString();
        final description = e['strDescriptionEN']?.toString() ?? '';

        DateTime publishedAt;
        try {
          publishedAt = DateTime.parse(dateStr);
        } catch (_) {
          publishedAt = DateTime.now();
        }

        return NewsModel(
          id: e['idEvent']?.toString() ?? '',
          title: '$eventName - $homeTeam $homeScore vs $awayScore $awayTeam',
          summary: description.isNotEmpty
              ? description
              : '$homeTeam $homeScore - $awayScore $awayTeam at $venue',
          content: description,
          imageUrl: thumb,
          source: 'FIFA World Cup 2026',
          publishedAt: publishedAt,
          url: video,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<VenueModel>> getVenues() async {
    try {
      final response = await _dio.get(
        '/eventsseason.php',
        queryParameters: {
          'id': ApiConfig.worldCupLeagueId,
          's': ApiConfig.worldCupSeason,
        },
      );
      final data = response.data;
      if (data == null || data['events'] == null) return [];
      final events = data['events'] as List;

      final Map<String, Map<String, dynamic>> venuesMap = {};
      for (final event in events) {
        final venueName = event['strVenue']?.toString() ?? '';
        if (venueName.isEmpty) continue;
        if (!venuesMap.containsKey(venueName)) {
          venuesMap[venueName] = {
            'id': event['idVenue']?.toString() ?? venueName,
            'name': venueName,
            'city': event['strCity']?.toString() ?? '',
            'country': event['strCountry']?.toString() ?? '',
            'image': event['strThumb']?.toString(),
          };
        }
      }
      return venuesMap.values
          .map((v) => VenueModel(
                id: v['id'] as String,
                name: v['name'] as String,
                city: v['city'] as String,
                country: v['country'] as String?,
                image: v['image'] as String?,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  MatchModel _parseMatchFromEvent(Map<String, dynamic> e) {
    final homeTeamName = e['strHomeTeam']?.toString() ?? '';
    final awayTeamName = e['strAwayTeam']?.toString() ?? '';
    final status = _mapStatus(e['strStatus']?.toString());

    DateTime matchDate;
    try {
      final timestamp = e['strTimestamp']?.toString();
      if (timestamp != null && timestamp.isNotEmpty) {
        matchDate = DateTime.parse(timestamp);
      } else {
        matchDate = DateTime.parse(e['dateEvent']?.toString() ?? '2026-06-11');
      }
    } catch (_) {
      matchDate = DateTime(2026, 6, 11);
    }

    return MatchModel(
      id: e['idEvent']?.toString() ?? '',
      homeTeamId: e['idHomeTeam']?.toString() ?? '',
      awayTeamId: e['idAwayTeam']?.toString() ?? '',
      homeTeam: TeamModel(
        id: e['idHomeTeam']?.toString() ?? '',
        name: homeTeamName,
        flag: _cleanBadgeUrl(e['strHomeTeamBadge']?.toString()),
      ),
      awayTeam: TeamModel(
        id: e['idAwayTeam']?.toString() ?? '',
        name: awayTeamName,
        flag: _cleanBadgeUrl(e['strAwayTeamBadge']?.toString()),
      ),
      homeScore: _parseInt(e['intHomeScore']),
      awayScore: _parseInt(e['intAwayScore']),
      status: status,
      matchday: _parseInt(e['intRound']),
      group: e['strGroup']?.toString(),
      venue: VenueModel(
        id: e['idVenue']?.toString() ?? '',
        name: e['strVenue']?.toString() ?? '',
        city: e['strCity']?.toString() ?? '',
        country: e['strCountry']?.toString(),
      ),
      date: matchDate,
      time: e['strTimeLocal']?.toString() ?? e['strTime']?.toString(),
    );
  }

  String _mapStatus(String? apiStatus) {
    if (apiStatus == null) return 'scheduled';
    switch (apiStatus.toUpperCase()) {
      case 'FT':
        return 'finished';
      case 'NS':
        return 'scheduled';
      case '1H':
      case '2H':
      case 'HT':
      case 'ET':
      case 'P':
      case 'LIVE':
        return 'live';
      case 'PST':
        return 'postponed';
      default:
        return 'scheduled';
    }
  }

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  String? _cleanBadgeUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.contains('/tiny')) {
      return url.replaceAll('/tiny', '');
    }
    return url;
  }

  String? _extractGroupLetter(String? groupStr) {
    if (groupStr == null || groupStr.isEmpty) return null;
    final match = RegExp(r'([A-L])').firstMatch(groupStr);
    return match?.group(1);
  }
}
