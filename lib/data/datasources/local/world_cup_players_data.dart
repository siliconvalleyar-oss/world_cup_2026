import 'package:world_cup_2026/data/models/player_model.dart';

class WorldCupPlayersData {
  WorldCupPlayersData._();

  static final List<PlayerModel> _players = [
    // Argentina
    PlayerModel(id: 'p001', name: 'Lionel Messi', position: 'Forward', number: 10, age: 38, nationality: 'Argentina', teamId: '134509', teamName: 'Argentina', goals: 2, assists: 3, minutesPlayed: 270),
    PlayerModel(id: 'p002', name: 'Julián Álvarez', position: 'Forward', number: 9, age: 26, nationality: 'Argentina', teamId: '134509', teamName: 'Argentina', goals: 3, assists: 1, minutesPlayed: 250),
    PlayerModel(id: 'p003', name: 'Emiliano Martínez', position: 'Goalkeeper', number: 23, age: 33, nationality: 'Argentina', teamId: '134509', teamName: 'Argentina', goals: 0, assists: 0, minutesPlayed: 270),
    PlayerModel(id: 'p004', name: 'Enzo Fernández', position: 'Midfielder', number: 8, age: 24, nationality: 'Argentina', teamId: '134509', teamName: 'Argentina', goals: 1, assists: 2, minutesPlayed: 260),
    PlayerModel(id: 'p005', name: 'Alexis Mac Allister', position: 'Midfielder', number: 7, age: 27, nationality: 'Argentina', teamId: '134509', teamName: 'Argentina', goals: 1, assists: 1, minutesPlayed: 240),

    // Brazil
    PlayerModel(id: 'p006', name: 'Vinícius Júnior', position: 'Forward', number: 11, age: 25, nationality: 'Brazil', teamId: '134496', teamName: 'Brazil', goals: 3, assists: 2, minutesPlayed: 260),
    PlayerModel(id: 'p007', name: 'Rodrygo', position: 'Forward', number: 7, age: 24, nationality: 'Brazil', teamId: '134496', teamName: 'Brazil', goals: 2, assists: 1, minutesPlayed: 230),
    PlayerModel(id: 'p008', name: 'Alisson', position: 'Goalkeeper', number: 1, age: 33, nationality: 'Brazil', teamId: '134496', teamName: 'Brazil', goals: 0, assists: 0, minutesPlayed: 270),
    PlayerModel(id: 'p009', name: 'Lucas Paquetá', position: 'Midfielder', number: 10, age: 27, nationality: 'Brazil', teamId: '134496', teamName: 'Brazil', goals: 1, assists: 3, minutesPlayed: 250),
    PlayerModel(id: 'p010', name: 'Marquinhos', position: 'Defender', number: 4, age: 31, nationality: 'Brazil', teamId: '134496', teamName: 'Brazil', goals: 0, assists: 0, minutesPlayed: 270),

    // France
    PlayerModel(id: 'p011', name: 'Kylian Mbappé', position: 'Forward', number: 10, age: 27, nationality: 'France', teamId: '133909', teamName: 'France', goals: 4, assists: 1, minutesPlayed: 250),
    PlayerModel(id: 'p012', name: 'Antoine Griezmann', position: 'Forward', number: 7, age: 35, nationality: 'France', teamId: '133909', teamName: 'France', goals: 2, assists: 3, minutesPlayed: 260),
    PlayerModel(id: 'p013', name: 'Mike Maignan', position: 'Goalkeeper', number: 16, age: 30, nationality: 'France', teamId: '133909', teamName: 'France', goals: 0, assists: 0, minutesPlayed: 270),
    PlayerModel(id: 'p014', name: 'Aurélien Tchouaméni', position: 'Midfielder', number: 8, age: 26, nationality: 'France', teamId: '133909', teamName: 'France', goals: 1, assists: 0, minutesPlayed: 240),
    PlayerModel(id: 'p015', name: 'Ousmane Dembélé', position: 'Forward', number: 11, age: 28, nationality: 'France', teamId: '133909', teamName: 'France', goals: 2, assists: 2, minutesPlayed: 220),

    // Germany
    PlayerModel(id: 'p016', name: 'Florian Wirtz', position: 'Midfielder', number: 10, age: 22, nationality: 'Germany', teamId: '133907', teamName: 'Germany', goals: 3, assists: 2, minutesPlayed: 260),
    PlayerModel(id: 'p017', name: 'Jamal Musiala', position: 'Midfielder', number: 42, age: 22, nationality: 'Germany', teamId: '133907', teamName: 'Germany', goals: 2, assists: 3, minutesPlayed: 270),
    PlayerModel(id: 'p018', name: 'Manuel Neuer', position: 'Goalkeeper', number: 1, age: 40, nationality: 'Germany', teamId: '133907', teamName: 'Germany', goals: 0, assists: 0, minutesPlayed: 270),
    PlayerModel(id: 'p019', name: 'Kai Havertz', position: 'Forward', number: 29, age: 26, nationality: 'Germany', teamId: '133907', teamName: 'Germany', goals: 2, assists: 1, minutesPlayed: 230),
    PlayerModel(id: 'p020', name: 'Toni Kroos', position: 'Midfielder', number: 8, age: 36, nationality: 'Germany', teamId: '133907', teamName: 'Germany', goals: 0, assists: 4, minutesPlayed: 250),

    // Spain
    PlayerModel(id: 'p021', name: 'Pedri', position: 'Midfielder', number: 8, age: 23, nationality: 'Spain', teamId: '134504', teamName: 'Spain', goals: 1, assists: 3, minutesPlayed: 260),
    PlayerModel(id: 'p022', name: 'Lamine Yamal', position: 'Forward', number: 19, age: 18, nationality: 'Spain', teamId: '134504', teamName: 'Spain', goals: 2, assists: 2, minutesPlayed: 240),
    PlayerModel(id: 'p023', name: 'Unai Simón', position: 'Goalkeeper', number: 23, age: 28, nationality: 'Spain', teamId: '134504', teamName: 'Spain', goals: 0, assists: 0, minutesPlayed: 270),
    PlayerModel(id: 'p024', name: 'Gavi', position: 'Midfielder', number: 6, age: 21, nationality: 'Spain', teamId: '134504', teamName: 'Spain', goals: 1, assists: 1, minutesPlayed: 200),
    PlayerModel(id: 'p025', name: 'Nico Williams', position: 'Forward', number: 17, age: 23, nationality: 'Spain', teamId: '134504', teamName: 'Spain', goals: 3, assists: 1, minutesPlayed: 250),

    // England
    PlayerModel(id: 'p026', name: 'Jude Bellingham', position: 'Midfielder', number: 5, age: 22, nationality: 'England', teamId: '134499', teamName: 'England', goals: 3, assists: 2, minutesPlayed: 270),
    PlayerModel(id: 'p027', name: 'Bukayo Saka', position: 'Forward', number: 7, age: 24, nationality: 'England', teamId: '134499', teamName: 'England', goals: 2, assists: 3, minutesPlayed: 250),
    PlayerModel(id: 'p028', name: 'Jordan Pickford', position: 'Goalkeeper', number: 1, age: 32, nationality: 'England', teamId: '134499', teamName: 'England', goals: 0, assists: 0, minutesPlayed: 270),
    PlayerModel(id: 'p029', name: 'Phil Foden', position: 'Midfielder', number: 20, age: 26, nationality: 'England', teamId: '134499', teamName: 'England', goals: 1, assists: 2, minutesPlayed: 230),
    PlayerModel(id: 'p030', name: 'Harry Kane', position: 'Forward', number: 9, age: 32, nationality: 'England', teamId: '134499', teamName: 'England', goals: 4, assists: 1, minutesPlayed: 260),

    // Portugal
    PlayerModel(id: 'p031', name: 'Cristiano Ronaldo', position: 'Forward', number: 7, age: 41, nationality: 'Portugal', teamId: '134502', teamName: 'Portugal', goals: 3, assists: 0, minutesPlayed: 250),
    PlayerModel(id: 'p032', name: 'Bruno Fernandes', position: 'Midfielder', number: 8, age: 31, nationality: 'Portugal', teamId: '134502', teamName: 'Portugal', goals: 2, assists: 4, minutesPlayed: 270),
    PlayerModel(id: 'p033', name: 'Diogo Costa', position: 'Goalkeeper', number: 1, age: 26, nationality: 'Portugal', teamId: '134502', teamName: 'Portugal', goals: 0, assists: 0, minutesPlayed: 270),
    PlayerModel(id: 'p034', name: 'Bernardo Silva', position: 'Midfielder', number: 10, age: 31, nationality: 'Portugal', teamId: '134502', teamName: 'Portugal', goals: 1, assists: 2, minutesPlayed: 260),
    PlayerModel(id: 'p035', name: 'Rafael Leão', position: 'Forward', number: 17, age: 26, nationality: 'Portugal', teamId: '134502', teamName: 'Portugal', goals: 2, assists: 1, minutesPlayed: 220),

    // Netherlands
    PlayerModel(id: 'p036', name: 'Virgil van Dijk', position: 'Defender', number: 4, age: 34, nationality: 'Netherlands', teamId: '134505', teamName: 'Netherlands', goals: 0, assists: 0, minutesPlayed: 270),
    PlayerModel(id: 'p037', name: 'Memphis Depay', position: 'Forward', number: 10, age: 32, nationality: 'Netherlands', teamId: '134505', teamName: 'Netherlands', goals: 2, assists: 1, minutesPlayed: 230),
    PlayerModel(id: 'p038', name: 'Frenkie de Jong', position: 'Midfielder', number: 21, age: 29, nationality: 'Netherlands', teamId: '134505', teamName: 'Netherlands', goals: 0, assists: 2, minutesPlayed: 250),
    PlayerModel(id: 'p039', name: 'Cody Gakpo', position: 'Forward', number: 18, age: 26, nationality: 'Netherlands', teamId: '134505', teamName: 'Netherlands', goals: 3, assists: 1, minutesPlayed: 240),
    PlayerModel(id: 'p040', name: 'Bart Verbruggen', position: 'Goalkeeper', number: 1, age: 23, nationality: 'Netherlands', teamId: '134505', teamName: 'Netherlands', goals: 0, assists: 0, minutesPlayed: 270),

    // Italy
    PlayerModel(id: 'p041', name: 'Federico Chiesa', position: 'Forward', number: 14, age: 28, nationality: 'Italy', teamId: '134511', teamName: 'Italy', goals: 2, assists: 1, minutesPlayed: 230),
    PlayerModel(id: 'p042', name: 'Gianluigi Donnarumma', position: 'Goalkeeper', number: 1, age: 27, nationality: 'Italy', teamId: '134511', teamName: 'Italy', goals: 0, assists: 0, minutesPlayed: 270),
    PlayerModel(id: 'p043', name: 'Nicolò Barella', position: 'Midfielder', number: 18, age: 29, nationality: 'Italy', teamId: '134511', teamName: 'Italy', goals: 1, assists: 2, minutesPlayed: 260),
    PlayerModel(id: 'p044', name: 'Sandro Tonali', position: 'Midfielder', number: 8, age: 26, nationality: 'Italy', teamId: '134511', teamName: 'Italy', goals: 0, assists: 1, minutesPlayed: 220),
    PlayerModel(id: 'p045', name: 'Giacomo Raspadori', position: 'Forward', number: 22, age: 26, nationality: 'Italy', teamId: '134511', teamName: 'Italy', goals: 1, assists: 0, minutesPlayed: 200),

    // Belgium
    PlayerModel(id: 'p046', name: 'Kevin De Bruyne', position: 'Midfielder', number: 7, age: 35, nationality: 'Belgium', teamId: '134515', teamName: 'Belgium', goals: 1, assists: 3, minutesPlayed: 240),
    PlayerModel(id: 'p047', name: 'Romelu Lukaku', position: 'Forward', number: 9, age: 33, nationality: 'Belgium', teamId: '134515', teamName: 'Belgium', goals: 2, assists: 0, minutesPlayed: 230),
    PlayerModel(id: 'p048', name: 'Thibaut Courtois', position: 'Goalkeeper', number: 1, age: 34, nationality: 'Belgium', teamId: '134515', teamName: 'Belgium', goals: 0, assists: 0, minutesPlayed: 270),
    PlayerModel(id: 'p049', name: 'Jérémy Doku', position: 'Forward', number: 11, age: 23, nationality: 'Belgium', teamId: '134515', teamName: 'Belgium', goals: 1, assists: 2, minutesPlayed: 220),
    PlayerModel(id: 'p050', name: 'Youri Tielemans', position: 'Midfielder', number: 8, age: 29, nationality: 'Belgium', teamId: '134515', teamName: 'Belgium', goals: 0, assists: 1, minutesPlayed: 250),

    // USA
    PlayerModel(id: 'p051', name: 'Christian Pulisic', position: 'Forward', number: 10, age: 27, nationality: 'USA', teamId: '134514', teamName: 'USA', goals: 3, assists: 2, minutesPlayed: 260),
    PlayerModel(id: 'p052', name: 'Weston McKennie', position: 'Midfielder', number: 8, age: 27, nationality: 'USA', teamId: '134514', teamName: 'USA', goals: 1, assists: 1, minutesPlayed: 250),
    PlayerModel(id: 'p053', name: 'Matt Turner', position: 'Goalkeeper', number: 1, age: 31, nationality: 'USA', teamId: '134514', teamName: 'USA', goals: 0, assists: 0, minutesPlayed: 270),
    PlayerModel(id: 'p054', name: 'Giovanni Reyna', position: 'Midfielder', number: 7, age: 23, nationality: 'USA', teamId: '134514', teamName: 'USA', goals: 2, assists: 3, minutesPlayed: 230),
    PlayerModel(id: 'p055', name: 'Timothy Weah', position: 'Forward', number: 22, age: 26, nationality: 'USA', teamId: '134514', teamName: 'USA', goals: 1, assists: 1, minutesPlayed: 220),

    // Mexico
    PlayerModel(id: 'p056', name: 'Hirving Lozano', position: 'Forward', number: 22, age: 30, nationality: 'Mexico', teamId: '134497', teamName: 'Mexico', goals: 2, assists: 1, minutesPlayed: 250),
    PlayerModel(id: 'p057', name: 'Edson Álvarez', position: 'Midfielder', number: 4, age: 28, nationality: 'Mexico', teamId: '134497', teamName: 'Mexico', goals: 0, assists: 1, minutesPlayed: 270),
    PlayerModel(id: 'p058', name: 'Guillermo Ochoa', position: 'Goalkeeper', number: 13, age: 41, nationality: 'Mexico', teamId: '134497', teamName: 'Mexico', goals: 0, assists: 0, minutesPlayed: 270),
    PlayerModel(id: 'p059', name: 'Raúl Jiménez', position: 'Forward', number: 9, age: 35, nationality: 'Mexico', teamId: '134497', teamName: 'Mexico', goals: 1, assists: 0, minutesPlayed: 200),
    PlayerModel(id: 'p060', name: 'Carlos Rodríguez', position: 'Midfielder', number: 10, age: 28, nationality: 'Mexico', teamId: '134497', teamName: 'Mexico', goals: 1, assists: 2, minutesPlayed: 240),

    // Uruguay
    PlayerModel(id: 'p061', name: 'Luis Suárez', position: 'Forward', number: 9, age: 39, nationality: 'Uruguay', teamId: '134522', teamName: 'Uruguay', goals: 2, assists: 1, minutesPlayed: 200),
    PlayerModel(id: 'p062', name: 'Darwin Núñez', position: 'Forward', number: 19, age: 27, nationality: 'Uruguay', teamId: '134522', teamName: 'Uruguay', goals: 3, assists: 0, minutesPlayed: 250),
    PlayerModel(id: 'p063', name: 'Federico Valverde', position: 'Midfielder', number: 15, age: 27, nationality: 'Uruguay', teamId: '134522', teamName: 'Uruguay', goals: 1, assists: 2, minutesPlayed: 270),
    PlayerModel(id: 'p064', name: 'Ronald Araújo', position: 'Defender', number: 4, age: 27, nationality: 'Uruguay', teamId: '134522', teamName: 'Uruguay', goals: 0, assists: 0, minutesPlayed: 270),
    PlayerModel(id: 'p065', name: 'Sergio Rochet', position: 'Goalkeeper', number: 1, age: 33, nationality: 'Uruguay', teamId: '134522', teamName: 'Uruguay', goals: 0, assists: 0, minutesPlayed: 270),

    // Japan
    PlayerModel(id: 'p066', name: 'Takefusa Kubo', position: 'Forward', number: 20, age: 24, nationality: 'Japan', teamId: '134513', teamName: 'Japan', goals: 2, assists: 2, minutesPlayed: 250),
    PlayerModel(id: 'p067', name: 'Daichi Kamada', position: 'Midfielder', number: 10, age: 29, nationality: 'Japan', teamId: '134513', teamName: 'Japan', goals: 1, assists: 3, minutesPlayed: 260),
    PlayerModel(id: 'p068', name: 'Takehiro Tomiyasu', position: 'Defender', number: 2, age: 27, nationality: 'Japan', teamId: '134513', teamName: 'Japan', goals: 0, assists: 0, minutesPlayed: 270),
    PlayerModel(id: 'p069', name: 'Wataru Endo', position: 'Midfielder', number: 6, age: 33, nationality: 'Japan', teamId: '134513', teamName: 'Japan', goals: 0, assists: 1, minutesPlayed: 240),
    PlayerModel(id: 'p070', name: ' Zion Suzuki', position: 'Goalkeeper', number: 1, age: 23, nationality: 'Japan', teamId: '134513', teamName: 'Japan', goals: 0, assists: 0, minutesPlayed: 270),

    // South Korea
    PlayerModel(id: 'p071', name: 'Son Heung-min', position: 'Forward', number: 7, age: 33, nationality: 'South Korea', teamId: '134498', teamName: 'South Korea', goals: 3, assists: 1, minutesPlayed: 260),
    PlayerModel(id: 'p072', name: 'Lee Kang-in', position: 'Midfielder', number: 10, age: 24, nationality: 'South Korea', teamId: '134498', teamName: 'South Korea', goals: 1, assists: 2, minutesPlayed: 250),
    PlayerModel(id: 'p073', name: 'Kim Min-jae', position: 'Defender', number: 4, age: 29, nationality: 'South Korea', teamId: '134498', teamName: 'South Korea', goals: 0, assists: 0, minutesPlayed: 270),
    PlayerModel(id: 'p074', name: 'Hwang Hee-chan', position: 'Forward', number: 11, age: 30, nationality: 'South Korea', teamId: '134498', teamName: 'South Korea', goals: 2, assists: 1, minutesPlayed: 230),
    PlayerModel(id: 'p075', name: 'Jo Hyeon-woo', position: 'Goalkeeper', number: 21, age: 34, nationality: 'South Korea', teamId: '134498', teamName: 'South Korea', goals: 0, assists: 0, minutesPlayed: 270),
  ];

  static List<PlayerModel> getAll() => List.unmodifiable(_players);

  static List<PlayerModel> getByTeam(String teamId) =>
      _players.where((p) => p.teamId == teamId).toList();

  static PlayerModel? getById(String id) {
    try {
      return _players.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
