class TeamEntity {
  final String id;
  final String name;
  final String? code;
  final String? flag;
  final String? confederation;
  final int? fifaRanking;
  final String? group;
  final String? coach;
  final int wins;
  final int draws;
  final int losses;
  final int goalsFor;
  final int goalsAgainst;
  final int points;

  const TeamEntity({
    required this.id,
    required this.name,
    this.code,
    this.flag,
    this.confederation,
    this.fifaRanking,
    this.group,
    this.coach,
    this.wins = 0,
    this.draws = 0,
    this.losses = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
    this.points = 0,
  });

  int get goalDifference => goalsFor - goalsAgainst;

  String get recordDisplay => '$wins-$draws-$losses';
}
