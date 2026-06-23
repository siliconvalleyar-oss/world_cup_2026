import 'package:world_cup_2026/data/models/team_model.dart';
import 'package:world_cup_2026/data/models/standing_model.dart';
import 'package:world_cup_2026/data/models/group_model.dart';
import 'package:world_cup_2026/data/models/venue_model.dart';

class WorldCupLocalData {
  WorldCupLocalData._();

  static final List<Map<String, dynamic>> _teamsData = [
    // Group A
    {'id': '134497', 'name': 'Mexico', 'code': 'MEX', 'group': 'A', 'ranking': 14, 'confederation': 'CONCACAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/3rmosi1748525208.png', 'coach': 'Javier Aguirre'},
    {'id': '136482', 'name': 'South Africa', 'code': 'RSA', 'group': 'A', 'ranking': 56, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/xjz9j91553368824.png', 'coach': 'Hugo Broos'},
    {'id': '133915', 'name': 'Poland', 'code': 'POL', 'group': 'A', 'ranking': 28, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/vwvwrw1473502969.png', 'coach': 'Michał Probierz'},
    {'id': '134520', 'name': 'Iran', 'code': 'IRN', 'group': 'A', 'ranking': 20, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/8j5j9m1495068392.png', 'coach': 'Amir Ghalenoei'},

    // Group B
    {'id': '140073', 'name': 'Canada', 'code': 'CAN', 'group': 'B', 'ranking': 43, 'confederation': 'CONCACAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/2t631f1595154867.png', 'coach': 'Jesse Marsch'},
    {'id': '133907', 'name': 'Germany', 'code': 'GER', 'group': 'B', 'ranking': 13, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/yvwvtu1448813215.png', 'coach': 'Julian Nagelsmann'},
    {'id': '134510', 'name': 'Bosnia-Herzegovina', 'code': 'BIH', 'group': 'B', 'ranking': 63, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/wtqqst1455218381.png', 'coach': 'Savlo Milišević'},
    {'id': '134522', 'name': 'Uruguay', 'code': 'URU', 'group': 'B', 'ranking': 15, 'confederation': 'CONMEBOL', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/xzqdr11517660252.png', 'coach': 'Marcelo Bielsa'},

    // Group C
    {'id': '134496', 'name': 'Brazil', 'code': 'BRA', 'group': 'C', 'ranking': 5, 'confederation': 'CONMEBOL', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/jl6dip1726167280.png', 'coach': 'Dorival Júnior'},
    {'id': '134518', 'name': 'Morocco', 'code': 'MAR', 'group': 'C', 'ranking': 12, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/z2dcaj1688610171.png', 'coach': 'Walid Regragui'},
    {'id': '134506', 'name': 'Ecuador', 'code': 'ECU', 'group': 'C', 'ranking': 44, 'confederation': 'CONMEBOL', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/2073q41495290607.png', 'coach': 'Sebastián Beccacece'},
    {'id': '134526', 'name': 'Jamaica', 'code': 'JAM', 'group': 'C', 'ranking': 55, 'confederation': 'CONCACAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/ircxy41495290629.png', 'coach': 'Tappa Whitmore'},

    // Group D
    {'id': '134514', 'name': 'USA', 'code': 'USA', 'group': 'D', 'ranking': 11, 'confederation': 'CONCACAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/21f0oi1597948195.png', 'coach': 'Mauricio Pochettino'},
    {'id': '133909', 'name': 'France', 'code': 'FRA', 'group': 'D', 'ranking': 2, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/p3n0z51726166851.png', 'coach': 'Didier Deschamps'},
    {'id': '134519', 'name': 'Senegal', 'code': 'SEN', 'group': 'D', 'ranking': 17, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/2fggb31687853551.png', 'coach': 'Aliou Cissé'},
    {'id': '134523', 'name': 'Paraguay', 'code': 'PAR', 'group': 'D', 'ranking': 51, 'confederation': 'CONMEBOL', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/rwqqpq1473502965.png', 'coach': 'Gustavo Alfaro'},

    // Group E
    {'id': '134509', 'name': 'Argentina', 'code': 'ARG', 'group': 'E', 'ranking': 1, 'confederation': 'CONMEBOL', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/3zplhu1725997522.png', 'coach': 'Lionel Scaloni'},
    {'id': '134501', 'name': 'Colombia', 'code': 'COL', 'group': 'E', 'ranking': 10, 'confederation': 'CONMEBOL', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/4ymyku1694680710.png', 'coach': 'Néstor Lorenzo'},
    {'id': '134527', 'name': 'Saudi Arabia', 'code': 'KSA', 'group': 'E', 'ranking': 49, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/wuttpw1467462651.png', 'coach': 'Roberto Mancini'},
    {'id': '134528', 'name': 'Trinidad and Tobago', 'code': 'TTO', 'group': 'E', 'ranking': 96, 'confederation': 'CONCACAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/714dxj1495068392.png', 'coach': 'Dwight Yorke'},

    // Group F
    {'id': '134515', 'name': 'Belgium', 'code': 'BEL', 'group': 'F', 'ranking': 4, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/8xlvxv1597547368.png', 'coach': 'Domenico Tedesco'},
    {'id': '134504', 'name': 'Spain', 'code': 'ESP', 'group': 'F', 'ranking': 3, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/wqusqp1473504465.png', 'coach': 'Luis de la Fuente'},
    {'id': '136477', 'name': 'Cape Verde', 'code': 'CPV', 'group': 'F', 'ranking': 67, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/5jn0o71595290119.png', 'coach': 'Bubista'},
    {'id': '134529', 'name': 'New Zealand', 'code': 'NZL', 'group': 'F', 'ranking': 93, 'confederation': 'OFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/w86y501496391724.png', 'coach': 'Darren Bazeley'},

    // Group G
    {'id': '134499', 'name': 'England', 'code': 'ENG', 'group': 'G', 'ranking': 5, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/7dgq661691862010.png', 'coach': 'Thomas Tuchel'},
    {'id': '134502', 'name': 'Portugal', 'code': 'POR', 'group': 'G', 'ranking': 6, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/7onmml1495068392.png', 'coach': 'Roberto Martínez'},
    {'id': '134524', 'name': 'Greece', 'code': 'GRE', 'group': 'G', 'ranking': 54, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/612481495068392.png', 'coach': 'Gus Poyet'},
    {'id': '134530', 'name': 'Uzbekistan', 'code': 'UZB', 'group': 'G', 'ranking': 60, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/rwqvvw1473502967.png', 'coach': 'Srečko Katanec'},

    // Group H
    {'id': '134513', 'name': 'Japan', 'code': 'JPN', 'group': 'H', 'ranking': 18, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/2x488r1495068393.png', 'coach': ' Hajime Moriyasu'},
    {'id': '134500', 'name': 'Australia', 'code': 'AUS', 'group': 'H', 'ranking': 23, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/eylq8x1726166853.png', 'coach': 'Tony Popovic'},
    {'id': '134505', 'name': 'Netherlands', 'code': 'NED', 'group': 'H', 'ranking': 8, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/yyiywq1687686783.png', 'coach': 'Ronald Koeman'},
    {'id': '134531', 'name': 'Ivory Coast', 'code': 'CIV', 'group': 'H', 'ranking': 38, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/8j5g9z1495068392.png', 'coach': 'Emerse Faé'},

    // Group I
    {'id': '134511', 'name': 'Italy', 'code': 'ITA', 'group': 'I', 'ranking': 9, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/vwvwrw1473502969.png', 'coach': 'Luciano Spalletti'},
    {'id': '134516', 'name': 'Algeria', 'code': 'ALG', 'group': 'I', 'ranking': 34, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/rrwpry1455218381.png', 'coach': 'Vladimir Petković'},
    {'id': '134503', 'name': 'Croatia', 'code': 'CRO', 'group': 'I', 'ranking': 10, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/b1gm9q1697483825.png', 'coach': 'Zlatko Dalić'},
    {'id': '134532', 'name': 'Indonesia', 'code': 'IDN', 'group': 'I', 'ranking': 130, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/714dxj1495068392.png', 'coach': 'Shin Tae-yong'},

    // Group J
    {'id': '134498', 'name': 'South Korea', 'code': 'KOR', 'group': 'J', 'ranking': 22, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/a8nqfs1589564916.png', 'coach': 'Hong Myung-bo'},
    {'id': '134517', 'name': 'Czech Republic', 'code': 'CZE', 'group': 'J', 'ranking': 36, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/1o0cx31654205806.png', 'coach': 'Ivan Hašek'},
    {'id': '134533', 'name': 'Panama', 'code': 'PAN', 'group': 'J', 'ranking': 45, 'confederation': 'CONCACAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/714dxj1495068392.png', 'coach': 'Thomas Christiansen'},
    {'id': '134534', 'name': 'Jordan', 'code': 'JOR', 'group': 'J', 'ranking': 64, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/714dxj1495068392.png', 'coach': 'Jamal Sellawi'},

    // Group K
    {'id': '134507', 'name': 'Nigeria', 'code': 'NGA', 'group': 'K', 'ranking': 36, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/yvwvtu1448813215.png', 'coach': 'Augustine Eguavoen'},
    {'id': '134512', 'name': 'Tunisia', 'code': 'TUN', 'group': 'K', 'ranking': 32, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/612481495068392.png', 'coach': 'Faouzi Benzarti'},
    {'id': '134525', 'name': 'Costa Rica', 'code': 'CRC', 'group': 'K', 'ranking': 48, 'confederation': 'CONCACAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/714dxj1495068392.png', 'coach': 'Luis Fernando Suárez'},
    {'id': '134535', 'name': 'Qatar', 'code': 'QAT', 'group': 'K', 'ranking': 34, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/714dxj1495068392.png', 'coach': 'Tintín Márquez'},

    // Group L
    {'id': '134508', 'name': 'Serbia', 'code': 'SRB', 'group': 'L', 'ranking': 33, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/714dxj1495068392.png', 'coach': 'Dragan Stojković'},
    {'id': '134521', 'name': 'Denmark', 'code': 'DEN', 'group': 'L', 'ranking': 21, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/xzqdr11517660252.png', 'coach': 'Kasper Hjulmand'},
    {'id': '134536', 'name': 'Honduras', 'code': 'HON', 'group': 'L', 'ranking': 74, 'confederation': 'CONCACAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/714dxj1495068392.png', 'coach': 'Reinaldo Rueda'},
    {'id': '134537', 'name': 'Ghana', 'code': 'GHA', 'group': 'L', 'ranking': 68, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/714dxj1495068392.png', 'coach': 'Otto Addo'},
  ];

  static final List<Map<String, dynamic>> _venuesData = [
    {'id': '1', 'name': 'Estadio Azteca', 'city': 'Mexico City', 'country': 'Mexico', 'capacity': 87000, 'latitude': 19.3030, 'longitude': -99.1505},
    {'id': '2', 'name': 'MetLife Stadium', 'city': 'East Rutherford, NJ', 'country': 'USA', 'capacity': 82500, 'latitude': 40.8128, 'longitude': -74.0742},
    {'id': '3', 'name': 'Rose Bowl', 'city': 'Pasadena, CA', 'country': 'USA', 'capacity': 88565, 'latitude': 34.1613, 'longitude': -118.1676},
    {'id': '4', 'name': 'AT&T Stadium', 'city': 'Arlington, TX', 'country': 'USA', 'capacity': 80000, 'latitude': 32.7473, 'longitude': -97.0945},
    {'id': '5', 'name': 'Hard Rock Stadium', 'city': 'Miami Gardens, FL', 'country': 'USA', 'capacity': 65326, 'latitude': 25.9580, 'longitude': -80.2389},
    {'id': '6', 'name': 'Lumen Field', 'city': 'Seattle, WA', 'country': 'USA', 'capacity': 68740, 'latitude': 47.5952, 'longitude': -122.3316},
    {'id': '7', 'name': 'Levi\'s Stadium', 'city': 'Santa Clara, CA', 'country': 'USA', 'capacity': 71620, 'latitude': 37.4033, 'longitude': -121.9698},
    {'id': '8', 'name': 'NRG Stadium', 'city': 'Houston, TX', 'country': 'USA', 'capacity': 72220, 'latitude': 29.6847, 'longitude': -95.4107},
    {'id': '9', 'name': 'Gillette Stadium', 'city': 'Foxborough, MA', 'country': 'USA', 'capacity': 65878, 'latitude': 42.0909, 'longitude': -71.2643},
    {'id': '10', 'name': 'BMO Field', 'city': 'Toronto, ON', 'country': 'Canada', 'capacity': 45500, 'latitude': 43.6332, 'longitude': -79.4186},
    {'id': '11', 'name': 'BC Place', 'city': 'Vancouver, BC', 'country': 'Canada', 'capacity': 54320, 'latitude': 49.2768, 'longitude': -123.1107},
    {'id': '12', 'name': 'Estadio BBVA', 'city': 'Monterrey', 'country': 'Mexico', 'capacity': 53500, 'latitude': 25.6700, 'longitude': -100.2444},
    {'id': '13', 'name': 'Estadio Akron', 'city': 'Guadalajara', 'country': 'Mexico', 'capacity': 49850, 'latitude': 20.6820, 'longitude': -103.4625},
    {'id': '14', 'name': 'Mercedes-Benz Stadium', 'city': 'Atlanta, GA', 'country': 'USA', 'capacity': 71000, 'latitude': 33.7554, 'longitude': -84.4010},
  ];

  static List<TeamModel> getTeams() {
    return _teamsData.map((t) => TeamModel(
      id: t['id'] as String,
      name: t['name'] as String,
      code: t['code'] as String,
      flag: t['flag'] as String?,
      group: t['group'] as String,
      fifaRanking: t['ranking'] as int,
      confederation: t['confederation'] as String?,
      coach: t['coach'] as String?,
    )).toList();
  }

  static List<GroupModel> getGroups() {
    final teams = getTeams();
    final Map<String, List<StandingModel>> groupsMap = {};

    for (final team in teams) {
      final groupLetter = team.group ?? 'A';
      groupsMap.putIfAbsent(groupLetter, () => []);
      groupsMap[groupLetter]!.add(StandingModel(
        teamId: team.id,
        team: team,
      ));
    }

    final groups = <GroupModel>[];
    final sortedKeys = groupsMap.keys.toList()..sort();
    for (final key in sortedKeys) {
      groups.add(GroupModel(
        id: key,
        name: key,
        teams: groupsMap[key]!,
      ));
    }
    return groups;
  }

  static List<VenueModel> getVenues() {
    return _venuesData.map((v) => VenueModel(
      id: v['id'] as String,
      name: v['name'] as String,
      city: v['city'] as String,
      country: v['country'] as String?,
      capacity: v['capacity'] as int?,
      latitude: v['latitude'] as double?,
      longitude: v['longitude'] as double?,
    )).toList();
  }

  static TeamModel? getTeamById(String id) {
    try {
      return getTeams().firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
