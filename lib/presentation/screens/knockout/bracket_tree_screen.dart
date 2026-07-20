import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/data/models/match_model.dart';
import 'package:world_cup_2026/data/models/team_model.dart';
import 'package:world_cup_2026/presentation/providers/match_provider.dart';
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
    final matchesAsync = ref.watch(knockoutMatchesProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        title: const Text('Tournament Bracket', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: matchesAsync.when(
        data: (matches) {
          if (matches.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_tree, size: 64, color: AppConstants.secondaryTextColor),
                  SizedBox(height: 16),
                  Text('No knockout matches yet', style: TextStyle(color: AppConstants.secondaryTextColor, fontSize: 18)),
                ],
              ),
            );
          }
          return _buildBracket(matches);
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor)),
        error: (_, __) => const Center(child: Text('Error', style: TextStyle(color: AppConstants.secondaryTextColor))),
      ),
    );
  }

  Widget _buildBracket(List<MatchModel> allMatches) {
    final r32 = allMatches.where((m) => m.stage == 'round_of_32').toList();
    final r16 = allMatches.where((m) => m.stage == 'round_of_16').toList();
    final qf = allMatches.where((m) => m.stage == 'quarter_final').toList();
    final sf = allMatches.where((m) => m.stage == 'semi_final').toList();
    final finalMatch = allMatches.where((m) => m.stage == 'final').toList();
    final thirdMatch = allMatches.where((m) => m.stage == 'third_place').toList();

    if (r32.length < 16) {
      return const Center(child: Text('Bracket not ready', style: TextStyle(color: AppConstants.secondaryTextColor)));
    }

    final lR32 = r32.sublist(0, 8);
    final rR32 = r32.sublist(8, 16);
    final lR16 = r16.length >= 4 ? r16.sublist(0, 4) : List<MatchModel>.filled(4, _emptyMatch('R16_pending'));
    final rR16 = r16.length >= 8 ? r16.sublist(4, 8) : List<MatchModel>.filled(4, _emptyMatch('R16_pending'));
    final lQF = qf.length >= 2 ? qf.sublist(0, 2) : List<MatchModel>.filled(2, _emptyMatch('QF_pending'));
    final rQF = qf.length >= 4 ? qf.sublist(2, 4) : List<MatchModel>.filled(2, _emptyMatch('QF_pending'));
    final lSF = sf.isNotEmpty ? sf[0] : _emptyMatch('SF_pending');
    final rSF = sf.length >= 2 ? sf[1] : _emptyMatch('SF_pending');
    final fin = finalMatch.isNotEmpty ? finalMatch[0] : _emptyMatch('FINAL_pending');
    final third = thirdMatch.isNotEmpty ? thirdMatch[0] : _emptyMatch('THIRD_pending');

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
          height: 32,
          color: AppConstants.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              _lbl('R32'), SizedBox(width: colW - 52),
              _lbl('R16'), SizedBox(width: colW - 52),
              _lbl('QF'), SizedBox(width: colW - 40),
              _lbl('SF'), SizedBox(width: colW - 30),
              _lbl('FINAL'), SizedBox(width: colW - 20),
              _lbl('SF'), SizedBox(width: colW - 40),
              _lbl('QF'), SizedBox(width: colW - 52),
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
                    finalY: finalCY,
                    cw: cw, ch: ch, hGap: hGap, colW: colW,
                    lineColor: AppConstants.secondaryTextColor.withValues(alpha: 0.25),
                  ),
                  child: Stack(
                    children: [
                      for (int i = 0; i < 8; i++) _at(0, ly[i], lR32[i]),
                      for (int i = 0; i < 4; i++) _at(1, ly16[i], lR16[i]),
                      for (int i = 0; i < 2; i++) _at(2, lyQF[i], lQF[i]),
                      _at(3, lySF.isNotEmpty ? lySF[0] : 0, lSF),
                      _at(4, finalCY, fin, isFinal: true),
                      _at(5, rySF.isNotEmpty ? rySF[0] : 0, rSF),
                      for (int i = 0; i < 2; i++) _at(6, ryQF[i], rQF[i]),
                      for (int i = 0; i < 4; i++) _at(7, ry16[i], rR16[i]),
                      for (int i = 0; i < 8; i++) _at(8, ry[i], rR32[i]),
                      _at(4, thirdCY, third, isThird: true),
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

  List<double> _yPos(int n) => List.generate(n, (i) => i * (ch + vGap));

  List<double> _midY(int n, List<double> py) =>
      List.generate(n, (i) => (py[i * 2] + py[i * 2 + 1]) / 2);

  MatchModel _emptyMatch(String id) => MatchModel(
    id: id, homeTeamId: '', awayTeamId: '', date: DateTime(2026, 7, 10), stage: 'round_of_32',
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

    final bc = isFinal ? const Color(0xFFFFD700) : isThird ? AppConstants.primaryColor.withValues(alpha: 0.5) : AppConstants.secondaryColor.withValues(alpha: 0.2);

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
            _row(m.homeTeam, m.homeTeam?.name ?? (hasH ? '' : 'TBD'), m.homeTeam?.flag, m.homeScore, hw, hasH, finished),
            Container(height: 1, margin: const EdgeInsets.symmetric(vertical: 1), color: AppConstants.secondaryTextColor.withValues(alpha: 0.15)),
            _row(m.awayTeam, m.awayTeam?.name ?? (hasA ? '' : 'TBD'), m.awayTeam?.flag, m.awayScore, aw, hasA, finished),
          ],
        ),
      ),
    );
  }

  Widget _row(TeamModel? t, String name, String? flag, int score, bool win, bool filled, bool fin) {
    final empty = name.isEmpty || name == 'TBD';
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

    _drawLeftBracket(canvas, p);
    _drawRightBracket(canvas, p);
  }

  void _drawLeftBracket(Canvas canvas, Paint p) {
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
      final x2 = x1 + hGap / 2;
      final y = lSFY[0] + ch / 2;
      final fy = finalY + (ch + 12) / 2;
      canvas.drawLine(Offset(x1, y), Offset(x2, y), p);
      canvas.drawLine(Offset(x2, y), Offset(x2, fy), p);
      canvas.drawLine(Offset(x2, fy), Offset(4 * colW, fy), p);
    }
  }

  void _drawRightBracket(Canvas canvas, Paint p) {
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
      final x2 = x1 - hGap / 2;
      final y = rSFY[0] + ch / 2;
      final fy = finalY + (ch + 12) / 2;
      canvas.drawLine(Offset(x1, y), Offset(x2, y), p);
      canvas.drawLine(Offset(x2, y), Offset(x2, fy), p);
      canvas.drawLine(Offset(x2, fy), Offset(5 * colW, fy), p);
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
