import 'package:dio/dio.dart';
import 'package:world_cup_2026/data/models/match_model.dart';
import 'package:world_cup_2026/data/models/team_model.dart';
import 'package:world_cup_2026/data/models/group_model.dart';
import 'package:world_cup_2026/data/models/standing_model.dart';
import 'package:world_cup_2026/data/models/venue_model.dart';
import 'package:world_cup_2026/data/models/news_model.dart';
import 'package:world_cup_2026/data/models/event_model.dart';
import 'package:world_cup_2026/data/models/player_model.dart';
import 'package:world_cup_2026/data/datasources/local/world_cup_local_data.dart';
import 'package:world_cup_2026/data/datasources/local/world_cup_fixtures.dart';

class TheSportsDBService {
  final Dio _dio;
  Map<String, String> _apiToLocalTeamIds = {};
  Map<String, Map<String, dynamic>> _apiTeams = {};
  bool _teamsLoaded = false;

  TheSportsDBService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://worldcup26.ir',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ));

  static const Map<String, String> _nameOverrides = {
    'democratic republic of the congo': 'DR Congo',
  };

  Future<void> _ensureTeamsLoaded() async {
    if (_teamsLoaded) return;
    try {
      final response = await _dio.get('/get/teams');
      final data = response.data;
      if (data != null && data['teams'] != null) {
        final teams = data['teams'] as List;
        final localTeams = WorldCupLocalData.getTeams();
        for (final t in teams) {
          final apiId = t['id']?.toString() ?? '';
          var apiName = (t['name_en']?.toString() ?? '').toLowerCase().trim();
          apiName = _nameOverrides[apiName] ?? apiName;
          _apiTeams[apiId] = t as Map<String, dynamic>;
          for (final local in localTeams) {
            if (local.name.toLowerCase().trim() == apiName) {
              _apiToLocalTeamIds[apiId] = local.id;
              break;
            }
          }
          if (!_apiToLocalTeamIds.containsKey(apiId)) {
            _apiToLocalTeamIds[apiId] = 'wc26_$apiId';
          }
        }
      }
      _teamsLoaded = true;
    } catch (_) {
      _teamsLoaded = true;
    }
  }

  String _localTeamId(String apiId) {
    return _apiToLocalTeamIds[apiId] ?? 'wc26_$apiId';
  }

  Map<String, dynamic>? _apiTeam(String apiId) {
    return _apiTeams[apiId];
  }

  Future<List<MatchModel>> getMatches() async {
    await _ensureTeamsLoaded();
    try {
      final response = await _dio.get('/get/games');
      final data = response.data;
      if (data != null && data['games'] != null) {
        final games = data['games'] as List;
        final matches = games
            .map((g) => _parseApiMatch(g as Map<String, dynamic>))
            .where((m) => m != null)
            .toList()
            .cast<MatchModel>()
          ..sort((a, b) => b.date.compareTo(a.date));

        if (matches.isNotEmpty) {
          final stadiums = await _getStadiumsMap();
          for (var i = 0; i < matches.length; i++) {
            final m = matches[i];
            final venueId = m.venue?.id ?? '';
            if (stadiums.containsKey(venueId)) {
              matches[i] = m.copyWith(venue: stadiums[venueId]);
            }
          }
          return matches;
        }
      }
    } catch (_) {}
    return WorldCupFixtures.getGroupStageMatches();
  }

