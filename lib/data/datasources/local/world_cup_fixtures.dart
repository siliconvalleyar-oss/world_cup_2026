import 'package:world_cup_2026/data/models/match_model.dart';
import 'package:world_cup_2026/data/models/team_model.dart';
import 'package:world_cup_2026/data/datasources/local/world_cup_local_data.dart';

class WorldCupFixtures {
  WorldCupFixtures._();

  static final Map<String, List<String>> _groupTeams = {
    'A': ['134497', '136482', '133915', '134520'],
    'B': ['140073', '133907', '134510', '134522'],
    'C': ['134496', '134518', '134506', '134526'],
    'D': ['134514', '133909', '134519', '134523'],
    'E': ['134509', '134501', '134527', '134528'],
    'F': ['134515', '134504', '136477', '134529'],
    'G': ['134499', '134502', '134524', '134530'],
    'H': ['134513', '134500', '134505', '134531'],
    'I': ['134511', '134516', '134503', '134532'],
    'J': ['134498', '134517', '134533', '134534'],
    'K': ['134507', '134512', '134525', '134535'],
    'L': ['134508', '134521', '134536', '134537'],
  };

  static final List<_MatchFixture> _fixtures = [
    // === GROUP A ===
    _MatchFixture('GA01', '134497', '136482', '2026-06-11T19:00:00', 1, 'A', 0),
    _MatchFixture('GA02', '133915', '134520', '2026-06-11T22:00:00', 1, 'A', 3),
    _MatchFixture('GA03', '134497', '133915', '2026-06-17T18:00:00', 2, 'A', 1),
    _MatchFixture('GA04', '134520', '136482', '2026-06-17T21:00:00', 2, 'A', 4),
    _MatchFixture('GA05', '134497', '134520', '2026-06-23T17:00:00', 3, 'A', 2),
    _MatchFixture('GA06', '136482', '133915', '2026-06-23T17:00:00', 3, 'A', 5),

    // === GROUP B ===
    _MatchFixture('GB01', '140073', '134510', '2026-06-12T19:00:00', 1, 'B', 0),
    _MatchFixture('GB02', '133907', '134522', '2026-06-12T22:00:00', 1, 'B', 6),
    _MatchFixture('GB03', '140073', '133907', '2026-06-18T18:00:00', 2, 'B', 1),
    _MatchFixture('GB04', '134522', '134510', '2026-06-18T21:00:00', 2, 'B', 4),
    _MatchFixture('GB05', '140073', '134522', '2026-06-24T17:00:00', 3, 'B', 2),
    _MatchFixture('GB06', '134510', '133907', '2026-06-24T17:00:00', 3, 'B', 5),

    // === GROUP C ===
    _MatchFixture('GC01', '134496', '134526', '2026-06-13T17:00:00', 1, 'C', 3),
    _MatchFixture('GC02', '134518', '134506', '2026-06-13T20:00:00', 1, 'C', 1),
    _MatchFixture('GC03', '134496', '134518', '2026-06-19T17:00:00', 2, 'C', 2),
    _MatchFixture('GC04', '134506', '134526', '2026-06-19T20:00:00', 2, 'C', 0),
    _MatchFixture('GC05', '134496', '134506', '2026-06-25T17:00:00', 3, 'C', 3),
    _MatchFixture('GC06', '134526', '134518', '2026-06-25T17:00:00', 3, 'C', 1),

    // === GROUP D ===
    _MatchFixture('GD01', '134514', '134523', '2026-06-14T17:00:00', 1, 'D', 2),
    _MatchFixture('GD02', '133909', '134519', '2026-06-14T20:00:00', 1, 'D', 1),
    _MatchFixture('GD03', '134514', '133909', '2026-06-20T17:00:00', 2, 'D', 1),
    _MatchFixture('GD04', '134519', '134523', '2026-06-20T20:00:00', 2, 'D', 2),
    _MatchFixture('GD05', '134514', '134519', '2026-06-26T17:00:00', 3, 'D', 1),
    _MatchFixture('GD06', '134523', '133909', '2026-06-26T17:00:00', 3, 'D', 2),

    // === GROUP E ===
    _MatchFixture('GE01', '134509', '134528', '2026-06-15T17:00:00', 1, 'E', 1),
    _MatchFixture('GE02', '134501', '134527', '2026-06-15T20:00:00', 1, 'E', 2),
    _MatchFixture('GE03', '134509', '134501', '2026-06-21T17:00:00', 2, 'E', 2),
    _MatchFixture('GE04', '134527', '134528', '2026-06-21T20:00:00', 2, 'E', 0),
    _MatchFixture('GE05', '134509', '134527', '2026-06-27T17:00:00', 3, 'E', 3),
    _MatchFixture('GE06', '134528', '134501', '2026-06-27T17:00:00', 3, 'E', 1),

    // === GROUP F ===
    _MatchFixture('GF01', '134515', '134529', '2026-06-16T17:00:00', 1, 'F', 2),
    _MatchFixture('GF02', '134504', '136477', '2026-06-16T20:00:00', 1, 'F', 1),
    _MatchFixture('GF03', '134515', '134504', '2026-06-22T17:00:00', 2, 'F', 2),
    _MatchFixture('GF04', '136477', '134529', '2026-06-22T20:00:00', 2, 'F', 1),
    _MatchFixture('GF05', '134515', '136477', '2026-06-28T17:00:00', 3, 'F', 3),
    _MatchFixture('GF06', '134529', '134504', '2026-06-28T17:00:00', 3, 'F', 0),

    // === GROUP G ===
    _MatchFixture('GG01', '134499', '134530', '2026-06-11T16:00:00', 1, 'G', 1),
    _MatchFixture('GG02', '134502', '134524', '2026-06-11T20:00:00', 1, 'G', 2),
    _MatchFixture('GG03', '134499', '134502', '2026-06-17T16:00:00', 2, 'G', 1),
    _MatchFixture('GG04', '134524', '134530', '2026-06-17T20:00:00', 2, 'G', 2),
    _MatchFixture('GG05', '134499', '134524', '2026-06-23T20:00:00', 3, 'G', 2),
    _MatchFixture('GG06', '134530', '134502', '2026-06-23T20:00:00', 3, 'G', 1),

    // === GROUP H ===
    _MatchFixture('GH01', '134513', '134531', '2026-06-12T16:00:00', 1, 'H', 1),
    _MatchFixture('GH02', '134505', '134500', '2026-06-12T20:00:00', 1, 'H', 2),
    _MatchFixture('GH03', '134513', '134505', '2026-06-18T16:00:00', 2, 'H', 1),
    _MatchFixture('GH04', '134500', '134531', '2026-06-18T20:00:00', 2, 'H', 0),
    _MatchFixture('GH05', '134513', '134500', '2026-06-24T20:00:00', 3, 'H', 2),
    _MatchFixture('GH06', '134531', '134505', '2026-06-24T20:00:00', 3, 'H', 1),

    // === GROUP I ===
    _MatchFixture('GI01', '134511', '134532', '2026-06-13T16:00:00', 1, 'I', 1),
    _MatchFixture('GI02', '134503', '134516', '2026-06-13T21:00:00', 1, 'I', 2),
    _MatchFixture('GI03', '134511', '134503', '2026-06-19T16:00:00', 2, 'I', 1),
    _MatchFixture('GI04', '134516', '134532', '2026-06-19T21:00:00', 2, 'I', 3),
    _MatchFixture('GI05', '134511', '134516', '2026-06-25T20:00:00', 3, 'I', 2),
    _MatchFixture('GI06', '134532', '134503', '2026-06-25T20:00:00', 3, 'I', 1),

    // === GROUP J ===
    _MatchFixture('GJ01', '134498', '134534', '2026-06-14T16:00:00', 1, 'J', 2),
    _MatchFixture('GJ02', '134517', '134533', '2026-06-14T21:00:00', 1, 'J', 1),
    _MatchFixture('GJ03', '134498', '134517', '2026-06-20T16:00:00', 2, 'J', 2),
    _MatchFixture('GJ04', '134533', '134534', '2026-06-20T21:00:00', 2, 'J', 1),
    _MatchFixture('GJ05', '134498', '134533', '2026-06-26T20:00:00', 3, 'J', 3),
    _MatchFixture('GJ06', '134534', '134517', '2026-06-26T20:00:00', 3, 'J', 1),

    // === GROUP K ===
    _MatchFixture('GK01', '134507', '134535', '2026-06-15T16:00:00', 1, 'K', 2),
    _MatchFixture('GK02', '134512', '134525', '2026-06-15T21:00:00', 1, 'K', 1),
    _MatchFixture('GK03', '134507', '134512', '2026-06-21T16:00:00', 2, 'K', 1),
    _MatchFixture('GK04', '134525', '134535', '2026-06-21T21:00:00', 2, 'K', 2),
    _MatchFixture('GK05', '134507', '134525', '2026-06-27T20:00:00', 3, 'K', 1),
    _MatchFixture('GK06', '134535', '134512', '2026-06-27T20:00:00', 3, 'K', 0),

    // === GROUP L ===
    _MatchFixture('GL01', '134508', '134537', '2026-06-16T16:00:00', 1, 'L', 1),
    _MatchFixture('GL02', '134521', '134536', '2026-06-16T21:00:00', 1, 'L', 2),
    _MatchFixture('GL03', '134508', '134521', '2026-06-22T16:00:00', 2, 'L', 1),
    _MatchFixture('GL04', '134536', '134537', '2026-06-22T21:00:00', 2, 'L', 0),
    _MatchFixture('GL05', '134508', '134536', '2026-06-28T20:00:00', 3, 'L', 2),
    _MatchFixture('GL06', '134537', '134521', '2026-06-28T20:00:00', 3, 'L', 1),
  ];

