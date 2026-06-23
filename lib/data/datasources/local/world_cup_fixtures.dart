import 'package:world_cup_2026/data/models/match_model.dart';
import 'package:world_cup_2026/data/models/team_model.dart';
import 'package:world_cup_2026/data/datasources/local/world_cup_local_data.dart';

class WorldCupFixtures {
  WorldCupFixtures._();

  static final Map<String, List<String>> _groupTeams = {
    'A': ['134497', '134517', '133904', '136482'],
    'B': ['140073', '134506', '134510', '134535'],
    'C': ['134496', '136139', '136450', '136471'],
    'D': ['134514', '134500', '136471', '135982'],
    'E': ['133907', '136141', '134507', '136477'],
    'F': ['133905', '134503', '136516', '136142'],
    'G': ['136138', '134511', '134515', '136517'],
    'H': ['133909', '134504', '136477', '134527'],
    'I': ['133913', '136516', '136143', '134520'],
    'J': ['134509', '135986', '134516', '136477'],
    'K': ['133908', '134501', '136477', '134537'],
    'L': ['133914', '134513', '134533', '133912'],
  };

  static final List<_MatchFixture> _fixtures = [
    // === GROUP A ===
    _MatchFixture('GA01', '134497', '136482', '2026-06-11T19:00:00', 1, 'A', 2, 0, '1'),
    _MatchFixture('GA02', '134517', '133904', '2026-06-11T22:00:00', 1, 'A', 2, 1, '13'),
    _MatchFixture('GA03', '133904', '136482', '2026-06-18T17:00:00', 2, 'A', 1, 1, '14'),
    _MatchFixture('GA04', '134497', '134517', '2026-06-18T20:00:00', 2, 'A', 1, 0, '13'),
    _MatchFixture('GA05', '133904', '134497', '2026-06-24T17:00:00', 3, 'A', 0, 0, '1', isScheduled: true),
    _MatchFixture('GA06', '136482', '134517', '2026-06-24T17:00:00', 3, 'A', 0, 0, '12', isScheduled: true),

    // === GROUP B ===
    _MatchFixture('GB01', '140073', '134510', '2026-06-12T19:00:00', 1, 'B', 1, 1, '10'),
    _MatchFixture('GB02', '134535', '134506', '2026-06-13T22:00:00', 1, 'B', 1, 1, '7'),
    _MatchFixture('GB03', '134506', '134510', '2026-06-18T18:00:00', 2, 'B', 4, 1, '8'),
    _MatchFixture('GB04', '140073', '134535', '2026-06-18T21:00:00', 2, 'B', 6, 0, '11'),
    _MatchFixture('GB05', '134506', '140073', '2026-06-24T17:00:00', 3, 'B', 0, 0, '11', isScheduled: true),
    _MatchFixture('GB06', '134510', '134535', '2026-06-24T17:00:00', 3, 'B', 0, 0, '6', isScheduled: true),

    // === GROUP C ===
    _MatchFixture('GC01', '134496', '136139', '2026-06-13T17:00:00', 1, 'C', 1, 1, '2'),
    _MatchFixture('GC02', '136471', '136450', '2026-06-13T20:00:00', 1, 'C', 0, 1, '9'),
    _MatchFixture('GC03', '136450', '136139', '2026-06-19T17:00:00', 2, 'C', 0, 1, '9'),
    _MatchFixture('GC04', '134496', '136471', '2026-06-19T20:00:00', 2, 'C', 3, 0, '14'),
    _MatchFixture('GC05', '136450', '134496', '2026-06-24T17:00:00', 3, 'C', 0, 0, '5', isScheduled: true),
    _MatchFixture('GC06', '136139', '136471', '2026-06-24T17:00:00', 3, 'C', 0, 0, '14', isScheduled: true),

    // === GROUP D ===
    _MatchFixture('GD01', '134514', '136471', '2026-06-12T17:00:00', 1, 'D', 4, 1, '8'),
    _MatchFixture('GD02', '134500', '135982', '2026-06-13T20:00:00', 1, 'D', 2, 0, '11'),
    _MatchFixture('GD03', '134514', '134500', '2026-06-19T17:00:00', 2, 'D', 2, 0, '6'),
    _MatchFixture('GD04', '135982', '136471', '2026-06-19T20:00:00', 2, 'D', 0, 1, '7'),
    _MatchFixture('GD05', '135982', '134514', '2026-06-25T17:00:00', 3, 'D', 0, 0, '8', isScheduled: true),
    _MatchFixture('GD06', '136471', '134500', '2026-06-25T17:00:00', 3, 'D', 0, 0, '7', isScheduled: true),

    // === GROUP E ===
    _MatchFixture('GE01', '133907', '136477', '2026-06-14T17:00:00', 1, 'E', 7, 1, '8'),
    _MatchFixture('GE02', '136141', '134507', '2026-06-14T20:00:00', 1, 'E', 1, 0, '14'),
    _MatchFixture('GE03', '133907', '136141', '2026-06-20T17:00:00', 2, 'E', 2, 1, '10'),
    _MatchFixture('GE04', '134507', '136477', '2026-06-20T20:00:00', 2, 'E', 0, 0, '15'),
    _MatchFixture('GE05', '136477', '136141', '2026-06-25T17:00:00', 3, 'E', 0, 0, '14', isScheduled: true),
    _MatchFixture('GE06', '134507', '133907', '2026-06-25T17:00:00', 3, 'E', 0, 0, '2', isScheduled: true),

    // === GROUP F ===
    _MatchFixture('GF01', '133905', '134503', '2026-06-14T17:00:00', 1, 'F', 2, 2, '4'),
    _MatchFixture('GF02', '136516', '136142', '2026-06-14T20:00:00', 1, 'F', 5, 1, '12'),
    _MatchFixture('GF03', '133905', '136516', '2026-06-20T17:00:00', 2, 'F', 5, 1, '8'),
    _MatchFixture('GF04', '136142', '134503', '2026-06-20T20:00:00', 2, 'F', 0, 4, '12'),
    _MatchFixture('GF05', '134503', '136516', '2026-06-25T17:00:00', 3, 'F', 0, 0, '4', isScheduled: true),
    _MatchFixture('GF06', '136142', '133905', '2026-06-25T17:00:00', 3, 'F', 0, 0, '15', isScheduled: true),

    // === GROUP G ===
    _MatchFixture('GG01', '134515', '136138', '2026-06-15T16:00:00', 1, 'G', 1, 1, '6'),
    _MatchFixture('GG02', '134511', '136517', '2026-06-15T20:00:00', 1, 'G', 2, 2, '8'),
    _MatchFixture('GG03', '134515', '134511', '2026-06-21T17:00:00', 2, 'G', 0, 0, '8'),
    _MatchFixture('GG04', '136517', '136138', '2026-06-21T20:00:00', 2, 'G', 1, 3, '11'),
    _MatchFixture('GG05', '136138', '134511', '2026-06-26T17:00:00', 3, 'G', 0, 0, '6', isScheduled: true),
    _MatchFixture('GG06', '136517', '134515', '2026-06-26T17:00:00', 3, 'G', 0, 0, '11', isScheduled: true),

    // === GROUP H ===
    _MatchFixture('GH01', '133909', '136477', '2026-06-15T16:00:00', 1, 'H', 0, 0, '14'),
    _MatchFixture('GH02', '134527', '134504', '2026-06-15T20:00:00', 1, 'H', 1, 1, '5'),
    _MatchFixture('GH03', '133909', '134527', '2026-06-21T17:00:00', 2, 'H', 4, 0, '14'),
    _MatchFixture('GH04', '134504', '136477', '2026-06-21T20:00:00', 2, 'H', 2, 2, '5'),
    _MatchFixture('GH05', '136477', '134527', '2026-06-26T17:00:00', 3, 'H', 0, 0, '8', isScheduled: true),
    _MatchFixture('GH06', '134504', '133909', '2026-06-26T17:00:00', 3, 'H', 0, 0, '13', isScheduled: true),

    // === GROUP I ===
    _MatchFixture('GI01', '133913', '136143', '2026-06-16T17:00:00', 1, 'I', 3, 1, '2'),
    _MatchFixture('GI02', '134520', '136516', '2026-06-16T20:00:00', 1, 'I', 1, 4, '9'),
    _MatchFixture('GI03', '133913', '134520', '2026-06-22T17:00:00', 2, 'I', 3, 0, '14'),
    _MatchFixture('GI04', '136516', '136143', '2026-06-22T20:00:00', 2, 'I', 3, 2, '2'),
    _MatchFixture('GI05', '136516', '133913', '2026-06-26T17:00:00', 3, 'I', 0, 0, '9', isScheduled: true),
    _MatchFixture('GI06', '136143', '134520', '2026-06-26T17:00:00', 3, 'I', 0, 0, '10', isScheduled: true),

    // === GROUP J ===
    _MatchFixture('GJ01', '134509', '134516', '2026-06-16T17:00:00', 1, 'J', 3, 0, '15'),
    _MatchFixture('GJ02', '135986', '136477', '2026-06-16T20:00:00', 1, 'J', 3, 1, '7'),
    _MatchFixture('GJ03', '134509', '135986', '2026-06-22T17:00:00', 2, 'J', 2, 0, '4'),
    _MatchFixture('GJ04', '136477', '134516', '2026-06-22T20:00:00', 2, 'J', 1, 2, '7'),
    _MatchFixture('GJ05', '134516', '135986', '2026-06-27T17:00:00', 3, 'J', 0, 0, '15', isScheduled: true),
    _MatchFixture('GJ06', '136477', '134509', '2026-06-27T17:00:00', 3, 'J', 0, 0, '4', isScheduled: true),

    // === GROUP K ===
    _MatchFixture('GK01', '133908', '136477', '2026-06-17T16:00:00', 1, 'K', 1, 1, '8'),
    _MatchFixture('GK02', '134537', '134501', '2026-06-17T20:00:00', 1, 'K', 1, 3, '1'),
    _MatchFixture('GK03', '133908', '134537', '2026-06-23T17:00:00', 2, 'K', 0, 0, '8', isScheduled: true),
    _MatchFixture('GK04', '134501', '136477', '2026-06-23T20:00:00', 2, 'K', 0, 0, '13', isScheduled: true),
    _MatchFixture('GK05', '134501', '133908', '2026-06-27T17:00:00', 3, 'K', 0, 0, '5', isScheduled: true),
    _MatchFixture('GK06', '136477', '134537', '2026-06-27T17:00:00', 3, 'K', 0, 0, '14', isScheduled: true),

    // === GROUP L ===
    _MatchFixture('GL01', '133914', '133912', '2026-06-17T17:00:00', 1, 'L', 4, 2, '12'),
    _MatchFixture('GL02', '134513', '134533', '2026-06-17T20:00:00', 1, 'L', 1, 0, '13'),
    _MatchFixture('GL03', '134533', '133914', '2026-06-23T17:00:00', 2, 'L', 0, 0, '14', isScheduled: true),
    _MatchFixture('GL04', '133912', '134513', '2026-06-23T20:00:00', 2, 'L', 0, 0, '8', isScheduled: true),
    _MatchFixture('GL05', '133912', '134533', '2026-06-27T17:00:00', 3, 'L', 0, 0, '14', isScheduled: true),
    _MatchFixture('GL06', '133914', '134513', '2026-06-27T17:00:00', 3, 'L', 0, 0, '15', isScheduled: true),
  ];