  Future<Map<String, VenueModel>> _getStadiumsMap() async {
    final local = WorldCupLocalData.getVenues();
    final map = <String, VenueModel>{};
    for (final v in local) {
      map[v.id] = v;
    }
    try {
      final response = await _dio.get('/get/stadiums');
      final data = response.data;
      if (data != null && data['stadiums'] != null) {
        final stadiums = data['stadiums'] as List;
        for (final s in stadiums) {
          final id = s['id']?.toString() ?? '';
          final name = s['name_en']?.toString() ?? '';
          final city = s['city_en']?.toString() ?? '';
          final country = s['country_en']?.toString() ?? '';
          final capacity = _parseInt(s['capacity']);
          if (id.isNotEmpty) {
            map[id] = VenueModel(
              id: id,
              name: name,
              city: city,
              country: country,
              capacity: capacity,
              fifaName: s['fifa_name']?.toString(),
              region: s['region']?.toString(),
            );
          }
        }
      }
    } catch (_) {}
    return map;
  }

  Future<List<MatchModel>> getNextMatches() async {
    await _ensureTeamsLoaded();
    try {
      final response = await _dio.get('/get/games');
      final data = response.data;
      if (data == null || data['games'] == null) return [];
      final games = data['games'] as List;
      final now = DateTime.now();
      return games
          .map((g) => _parseApiMatch(g as Map<String, dynamic>))
          .where((m) => m != null && m!.date.isAfter(now) && m.status == 'scheduled')
          .take(10)
          .toList()
          .cast<MatchModel>();
    } catch (_) {
      return [];
    }
  }

  Future<List<TeamModel>> getTeamsFromStandings() async {
    await _ensureTeamsLoaded();
    final localTeams = WorldCupLocalData.getTeams();
    final Map<String, TeamModel> teamMap = {};
    for (final t in localTeams) {
      teamMap[t.id] = t;
    }
    try {
      final response = await _dio.get('/get/teams');
      final data = response.data;
      if (data != null && data['teams'] != null) {
        final teams = data['teams'] as List;
        for (final t in teams) {
          final apiId = t['id']?.toString() ?? '';
          final localId = _localTeamId(apiId);
          final flag = t['flag']?.toString();
          final fifaCode = t['fifa_code']?.toString();
          final name = t['name_en']?.toString() ?? '';
          final group = t['groups']?.toString() ?? '';
          final iso2 = t['iso2']?.toString();
          if (teamMap.containsKey(localId)) {
            final existing = teamMap[localId]!;
            teamMap[localId] = existing.copyWith(
              flag: flag ?? existing.flag,
              code: fifaCode ?? existing.code,
              name: name.isEmpty ? existing.name : name,
              group: group.isEmpty ? existing.group : group,
              iso2: iso2 ?? existing.iso2,
            );
          } else {
            teamMap[localId] = TeamModel(
              id: localId,
              name: name,
              code: fifaCode,
              flag: flag,
              group: group,
              iso2: iso2,
            );
          }
        }
      }
    } catch (_) {}
    return teamMap.values.toList()
      ..sort((a, b) => (a.group ?? '').compareTo(b.group ?? ''));
  }

  Future<List<GroupModel>> getGroups() async {
    await _ensureTeamsLoaded();
    try {
      final teams = await getTeamsFromStandings();
      final Map<String, List<TeamModel>> teamsByGroup = {};
      for (final team in teams) {
        final g = team.group ?? 'A';
        teamsByGroup.putIfAbsent(g, () => []);
        teamsByGroup[g]!.add(team);
      }

      final response = await _dio.get('/get/groups');
      final data = response.data;
      if (data != null && data['groups'] != null) {
        final apiGroups = data['groups'] as List;
        final groups = <GroupModel>[];
        for (final g in apiGroups) {
          final groupName = g['name']?.toString() ?? '';
          final apiStandings = g['teams'] as List? ?? [];
          final standingsList = <StandingModel>[];
          for (final s in apiStandings) {
            final apiTeamId = s['team_id']?.toString() ?? '';
            final localId = _localTeamId(apiTeamId);
            final team = teamsByGroup[groupName]
                ?.where((t) => t.id == localId)
                .firstOrNull;
            final mp = _parseInt(s['mp']);
            final w = _parseInt(s['w']);
            final d = _parseInt(s['d']);
            final l = _parseInt(s['l']);
            final gf = _parseInt(s['gf']);
            final ga = _parseInt(s['ga']);
            standingsList.add(StandingModel(
              teamId: localId,
              team: team,
              played: mp,
              won: w,
              drawn: d,
              lost: l,
              goalsFor: gf,
              goalsAgainst: ga,
              goalDifference: gf - ga,
              points: _parseInt(s['pts']),
            ));
          }
          standingsList.sort((a, b) {
            final cmp = b.points.compareTo(a.points);
            if (cmp != 0) return cmp;
            return b.goalDifference.compareTo(a.goalDifference);
          });
          for (var i = 0; i < standingsList.length; i++) {
            standingsList[i] = standingsList[i].copyWith(position: i + 1);
          }
          groups.add(GroupModel(
            id: groupName,
            name: groupName,
            teams: standingsList,
          ));
        }
        if (groups.isNotEmpty) return groups;
      }
    } catch (_) {}
    return WorldCupLocalData.getGroups();
  }

