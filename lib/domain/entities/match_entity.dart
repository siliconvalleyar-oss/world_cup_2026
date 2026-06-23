class MatchEntity {
  final String id;
  final String homeTeamId;
  final String awayTeamId;
  final String? homeTeamName;
  final String? awayTeamName;
  final int homeScore;
  final int awayScore;
  final String status;
  final int? matchday;
  final String? group;
  final String? venueName;
  final String? venueCity;
  final String? referee;
  final DateTime date;
  final String? time;
  final List<EventEntity> events;

  const MatchEntity({
    required this.id,
    required this.homeTeamId,
    required this.awayTeamId,
    this.homeTeamName,
    this.awayTeamName,
    this.homeScore = 0,
    this.awayScore = 0,
    this.status = 'scheduled',
    this.matchday,
    this.group,
    this.venueName,
    this.venueCity,
    this.referee,
    required this.date,
    this.time,
    this.events = const [],
  });

  String get scoreDisplay => '$homeScore - $awayScore';

  bool get isLive => status == 'live' || status == 'in_progress';

  bool get isFinished => status == 'finished' || status == 'completed';

  bool get isScheduled => status == 'scheduled';
}

class EventEntity {
  final String id;
  final String type;
  final int? minute;
  final String? playerId;
  final String? playerName;
  final String? teamId;
  final String? description;
  final bool extraTime;

  const EventEntity({
    required this.id,
    required this.type,
    this.minute,
    this.playerId,
    this.playerName,
    this.teamId,
    this.description,
    this.extraTime = false,
  });
}