  static List<MatchModel> getGroupStageMatches() {
    final allTeams = WorldCupLocalData.getTeams();
    final allVenues = WorldCupLocalData.getVenues();
    final teamsMap = {for (var t in allTeams) t.id: t};
    final venuesMap = {for (var v in allVenues) v.id: v};

    return _fixtures.map((f) {
      final home = teamsMap[f.homeTeamId];
      final away = teamsMap[f.awayTeamId];
      final venueForMatch = venuesMap[f.venueId];

      DateTime matchDate;
      try {
        matchDate = DateTime.parse(f.dateStr);
      } catch (_) {
        matchDate = DateTime(2026, 6, 11);
      }

      return MatchModel(
        id: f.fixtureId,
        homeTeamId: f.homeTeamId,
        awayTeamId: f.awayTeamId,
        homeTeam: home,
        awayTeam: away,
        homeScore: f.homeScore,
        awayScore: f.awayScore,
        status: f.isScheduled ? 'scheduled' : 'finished',
        matchday: f.matchday,
        group: f.group,
        venue: venueForMatch,
        date: matchDate,
      );
    }).toList();
  }
}

class _MatchFixture {
  final String fixtureId;
  final String homeTeamId;
  final String awayTeamId;
  final String dateStr;
  final int matchday;
  final String group;
  final int homeScore;
  final int awayScore;
  final String venueId;
  final bool isScheduled;

  _MatchFixture(
    this.fixtureId,
    this.homeTeamId,
    this.awayTeamId,
    this.dateStr,
    this.matchday,
    this.group,
    this.homeScore,
    this.awayScore,
    this.venueId, {
    this.isScheduled = false,
  });
}
