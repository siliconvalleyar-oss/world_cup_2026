import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/data/models/group_model.dart';
import 'package:world_cup_2026/data/models/match_model.dart';
import 'package:world_cup_2026/data/models/standing_model.dart';
import 'package:world_cup_2026/presentation/providers/standing_provider.dart';
import 'package:world_cup_2026/presentation/widgets/team_flag.dart';

class BracketTreeScreen extends ConsumerStatefulWidget {
  const BracketTreeScreen({super.key});

  @override
  ConsumerState<BracketTreeScreen> createState() => _BracketTreeScreenState();
}

class _BracketTreeScreenState extends ConsumerState<BracketTreeScreen> {
  static const double cw = 128;
  static const double ch = 52;
  static const double hGap = 38;
  static const double vGap = 10;
  static const double colW = cw + hGap;

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(groupListProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: groupsAsync.when(
        data: (groups) {
          if (groups.isEmpty) {
            return const Center(child: Text('Loading standings...', style: TextStyle(color: AppConstants.secondaryTextColor)));
          }
          return _buildBracketFromStandings(groups);
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor)),
        error: (_, __) => const Center(child: Text('Error loading data', style: TextStyle(color: AppConstants.secondaryTextColor))),
      ),
    );
  }

  Widget _buildBracketFromStandings(List<GroupModel> groups) {
    final bracket = _computeBracket(groups);
    final leftBracket = bracket['left']!;
    final rightBracket = bracket['right']!;
    final finalMatch = bracket['final']![0];
    final thirdMatch = bracket['third']![0];

    final ly = _yPos(8);
    final ly16 = _midY(4, ly);
    final lyQF = _midY(2, ly16);
    final lySF = _midY(1, lyQF);
    final ry = _yPos(8);
    final ry16 = _midY(4, ry);
    final ryQF = _midY(2, ry16);
    final rySF = _midY(1, ryQF);

    final totalH = ly.last + ch + 80;
    final finalCY = lySF.isNotEmpty && rySF.isNotEmpty
        ? (lySF[0] + rySF[0]) / 2
        : totalH / 2 - ch / 2;
    final thirdCY = finalCY + ch + 28;
    final totalW = 9 * colW + cw;

    return Column(
      children: [
        Container(
          height: 36,
          color: AppConstants.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _lbl('R32'), SizedBox(width: colW - 52),
              _lbl('R16'), SizedBox(width: colW - 52),
              _lbl('CF'), SizedBox(width: colW - 40),
              _lbl('SF'), SizedBox(width: colW - 30),
              _lbl('FINAL'), SizedBox(width: colW - 20),
              _lbl('SF'), SizedBox(width: colW - 40),
              _lbl('CF'), SizedBox(width: colW - 52),
              _lbl('R16'), SizedBox(width: colW - 52),
              _lbl('R32'),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: totalW,
                height: totalH,
                child: CustomPaint(
                  painter: _BracketPainter(
                    lR32Y: ly, lR16Y: ly16, lQFY: lyQF, lSFY: lySF,
                    rR32Y: ry, rR16Y: ry16, rQFY: ryQF, rSFY: rySF,
                    finalY: finalCY, cw: cw, ch: ch, hGap: hGap, colW: colW,
                    lineColor: AppConstants.secondaryTextColor.withValues(alpha: 0.25),
                  ),
                  child: Stack(
                    children: [
                      for (int i = 0; i < 8; i++) _at(0, ly[i], leftBracket[i]),
                      for (int i = 0; i < 4; i++) _at(1, ly16[i], _emptyMatch('lR16_$i')),
                      for (int i = 0; i < 2; i++) _at(2, lyQF[i], _emptyMatch('lQF_$i')),
                      _at(3, lySF.isNotEmpty ? lySF[0] : 0, _emptyMatch('lSF')),
                      _at(4, finalCY, finalMatch, isFinal: true),
                      _at(5, rySF.isNotEmpty ? rySF[0] : 0, _emptyMatch('rSF')),
                      for (int i = 0; i < 2; i++) _at(6, ryQF[i], _emptyMatch('rQF_$i')),
                      for (int i = 0; i < 4; i++) _at(7, ry16[i], _emptyMatch('rR16_$i')),
                      for (int i = 0; i < 8; i++) _at(8, ry[i], rightBracket[i]),
                      _at(4, thirdCY, thirdMatch, isThird: true),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Map<String, List<MatchModel>> _computeBracket(List<GroupModel> groups) {
    final groupMap = <String, List<StandingModel>>{};
    for (final g in groups) {
      final sorted = List<StandingModel>.from(g.teams)
        ..sort((a, b) {
          final cmp = b.points.compareTo(a.points);
          if (cmp != 0) return cmp;
          final cmp2 = b.goalDifference.compareTo(a.goalDifference);
          if (cmp2 != 0) return cmp2;
          return b.goalsFor.compareTo(a.goalsFor);
        });
      groupMap[g.id] = sorted;
    }

    final first = <String, StandingModel>{};
    final second = <String, StandingModel>{};
    final third = <StandingModel>[];

    for (final entry in groupMap.entries) {
      final teams = entry.value;
      if (teams.isNotEmpty) first[entry.key] = teams[0];
      if (teams.length >= 2) second[entry.key] = teams[1];
      if (teams.length >= 3) third.add(teams[2]);
    }

    third.sort((a, b) {
      final cmp = b.points.compareTo(a.points);
      if (cmp != 0) return cmp;
      final cmp2 = b.goalDifference.compareTo(a.goalDifference);
      if (cmp2 != 0) return cmp2;
      return b.goalsFor.compareTo(a.goalsFor);
    });
    final bestThird = third.take(8).toList();

    StandingModel? findFirst(String group) => first[group];
    StandingModel? findSecond(String group) => second[group];
    StandingModel? findThird(int index) => index < bestThird.length ? bestThird[index] : null;

    MatchModel buildMatch(String id, StandingModel? home, StandingModel? away, String stage) {
      return MatchModel(
        id: id,
        homeTeamId: home?.teamId ?? '',
        awayTeamId: away?.teamId ?? '',
        homeTeam: home?.team,
        awayTeam: away?.team,
        date: DateTime(2026, 7, 1),
        stage: stage,
      );
    }

    final left = [
      buildMatch('R32_01', findFirst('A'), findSecond('B'), 'round_of_32'),
      buildMatch('R32_02', findFirst('C'), findSecond('D'), 'round_of_32'),
      buildMatch('R32_03', findFirst('E'), findSecond('F'), 'round_of_32'),
      buildMatch('R32_04', findFirst('G'), findSecond('H'), 'round_of_32'),
      buildMatch('R32_05', findFirst('B'), findSecond('A'), 'round_of_32'),
      buildMatch('R32_06', findFirst('D'), findSecond('C'), 'round_of_32'),
      buildMatch('R32_07', findFirst('F'), findSecond('E'), 'round_of_32'),
      buildMatch('R32_08', findFirst('H'), findSecond('G'), 'round_of_32'),
    ];

    final right = [
      buildMatch('R32_09', findFirst('I'), findSecond('J'), 'round_of_32'),
      buildMatch('R32_10', findFirst('K'), findSecond('L'), 'round_of_32'),
      buildMatch('R32_11', findFirst('J'), findSecond('I'), 'round_of_32'),
      buildMatch('R32_12', findFirst('L'), findSecond('K'), 'round_of_32'),
      buildMatch('R32_13', findThird(0), findThird(1), 'round_of_32'),
      buildMatch('R32_14', findThird(2), findThird(3), 'round_of_32'),
      buildMatch('R32_15', findThird(4), findThird(5), 'round_of_32'),
      buildMatch('R32_16', findThird(6), findThird(7), 'round_of_32'),
    ];

    final finalMatch = buildMatch('FINAL', null, null, 'final');
    final thirdMatch = buildMatch('THIRD', null, null, 'third_place');

    return {'left': left, 'right': right, 'final': [finalMatch], 'third': [thirdMatch]};
  }

  List<double> _yPos(int n) => List.generate(n, (i) => i * (ch + vGap));
  List<double> _midY(int n, List<double> py) =>
      List.generate(n, (i) => (py[i * 2] + py[i * 2 + 1]) / 2);

  MatchModel _emptyMatch(String id) => MatchModel(
    id: id, homeTeamId: '', awayTeamId: '', date: DateTime(2026, 7, 10), stage: 'round_of_16',
  );

  Widget _lbl(String t) => Text(t, style: const TextStyle(color: AppConstants.primaryColor, fontSize: 10, fontWeight: FontWeight.bold));

  Widget _at(int col, double y, MatchModel m, {bool isFinal = false, bool isThird = false}) =>
      Positioned(left: col * colW, top: y, child: _card(m, isFinal: isFinal, isThird: isThird));

  Widget _card(MatchModel m, {bool isFinal = false, bool isThird = false}) {
    final finished = m.status == 'finished' || m.status == 'ft';
    final hw = finished && m.homeScore > m.awayScore;
    final aw = finished && m.awayScore > m.homeScore;
    final hasH = m.homeTeamId.isNotEmpty;
    final hasA = m.awayTeamId.isNotEmpty;
    final w = isFinal ? cw + 12 : cw;
    final h = isFinal ? ch + 12 : (isThird ? ch - 2 : ch);

    final bc = isFinal
        ? const Color(0xFFFFD700)
        : isThird
            ? AppConstants.primaryColor.withValues(alpha: 0.5)
            : AppConstants.secondaryColor.withValues(alpha: 0.2);

    return GestureDetector(
      onTap: () => context.push('/match/${m.id}'),
      child: Container(
        width: w, height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: bc, width: 1),
          color: isFinal ? const Color(0xFF1A1500) : isThird ? const Color(0xFF0A1520) : null,
          gradient: !isFinal && !isThird ? LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Colors.white.withValues(alpha: 0.06), Colors.white.withValues(alpha: 0.02)],
          ) : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _row(m.homeTeam?.name ?? (hasH ? '' : 'TBD'), m.homeTeam?.flag, m.homeScore, hw, hasH, finished),
            Container(height: 1, margin: const EdgeInsets.symmetric(vertical: 1), color: AppConstants.secondaryTextColor.withValues(alpha: 0.15)),
            _row(m.awayTeam?.name ?? (hasA ? '' : 'TBD'), m.awayTeam?.flag, m.awayScore, aw, hasA, finished),
          ],
        ),
      ),
    );
  }

  Widget _row(String name, String? flag, int score, bool win, bool filled, bool fin) {
    final empty = name.isEmpty;
    return Row(
      children: [
        if (!empty && flag != null)
          TeamFlag(imageUrl: flag, teamName: name, size: 14, shape: TeamFlagShape.circular, showBorder: false)
        else
          Container(width: 14, height: 14, decoration: BoxDecoration(color: AppConstants.cardColor, borderRadius: BorderRadius.circular(7)),
            child: const Icon(Icons.question_mark, size: 7, color: AppConstants.secondaryTextColor)),
        const SizedBox(width: 3),
        Expanded(
          child: Text(empty ? 'TBD' : name, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(color: win ? AppConstants.secondaryColor : empty ? AppConstants.secondaryTextColor : Colors.white,
              fontSize: 9, fontWeight: win ? FontWeight.bold : FontWeight.normal)),
        ),
        if (fin && !empty)
          Text('$score', style: TextStyle(color: win ? AppConstants.secondaryColor : Colors.white, fontSize: 10, fontWeight: FontWeight.bold))
        else if (!fin && !empty)
          const Text('-', style: TextStyle(color: AppConstants.secondaryTextColor, fontSize: 10))
        else
          const SizedBox(width: 10),
      ],
    );
  }
}

class _BracketPainter extends CustomPainter {
  final List<double> lR32Y, lR16Y, lQFY, lSFY;
  final List<double> rR32Y, rR16Y, rQFY, rSFY;
  final double finalY;
  final double cw, ch, hGap, colW;
  final Color lineColor;

  _BracketPainter({
    required this.lR32Y, required this.lR16Y, required this.lQFY, required this.lSFY,
    required this.rR32Y, required this.rR16Y, required this.rQFY, required this.rSFY,
    required this.finalY,
    required this.cw, required this.ch, required this.hGap, required this.colW,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = lineColor
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 4; i++) {
      _leftConn(canvas, p, 0, lR32Y[i * 2], lR32Y[i * 2 + 1], lR16Y[i]);
    }
    for (int i = 0; i < 2; i++) {
      _leftConn(canvas, p, 1, lR16Y[i * 2], lR16Y[i * 2 + 1], lQFY[i]);
    }
    if (lQFY.length >= 2) {
      _leftConn(canvas, p, 2, lQFY[0], lQFY[1], lSFY.isNotEmpty ? lSFY[0] : 0);
    }
    if (lSFY.isNotEmpty) {
      final x1 = 3 * colW + cw;
      final mx = x1 + hGap / 2;
      final y = lSFY[0] + ch / 2;
      final fy = finalY + (ch + 12) / 2;
      canvas.drawLine(Offset(x1, y), Offset(mx, y), p);
      canvas.drawLine(Offset(mx, y), Offset(mx, fy), p);
      canvas.drawLine(Offset(mx, fy), Offset(4 * colW, fy), p);
    }

    for (int i = 0; i < 4; i++) {
      _rightConn(canvas, p, 8, rR32Y[i * 2], rR32Y[i * 2 + 1], rR16Y[i]);
    }
    for (int i = 0; i < 2; i++) {
      _rightConn(canvas, p, 7, rR16Y[i * 2], rR16Y[i * 2 + 1], rQFY[i]);
    }
    if (rQFY.length >= 2) {
      _rightConn(canvas, p, 6, rQFY[0], rQFY[1], rSFY.isNotEmpty ? rSFY[0] : 0);
    }
    if (rSFY.isNotEmpty) {
      final x1 = 5 * colW;
      final mx = x1 - hGap / 2;
      final y = rSFY[0] + ch / 2;
      final fy = finalY + (ch + 12) / 2;
      canvas.drawLine(Offset(x1, y), Offset(mx, y), p);
      canvas.drawLine(Offset(mx, y), Offset(mx, fy), p);
      canvas.drawLine(Offset(mx, fy), Offset(5 * colW, fy), p);
    }
  }

  void _leftConn(Canvas canvas, Paint p, int col, double topY, double botY, double nextY) {
    final x1 = col * colW + cw;
    final mx = x1 + hGap / 2;
    final x2 = (col + 1) * colW;
    final ty = topY + ch / 2;
    final by = botY + ch / 2;
    final ny = nextY + ch / 2;

    canvas.drawLine(Offset(x1, ty), Offset(mx, ty), p);
    canvas.drawLine(Offset(x1, by), Offset(mx, by), p);
    canvas.drawLine(Offset(mx, ty), Offset(mx, by), p);
    canvas.drawLine(Offset(mx, ny), Offset(x2, ny), p);
  }

  void _rightConn(Canvas canvas, Paint p, int col, double topY, double botY, double nextY) {
    final x1 = col * colW;
    final mx = x1 - hGap / 2;
    final x2 = (col - 1) * colW + cw;
    final ty = topY + ch / 2;
    final by = botY + ch / 2;
    final ny = nextY + ch / 2;

    canvas.drawLine(Offset(x1, ty), Offset(mx, ty), p);
    canvas.drawLine(Offset(x1, by), Offset(mx, by), p);
    canvas.drawLine(Offset(mx, ty), Offset(mx, by), p);
    canvas.drawLine(Offset(mx, ny), Offset(x2, ny), p);
  }

  @override
  bool shouldRepaint(covariant _BracketPainter old) => false;
}
