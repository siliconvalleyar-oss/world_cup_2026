import 'package:dio/dio.dart';
import 'package:world_cup_2026/core/config/api_config.dart';
import 'package:world_cup_2026/data/models/match_model.dart';
import 'package:world_cup_2026/data/models/team_model.dart';
import 'package:world_cup_2026/data/models/group_model.dart';
import 'package:world_cup_2026/data/models/standing_model.dart';
import 'package:world_cup_2026/data/models/venue_model.dart';
import 'package:world_cup_2026/data/models/news_model.dart';
import 'package:world_cup_2026/data/datasources/local/world_cup_local_data.dart';
import 'package:world_cup_2026/data/datasources/local/world_cup_fixtures.dart';

class TheSportsDBService {
  final Dio _dio;

  TheSportsDBService()
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ));

  Future<List<MatchModel>> getMatches() async {
    List<MatchModel> apiMatches = [];
    try {
      final response = await _dio.get(
        '/eventsseason.php',
        queryParameters: {
          'id': ApiConfig.worldCupLeagueId,
          's': ApiConfig.worldCupSeason,
        },
      );
      final data = response.data;
      if (data != null && data['events'] != null) {
        final events = data['events'] as List;
        apiMatches = events.map((e) => _parseMatchFromEvent(e)).toList();
      }
    } catch (_) {}

    final localMatches = WorldCupFixtures.getGroupStageMatches();
    print('WC2026: Local matches loaded: ${localMatches.length}');

    final Map<String, MatchModel> merged = {};
    for (final m in localMatches) {
      merged[m.id] = m;
    }
    for (final m in apiMatches) {
      if (m.id.isNotEmpty) {
        String? matchKey;
        for (final entry in merged.entries) {
          final local = entry.value;
          if ((local.homeTeamId == m.homeTeamId && local.awayTeamId == m.awayTeamId) ||
              (local.homeTeamId == m.awayTeamId && local.awayTeamId == m.homeTeamId)) {
            matchKey = entry.key;
            break;
          }
        }
        if (matchKey != null) {
          merged[matchKey] = _mergeMatch(merged[matchKey]!, m);
        }
      }
    }

    final result = merged.values.toList()..sort((a, b) => b.date.compareTo(a.date));
    print('WC2026: Total matches after merge: ${result.length}');
    return result;
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
    final localTeams = WorldCupLocalData.getTeams();
    print('WC2026: Local teams loaded: ${localTeams.length} (using local as source of truth)');
    return localTeams;
  }

  Future<List<GroupModel>> getGroups() async {
    final localGroups = WorldCupLocalData.getGroups();
    print('WC2026: Local groups loaded: ${localGroups.length} (using local as source of truth)');
    for (final g in localGroups) {
      print('WC2026:   Group ${g.name}: ${g.teams.length} teams');
    }
    return localGroups;
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

      if (events.isEmpty) return _getLocalNews();

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
      return _getLocalNews();
    }
  }

  List<NewsModel> _getLocalNews() {
    return [
      NewsModel(
        id: 'news_1',
        title: 'FIFA World Cup 2026 kicks off in Mexico',
        summary: 'The biggest World Cup in history begins with 48 teams competing across 3 host nations.',
        content: 'The 2026 FIFA World Cup has officially begun, with matches taking place across stadiums in the United States, Canada, and Mexico. This is the first World Cup to feature 48 teams.',
        source: 'FIFA World Cup 2026',
        publishedAt: DateTime(2026, 6, 11),
      ),
      NewsModel(
        id: 'news_2',
        title: 'Record-breaking attendance expected',
        summary: 'Over 5 million fans expected to attend matches across 16 venues.',
        content: 'With 16 world-class stadiums hosting matches, organizers anticipate record-breaking attendance figures throughout the tournament.',
        source: 'FIFA World Cup 2026',
        publishedAt: DateTime(2026, 6, 12),
      ),
      NewsModel(
        id: 'news_3',
        title: 'Group stage matchday 1 highlights',
        summary: 'Exciting opening matches deliver thrilling football across all groups.',
        content: 'The first matchday of the group stage delivered incredible action, with several teams making strong statements in their opening fixtures.',
        source: 'FIFA World Cup 2026',
        publishedAt: DateTime(2026, 6, 13),
      ),
      NewsModel(
        id: 'news_4',
        title: 'VAR technology enhanced for 2026',
        summary: 'New semi-automated offside technology brings faster and more accurate decisions.',
        content: 'FIFA has implemented advanced VAR technology for the 2026 World Cup, featuring semi-automated offside detection and faster review processes.',
        source: 'FIFA World Cup 2026',
        publishedAt: DateTime(2026, 6, 14),
      ),
      NewsModel(
        id: 'news_5',
        title: 'Tournament reaches halfway point',
        summary: 'Group stage enters matchday 2 as qualification battles heat up.',
        content: 'The group stage is in full swing with matchday 2 fixtures determining which teams are on track for knockout stage qualification.',
        source: 'FIFA World Cup 2026',
        publishedAt: DateTime(2026, 6, 18),
      ),
    ];
  }

  Future<List<VenueModel>> getVenues() async {
    final localVenues = WorldCupLocalData.getVenues();
    final Map<String, VenueModel> venuesMap = {};
    for (final v in localVenues) {
      venuesMap[v.id] = v;
    }

    try {
      final response = await _dio.get(
        '/eventsseason.php',
        queryParameters: {
          'id': ApiConfig.worldCupLeagueId,
          's': ApiConfig.worldCupSeason,
        },
      );
      final data = response.data;
      if (data != null && data['events'] != null) {
        final events = data['events'] as List;
        for (final event in events) {
          final venueName = event['strVenue']?.toString() ?? '';
          if (venueName.isEmpty) continue;
          final existingId = event['idVenue']?.toString();
          if (existingId != null && venuesMap.containsKey(existingId)) {
            venuesMap[existingId] = VenueModel(
              id: existingId,
              name: venueName,
              city: event['strCity']?.toString() ?? venuesMap[existingId]!.city,
              country: event['strCountry']?.toString() ?? venuesMap[existingId]!.country,
              capacity: venuesMap[existingId]!.capacity,
              latitude: venuesMap[existingId]!.latitude,
              longitude: venuesMap[existingId]!.longitude,
              image: event['strThumb']?.toString() ?? venuesMap[existingId]!.image,
            );
          }
        }
      }
    } catch (_) {}

    return venuesMap.values.toList();
  }

  MatchModel _mergeMatch(MatchModel local, MatchModel api) {
    return MatchModel(
      id: local.id,
      homeTeamId: local.homeTeamId,
      awayTeamId: local.awayTeamId,
      homeTeam: api.homeTeam?.name != null && api.homeTeam!.name.isNotEmpty
          ? TeamModel(
              id: local.homeTeamId,
              name: api.homeTeam!.name,
              flag: api.homeTeam?.flag ?? local.homeTeam?.flag,
              group: local.homeTeam?.group,
            )
          : local.homeTeam,
      awayTeam: api.awayTeam?.name != null && api.awayTeam!.name.isNotEmpty
          ? TeamModel(
              id: local.awayTeamId,
              name: api.awayTeam!.name,
              flag: api.awayTeam?.flag ?? local.awayTeam?.flag,
              group: local.awayTeam?.group,
            )
          : local.awayTeam,
      homeScore: api.homeScore > 0 ? api.homeScore : local.homeScore,
      awayScore: api.awayScore > 0 ? api.awayScore : local.awayScore,
      status: api.status != 'scheduled' ? api.status : local.status,
      matchday: local.matchday,
      group: local.group,
      venue: (api.venue != null && (api.venue!.name.isNotEmpty)) ? api.venue : local.venue,
      referee: api.referee ?? local.referee,
      date: local.date,
      time: api.time ?? local.time,
    );
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