  Future<List<NewsModel>> getNews() async {
    return _getLocalNews();
  }

  Future<List<VenueModel>> getVenues() async {
    final stadiums = await _getStadiumsMap();
    return stadiums.values.toList();
  }

  Future<List<PlayerModel>> getTopScorers() async {
    await _ensureTeamsLoaded();
    final Map<String, PlayerModel> scorers = {};

    try {
      final response = await _dio.get('/get/games');
      final data = response.data;
      if (data == null || data['games'] == null) return [];
      final games = data['games'] as List;

      for (final g in games) {
        final homeApiId = g['home_team_id']?.toString() ?? '';
        final awayApiId = g['away_team_id']?.toString() ?? '';
        final homeLocalId = _localTeamId(homeApiId);
        final awayLocalId = _localTeamId(awayApiId);

        _parseScorers(g['home_scorers']?.toString(), homeLocalId, scorers);
        _parseScorers(g['away_scorers']?.toString(), awayLocalId, scorers);
      }
    } catch (_) {}

    if (scorers.isEmpty) {
      return [];
    }

    final sorted = scorers.values.toList()
      ..sort((a, b) => b.goals.compareTo(a.goals));
    return sorted.take(30).toList();
  }

  void _parseScorers(String? scorersStr, String teamId, Map<String, PlayerModel> acc) {
    if (scorersStr == null || scorersStr.isEmpty || scorersStr == 'null') return;
    try {
      final cleaned = scorersStr
          .replaceAll('{', '[')
          .replaceAll('}', ']')
          .replaceAll('"', '');
      final items = cleaned
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      for (final item in items) {
        final match = RegExp(r"(.+?)\s+(\d+)'").firstMatch(item);
        if (match == null) continue;
        final name = match.group(1)!.trim();
        final minute = int.parse(match.group(2)!);

        final key = '${teamId}_$name';
        if (acc.containsKey(key)) {
          final existing = acc[key]!;
          acc[key] = existing.copyWith(goals: existing.goals + 1);
        } else {
          final teamData = WorldCupLocalData.getTeams()
              .where((t) => t.id == teamId)
              .firstOrNull;
          acc[key] = PlayerModel(
            id: key,
            name: name,
            teamId: teamId,
            teamName: teamData?.name ?? '',
            goals: 1,
          );
        }
      }
    } catch (_) {}
  }

  List<EventModel> parseMatchEvents(Map<String, dynamic> g) {
    final events = <EventModel>[];
    final homeApiId = g['home_team_id']?.toString() ?? '';
    final awayApiId = g['away_team_id']?.toString() ?? '';
    final homeLocalId = _localTeamId(homeApiId);
    final awayLocalId = _localTeamId(awayApiId);

    _parseGoalEvents(g['home_scorers']?.toString(), homeLocalId, events);
    _parseGoalEvents(g['away_scorers']?.toString(), awayLocalId, events);

    events.sort((a, b) => (a.minute ?? 0).compareTo(b.minute ?? 0));
    return events;
  }

