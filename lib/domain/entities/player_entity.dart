class PlayerEntity {
  final String id;
  final String name;
  final String? position;
  final int? number;
  final int? age;
  final String? nationality;
  final String? teamId;
  final String? teamName;
  final String? photo;
  final int goals;
  final int assists;
  final int minutesPlayed;
  final int yellowCards;
  final int redCards;

  const PlayerEntity({
    required this.id,
    required this.name,
    this.position,
    this.number,
    this.age,
    this.nationality,
    this.teamId,
    this.teamName,
    this.photo,
    this.goals = 0,
    this.assists = 0,
    this.minutesPlayed = 0,
    this.yellowCards = 0,
    this.redCards = 0,
  });

  int get totalCards => yellowCards + redCards;

  String get statsDisplay => '$goals G $assists A';
}