  static List<MatchModel> getGroupStageMatches() {
    final allTeams = WorldCupLocalData.getTeams();
    final allVenues = WorldCupLocalData.getVenues();
    final teamsMap = {for (var t in allTeams) t.id: t};

    return _fixtures.map((f) {
      final home = teamsMap[f.homeTeamId];
      final away = teamsMap[f.awayTeamId];
      final venueForMatch = allVenues[f.fixtureId.hashCode.abs() % allVenues.length];

      DateTime matchDate;
      try {
        matchDate = DateTime.parse(f.dateStr);
      } catch (_) {
        matchDate = DateTime(2026, 6, 11);
      }

      final now = DateTime.now();
      String status;
      if (matchDate.isAfter(now)) {
        status = 'scheduled';
      } else {
        status = 'finished';
      }

      return MatchModel(
        id: f.fixtureId,
        homeTeamId: f.homeTeamId,
        awayTeamId: f.awayTeamId,
        homeTeam: home,
        awayTeam: away,
        homeScore: status == 'finished' ? f.homeScore : 0,
        awayScore: status == 'finished' ? f.awayScore : 0,
        status: status,
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

  _MatchFixture(
    this.fixtureId,
    this.homeTeamId,
    this.awayTeamId,
    this.dateStr,
    this.matchday,
    this.group,
    this.homeScore,
  );

  int get awayScore => (homeScore + 1) % 4;
}
