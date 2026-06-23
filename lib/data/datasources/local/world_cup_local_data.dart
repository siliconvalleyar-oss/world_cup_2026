import 'package:world_cup_2026/data/models/team_model.dart';
import 'package:world_cup_2026/data/models/standing_model.dart';
import 'package:world_cup_2026/data/models/group_model.dart';
import 'package:world_cup_2026/data/models/venue_model.dart';

class WorldCupLocalData {
  WorldCupLocalData._();

  static final List<Map<String, dynamic>> _teamsData = [
    // Group A
    {'id': '134497', 'name': 'Mexico', 'code': 'MEX', 'group': 'A', 'ranking': 14, 'confederation': 'CONCACAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/3rmosi1748525208.png', 'coach': 'Javier Aguirre'},
    {'id': '134517', 'name': 'South Korea', 'code': 'KOR', 'group': 'A', 'ranking': 22, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/a8nqfs1589564916.png', 'coach': 'Hong Myung-bo'},
    {'id': '133904', 'name': 'Czech Republic', 'code': 'CZE', 'group': 'A', 'ranking': 36, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/1o0cx31654205806.png', 'coach': 'Ivan Hašek'},
    {'id': '136482', 'name': 'South Africa', 'code': 'RSA', 'group': 'A', 'ranking': 56, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/xjz9j91553368824.png', 'coach': 'Hugo Broos'},

    // Group B
    {'id': '140073', 'name': 'Canada', 'code': 'CAN', 'group': 'B', 'ranking': 43, 'confederation': 'CONCACAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/2t631f1595154867.png', 'coach': 'Jesse Marsch'},
    {'id': '134506', 'name': 'Switzerland', 'code': 'SUI', 'group': 'B', 'ranking': 13, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/mb7yqe1717365808.png', 'coach': 'Murat Yakin'},
    {'id': '134510', 'name': 'Bosnia and Herzegovina', 'code': 'BIH', 'group': 'B', 'ranking': 63, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/wtqqst1455218381.png', 'coach': 'Savlo Milišević'},
    {'id': '134535', 'name': 'Qatar', 'code': 'QAT', 'group': 'B', 'ranking': 41, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/default.png', 'coach': 'Tintín Márquez'},

    // Group C
    {'id': '134496', 'name': 'Brazil', 'code': 'BRA', 'group': 'C', 'ranking': 5, 'confederation': 'CONMEBOL', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/jl6dip1726167280.png', 'coach': 'Dorival Júnior'},
    {'id': '136139', 'name': 'Morocco', 'code': 'MAR', 'group': 'C', 'ranking': 12, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/z2dcaj1688610171.png', 'coach': 'Walid Regragui'},
    {'id': '136450', 'name': 'Scotland', 'code': 'SCO', 'group': 'C', 'ranking': 25, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/3691i11552945146.png', 'coach': 'Steve Clarke'},
    {'id': '136471', 'name': 'Haiti', 'code': 'HAI', 'group': 'C', 'ranking': 48, 'confederation': 'CONCACAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/default.png', 'coach': 'Jean-Jacques Pierre'},

    // Group D
    {'id': '134514', 'name': 'United States', 'code': 'USA', 'group': 'D', 'ranking': 11, 'confederation': 'CONCACAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/21f0oi1597948195.png', 'coach': 'Mauricio Pochettino'},
    {'id': '134500', 'name': 'Australia', 'code': 'AUS', 'group': 'D', 'ranking': 17, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/eylq8x1726166853.png', 'coach': 'Tony Popovic'},
    {'id': '136471', 'name': 'Paraguay', 'code': 'PAR', 'group': 'D', 'ranking': 28, 'confederation': 'CONMEBOL', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/rwqqpq1473502965.png', 'coach': 'Gustavo Alfaro'},
    {'id': '135982', 'name': 'Turkey', 'code': 'TUR', 'group': 'D', 'ranking': 21, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/default.png', 'coach': 'Vincenzo Montella'},

    // Group E
    {'id': '133907', 'name': 'Germany', 'code': 'GER', 'group': 'E', 'ranking': 8, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/yvwvtu1448813215.png', 'coach': 'Julian Nagelsmann'},
    {'id': '136141', 'name': 'Ivory Coast', 'code': 'CIV', 'group': 'E', 'ranking': 27, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/default.png', 'coach': 'Emerse Faé'},
    {'id': '134507', 'name': 'Ecuador', 'code': 'ECU', 'group': 'E', 'ranking': 30, 'confederation': 'CONMEBOL', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/47wv2y1591989301.png', 'coach': 'Sebastián Beccacece'},
    {'id': '136477', 'name': 'Curaçao', 'code': 'CUW', 'group': 'E', 'ranking': 47, 'confederation': 'CONCACAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/default.png', 'coach': 'Guus Hiddink'},

    // Group F
    {'id': '133905', 'name': 'Netherlands', 'code': 'NED', 'group': 'F', 'ranking': 7, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/1p0hr41593787110.png', 'coach': 'Ronald Koeman'},
    {'id': '134503', 'name': 'Japan', 'code': 'JPN', 'group': 'F', 'ranking': 14, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/ffsyxz1591989843.png', 'coach': 'Hajime Moriyasu'},
    {'id': '136516', 'name': 'Sweden', 'code': 'SWE', 'group': 'F', 'ranking': 26, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/default.png', 'coach': 'Janne Andersson'},
    {'id': '136142', 'name': 'Tunisia', 'code': 'TUN', 'group': 'F', 'ranking': 31, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/7r89rg1526727277.png', 'coach': 'Jalel Kadri'},

    // Group G
    {'id': '136138', 'name': 'Egypt', 'code': 'EGY', 'group': 'G', 'ranking': 20, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/uheyzo1742102234.png', 'coach': 'Hossam Hassan'},
    {'id': '134511', 'name': 'Iran', 'code': 'IRN', 'group': 'G', 'ranking': 23, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/uttpvw1455465617.png', 'coach': 'Amir Ghalenoei'},
    {'id': '134515', 'name': 'Belgium', 'code': 'BEL', 'group': 'G', 'ranking': 9, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/8xlvxv1592062265.png', 'coach': 'Domenico Tedesco'},
    {'id': '136517', 'name': 'New Zealand', 'code': 'NZL', 'group': 'G', 'ranking': 45, 'confederation': 'OFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/default.png', 'coach': 'Darren Bazeley'},

    // Group H
    {'id': '133909', 'name': 'Spain', 'code': 'ESP', 'group': 'H', 'ranking': 3, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/ncgqyr1726166942.png', 'coach': 'Luis de la Fuente'},
    {'id': '134504', 'name': 'Uruguay', 'code': 'URU', 'group': 'H', 'ranking': 16, 'confederation': 'CONMEBOL', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/6vjbr11726167756.png', 'coach': 'Marcelo Bielsa'},
    {'id': '136477', 'name': 'Cape Verde', 'code': 'CPV', 'group': 'H', 'ranking': 46, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/default.png', 'coach': 'Bubista'},
    {'id': '134527', 'name': 'Saudi Arabia', 'code': 'KSA', 'group': 'H', 'ranking': 32, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/default.png', 'coach': 'Roberto Mancini'},

    // Group I
    {'id': '133913', 'name': 'France', 'code': 'FRA', 'group': 'I', 'ranking': 2, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/p3n0z51726166851.png', 'coach': 'Didier Deschamps'},
    {'id': '136516', 'name': 'Norway', 'code': 'NOR', 'group': 'I', 'ranking': 24, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/gyfn811591973155.png', 'coach': 'Ståle Solbakken'},
    {'id': '136143', 'name': 'Senegal', 'code': 'SEN', 'group': 'I', 'ranking': 18, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/slayb01780546342.png', 'coach': 'Aliou Cissé'},
    {'id': '134520', 'name': 'Iraq', 'code': 'IRQ', 'group': 'I', 'ranking': 40, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/default.png', 'coach': 'Jesús Casas'},

    // Group J
    {'id': '134509', 'name': 'Argentina', 'code': 'ARG', 'group': 'J', 'ranking': 1, 'confederation': 'CONMEBOL', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/3zplhu1726167477.png', 'coach': 'Lionel Scaloni'},
    {'id': '135986', 'name': 'Austria', 'code': 'AUT', 'group': 'J', 'ranking': 19, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/874p631628721400.png', 'coach': 'Ralf Rangnick'},
    {'id': '134516', 'name': 'Algeria', 'code': 'ALG', 'group': 'J', 'ranking': 33, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/rrwpry1455218381.png', 'coach': 'Vladimir Petković'},
    {'id': '136477', 'name': 'Jordan', 'code': 'JOR', 'group': 'J', 'ranking': 43, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/default.png', 'coach': 'Jamal Sellawi'},

    // Group K
    {'id': '133908', 'name': 'Portugal', 'code': 'POR', 'group': 'K', 'ranking': 6, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/swqvpy1455466083.png', 'coach': 'Roberto Martínez'},
    {'id': '134501', 'name': 'Colombia', 'code': 'COL', 'group': 'K', 'ranking': 10, 'confederation': 'CONMEBOL', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/4ymyku1691180081.png', 'coach': 'Néstor Lorenzo'},
    {'id': '136477', 'name': 'DR Congo', 'code': 'COD', 'group': 'K', 'ranking': 42, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/default.png', 'coach': 'Sébastien Desabre'},
    {'id': '134537', 'name': 'Uzbekistan', 'code': 'UZB', 'group': 'K', 'ranking': 49, 'confederation': 'AFC', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/default.png', 'coach': 'Srečko Katanec'},

    // Group L
    {'id': '133914', 'name': 'England', 'code': 'ENG', 'group': 'L', 'ranking': 4, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/vf5ttc1726166739.png', 'coach': 'Thomas Tuchel'},
    {'id': '134513', 'name': 'Ghana', 'code': 'GHA', 'group': 'L', 'ranking': 38, 'confederation': 'CAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/j589xw1751526124.png', 'coach': 'Otto Addo'},
    {'id': '134533', 'name': 'Panama', 'code': 'PAN', 'group': 'L', 'ranking': 39, 'confederation': 'CONCACAF', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/default.png', 'coach': 'Thomas Christiansen'},
    {'id': '133912', 'name': 'Croatia', 'code': 'CRO', 'group': 'L', 'ranking': 10, 'confederation': 'UEFA', 'flag': 'https://r2.thesportsdb.com/images/media/team/badge/vvtsyu1455465317.png', 'coach': 'Zlatko Dalić'},
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
    {'id': '15', 'name': 'Arrowhead Stadium', 'city': 'Kansas City, MO', 'country': 'USA', 'capacity': 76416, 'latitude': 39.0489, 'longitude': -94.4839},
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

  static final Map<String, Map<String, Map<String, int>>> _standingsData = {
    'A': {
      '134497': {'p': 2, 'w': 2, 'd': 0, 'l': 0, 'gf': 3, 'ga': 0, 'pts': 6},
      '134517': {'p': 2, 'w': 1, 'd': 0, 'l': 1, 'gf': 2, 'ga': 2, 'pts': 3},
      '133904': {'p': 2, 'w': 0, 'd': 1, 'l': 1, 'gf': 2, 'ga': 3, 'pts': 1},
      '136482': {'p': 2, 'w': 0, 'd': 1, 'l': 1, 'gf': 1, 'ga': 3, 'pts': 1},
    },
    'B': {
      '140073': {'p': 2, 'w': 1, 'd': 1, 'l': 0, 'gf': 7, 'ga': 1, 'pts': 4},
      '134506': {'p': 2, 'w': 1, 'd': 1, 'l': 0, 'gf': 5, 'ga': 2, 'pts': 4},
      '134510': {'p': 2, 'w': 0, 'd': 1, 'l': 1, 'gf': 2, 'ga': 5, 'pts': 1},
      '134535': {'p': 2, 'w': 0, 'd': 1, 'l': 1, 'gf': 1, 'ga': 7, 'pts': 1},
    },
    'C': {
      '134496': {'p': 2, 'w': 1, 'd': 1, 'l': 0, 'gf': 4, 'ga': 1, 'pts': 4},
      '136139': {'p': 2, 'w': 1, 'd': 1, 'l': 0, 'gf': 2, 'ga': 1, 'pts': 4},
      '136450': {'p': 2, 'w': 1, 'd': 0, 'l': 1, 'gf': 1, 'ga': 1, 'pts': 3},
      '136471': {'p': 2, 'w': 0, 'd': 0, 'l': 2, 'gf': 0, 'ga': 4, 'pts': 0},
    },
    'D': {
      '134514': {'p': 2, 'w': 2, 'd': 0, 'l': 0, 'gf': 6, 'ga': 1, 'pts': 6},
      '134500': {'p': 2, 'w': 1, 'd': 0, 'l': 1, 'gf': 2, 'ga': 2, 'pts': 3},
      '136471': {'p': 2, 'w': 1, 'd': 0, 'l': 1, 'gf': 2, 'ga': 4, 'pts': 3},
      '135982': {'p': 2, 'w': 0, 'd': 0, 'l': 2, 'gf': 0, 'ga': 3, 'pts': 0},
    },
    'E': {
      '133907': {'p': 2, 'w': 2, 'd': 0, 'l': 0, 'gf': 9, 'ga': 2, 'pts': 6},
      '136141': {'p': 2, 'w': 1, 'd': 0, 'l': 1, 'gf': 2, 'ga': 2, 'pts': 3},
      '134507': {'p': 2, 'w': 0, 'd': 1, 'l': 1, 'gf': 0, 'ga': 1, 'pts': 1},
      '136477': {'p': 2, 'w': 0, 'd': 1, 'l': 1, 'gf': 1, 'ga': 7, 'pts': 1},
    },
    'F': {
      '133905': {'p': 2, 'w': 1, 'd': 1, 'l': 0, 'gf': 7, 'ga': 3, 'pts': 4},
      '134503': {'p': 2, 'w': 1, 'd': 1, 'l': 0, 'gf': 6, 'ga': 2, 'pts': 4},
      '136516': {'p': 2, 'w': 1, 'd': 0, 'l': 1, 'gf': 6, 'ga': 6, 'pts': 3},
      '136142': {'p': 2, 'w': 0, 'd': 0, 'l': 2, 'gf': 1, 'ga': 9, 'pts': 0},
    },
    'G': {
      '136138': {'p': 2, 'w': 1, 'd': 1, 'l': 0, 'gf': 4, 'ga': 2, 'pts': 4},
      '134511': {'p': 2, 'w': 0, 'd': 2, 'l': 0, 'gf': 2, 'ga': 2, 'pts': 2},
      '134515': {'p': 2, 'w': 0, 'd': 2, 'l': 0, 'gf': 1, 'ga': 1, 'pts': 2},
      '136517': {'p': 2, 'w': 0, 'd': 1, 'l': 1, 'gf': 3, 'ga': 5, 'pts': 1},
    },
    'H': {
      '133909': {'p': 2, 'w': 1, 'd': 1, 'l': 0, 'gf': 4, 'ga': 0, 'pts': 4},
      '134504': {'p': 2, 'w': 0, 'd': 2, 'l': 0, 'gf': 3, 'ga': 3, 'pts': 2},
      '136477': {'p': 2, 'w': 0, 'd': 2, 'l': 0, 'gf': 2, 'ga': 2, 'pts': 2},
      '134527': {'p': 2, 'w': 0, 'd': 1, 'l': 1, 'gf': 1, 'ga': 5, 'pts': 1},
    },
    'I': {
      '133913': {'p': 2, 'w': 2, 'd': 0, 'l': 0, 'gf': 6, 'ga': 1, 'pts': 6},
      '136516': {'p': 2, 'w': 2, 'd': 0, 'l': 0, 'gf': 7, 'ga': 3, 'pts': 6},
      '136143': {'p': 2, 'w': 0, 'd': 0, 'l': 2, 'gf': 3, 'ga': 6, 'pts': 0},
      '134520': {'p': 2, 'w': 0, 'd': 0, 'l': 2, 'gf': 1, 'ga': 7, 'pts': 0},
    },
    'J': {
      '134509': {'p': 2, 'w': 2, 'd': 0, 'l': 0, 'gf': 5, 'ga': 0, 'pts': 6},
      '135986': {'p': 2, 'w': 1, 'd': 0, 'l': 1, 'gf': 3, 'ga': 3, 'pts': 3},
      '134516': {'p': 2, 'w': 1, 'd': 0, 'l': 1, 'gf': 2, 'ga': 4, 'pts': 3},
      '136477': {'p': 2, 'w': 0, 'd': 0, 'l': 2, 'gf': 2, 'ga': 5, 'pts': 0},
    },
    'K': {
      '133908': {'p': 2, 'w': 1, 'd': 1, 'l': 0, 'gf': 6, 'ga': 1, 'pts': 4},
      '134501': {'p': 2, 'w': 1, 'd': 0, 'l': 0, 'gf': 3, 'ga': 1, 'pts': 3},
      '136477': {'p': 2, 'w': 0, 'd': 1, 'l': 1, 'gf': 1, 'ga': 1, 'pts': 1},
      '134537': {'p': 2, 'w': 0, 'd': 0, 'l': 2, 'gf': 1, 'ga': 8, 'pts': 0},
    },
    'L': {
      '133914': {'p': 2, 'w': 1, 'd': 0, 'l': 1, 'gf': 6, 'ga': 4, 'pts': 3},
      '134513': {'p': 2, 'w': 1, 'd': 0, 'l': 1, 'gf': 1, 'ga': 0, 'pts': 3},
      '134533': {'p': 2, 'w': 0, 'd': 0, 'l': 2, 'gf': 0, 'ga': 3, 'pts': 0},
      '133912': {'p': 2, 'w': 0, 'd': 0, 'l': 2, 'gf': 2, 'ga': 6, 'pts': 0},
    },
  };

  static List<GroupModel> getGroups() {
    final teams = getTeams();
    final Map<String, List<TeamModel>> teamsByGroup = {};

    for (final team in teams) {
      final groupLetter = team.group ?? 'A';
      teamsByGroup.putIfAbsent(groupLetter, () => []);
      teamsByGroup[groupLetter]!.add(team);
    }

    final groups = <GroupModel>[];
    final sortedKeys = teamsByGroup.keys.toList()..sort();

    for (final key in sortedKeys) {
      final groupTeams = teamsByGroup[key]!;
      final standings = _standingsData[key] ?? {};

      final standingsList = <StandingModel>[];
      for (final team in groupTeams) {
        final stats = standings[team.id] ?? {'p': 0, 'w': 0, 'd': 0, 'l': 0, 'gf': 0, 'ga': 0, 'pts': 0};
        final gd = (stats['gf'] ?? 0) - (stats['ga'] ?? 0);
        standingsList.add(StandingModel(
          teamId: team.id,
          team: team,
          played: stats['p'] ?? 0,
          won: stats['w'] ?? 0,
          drawn: stats['d'] ?? 0,
          lost: stats['l'] ?? 0,
          goalsFor: stats['gf'] ?? 0,
          goalsAgainst: stats['ga'] ?? 0,
          goalDifference: gd,
          points: stats['pts'] ?? 0,
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
        id: key,
        name: key,
        teams: standingsList,
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