  void _parseGoalEvents(String? scorersStr, String teamId, List<EventModel> events) {
    if (scorersStr == null || scorersStr.isEmpty || scorersStr == 'null') return;
    try {
      final cleaned = scorersStr
          .replaceAll('{', '[')
          .replaceAll('}', ']')
          .replaceAll('"', '');
      final items = cleaned
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      for (var i = 0; i < items.length; i++) {
        final match = RegExp(r"(.+?)\s+(\d+)'").firstMatch(items[i]);
        if (match == null) continue;
        final name = match.group(1)!.trim();
        final minuteStr = match.group(2)!;
        final isExtraTime = minuteStr.contains('+');
        final minute = int.tryParse(minuteStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

        events.add(EventModel(
          id: 'event_${events.length}_$i',
          type: 'goal',
          minute: minute,
          playerName: name,
          teamId: teamId,
          extraTime: isExtraTime,
        ));
      }
    } catch (_) {}
  }

  MatchModel? _parseApiMatch(Map<String, dynamic> g) {
    final homeApiId = g['home_team_id']?.toString() ?? '';
    final awayApiId = g['away_team_id']?.toString() ?? '';
    final homeLocalId = _localTeamId(homeApiId);
    final awayLocalId = _localTeamId(awayApiId);

    final homeScoreStr = g['home_score']?.toString();
    final awayScoreStr = g['away_score']?.toString();
    final hasScore = homeScoreStr != null &&
        homeScoreStr != 'null' &&
        awayScoreStr != null &&
        awayScoreStr != 'null';

    final timeElapsed = g['time_elapsed']?.toString() ?? 'notstarted';
    final status = _mapStatus(timeElapsed);

    final type = g['type']?.toString() ?? 'group';
    final groupField = g['group']?.toString() ?? '';
    final stage = _mapStage(type);
    final group = type == 'group' ? groupField : null;

    final matchday = _parseInt(g['matchday']);

    DateTime matchDate;
    try {
      final dateStr = g['local_date']?.toString() ?? '';
      if (dateStr.isNotEmpty) {
        final parts = dateStr.split(' ');
        if (parts.length >= 2) {
          final dateParts = parts[0].split('/');
          if (dateParts.length == 3) {
            final month = int.parse(dateParts[0]);
            final day = int.parse(dateParts[1]);
            final year = int.parse(dateParts[2]);
            final timeParts = parts[1].split(':');
            final hour = int.parse(timeParts[0]);
            final minute = timeParts.length > 1 ? int.parse(timeParts[1]) : 0;
            matchDate = DateTime(year, month, day, hour, minute);
          } else {
            matchDate = DateTime(2026, 6, 11);
          }
        } else {
          matchDate = DateTime(2026, 6, 11);
        }
      } else {
        matchDate = DateTime(2026, 6, 11);
      }
    } catch (_) {
      matchDate = DateTime(2026, 6, 11);
    }

    final homeTeamData = _apiTeam(homeApiId);
    final awayTeamData = _apiTeam(awayApiId);

    String? homeTeamName;
    String? awayTeamName;
    String? homeFlag;
    String? awayFlag;
    if (homeTeamData != null) {
      homeTeamName = homeTeamData['name_en']?.toString();
      homeFlag = homeTeamData['flag']?.toString();
    }
    if (awayTeamData != null) {
      awayTeamName = awayTeamData['name_en']?.toString();
      awayFlag = awayTeamData['flag']?.toString();
    }
    final homeLabel = g['home_team_label']?.toString();
    final awayLabel = g['away_team_label']?.toString();
    if (homeTeamName == null || homeTeamName.isEmpty) {
      homeTeamName = g['home_team_name_en']?.toString() ?? homeLabel;
    }
    if (awayTeamName == null || awayTeamName.isEmpty) {
      awayTeamName = g['away_team_name_en']?.toString() ?? awayLabel;
    }

    final id = g['id']?.toString() ?? '';
    final events = parseMatchEvents(g);
    final stadiumId = g['stadium_id']?.toString() ?? '';
    final timeStr = '${matchDate.hour.toString().padLeft(2, '0')}:${matchDate.minute.toString().padLeft(2, '0')}';

    return MatchModel(
      id: 'api_$id',
      homeTeamId: homeLocalId,
      awayTeamId: awayLocalId,
      homeTeam: TeamModel(
        id: homeLocalId,
        name: homeTeamName ?? 'TBD',
        flag: homeFlag,
        group: group,
      ),
      awayTeam: TeamModel(
        id: awayLocalId,
        name: awayTeamName ?? 'TBD',
        flag: awayFlag,
        group: group,
      ),
      homeScore: hasScore ? _parseInt(homeScoreStr) : 0,
      awayScore: hasScore ? _parseInt(awayScoreStr) : 0,
      status: status,
      matchday: matchday,
      group: group,
      stage: stage,
      venue: VenueModel(id: stadiumId, name: '', city: ''),
      date: matchDate,
      time: timeStr,
      events: events.isNotEmpty ? events : null,
      homeTeamLabel: homeLabel,
      awayTeamLabel: awayLabel,
    );
  }

  String _mapStatus(String timeElapsed) {
    switch (timeElapsed.toLowerCase()) {
      case 'finished':
        return 'finished';
      case 'live':
        return 'live';
      default:
        return 'scheduled';
    }
  }

  String _mapStage(String type) {
    switch (type.toLowerCase()) {
      case 'group':
        return 'group_stage';
      case 'r32':
        return 'round_of_32';
      case 'r16':
        return 'round_of_16';
      case 'qf':
        return 'quarter_final';
      case 'sf':
        return 'semi_final';
      case 'final':
        return 'final';
      case 'third':
        return 'third_place';
      default:
        return 'group_stage';
    }
  }

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  List<NewsModel> _getLocalNews() {
    return [
      NewsModel(
        id: 'news_1',
        title: 'FIFA World Cup 2026 kicks off in Mexico',
        summary: 'The biggest World Cup in history begins with 48 teams competing across 3 host nations.',
        content: 'The 2026 FIFA World Cup has officially begun.',
        source: 'FIFA World Cup 2026',
        publishedAt: DateTime(2026, 6, 11),
      ),
      NewsModel(
        id: 'news_2',
        title: 'Record-breaking attendance expected',
        summary: 'Over 5 million fans expected to attend matches across 16 venues.',
        content: 'With 16 world-class stadiums hosting matches, organizers anticipate record-breaking attendance.',
        source: 'FIFA World Cup 2026',
        publishedAt: DateTime(2026, 6, 12),
      ),
      NewsModel(
        id: 'news_3',
        title: 'Group stage matchday 1 highlights',
        summary: 'Exciting opening matches deliver thrilling football across all groups.',
        content: 'The first matchday of the group stage delivered incredible action.',
        source: 'FIFA World Cup 2026',
        publishedAt: DateTime(2026, 6, 13),
      ),
      NewsModel(
        id: 'news_4',
        title: 'VAR technology enhanced for 2026',
        summary: 'New semi-automated offside technology brings faster decisions.',
        content: 'FIFA has implemented advanced VAR technology for the 2026 World Cup.',
        source: 'FIFA World Cup 2026',
        publishedAt: DateTime(2026, 6, 14),
      ),
      NewsModel(
        id: 'news_5',
        title: 'Knockout stage set',
        summary: '32 teams advance as group stage concludes.',
        content: 'The group stage has concluded with 32 teams qualifying for the knockout phase.',
        source: 'FIFA World Cup 2026',
        publishedAt: DateTime.now(),
      ),
    ];
  }
}
