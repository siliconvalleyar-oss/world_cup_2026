import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/presentation/providers/match_provider.dart';
import 'package:world_cup_2026/presentation/widgets/empty_state.dart';

class KnockoutScreen extends ConsumerWidget {
  const KnockoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final knockoutMatches = ref.watch(knockoutMatchesProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        title: const Text(
          'Knockout Stage',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: knockoutMatches.when(
        data: (matches) {
          if (matches.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, size: 64, color: AppConstants.secondaryTextColor),
                  SizedBox(height: 16),
                  Text('No knockout matches yet', style: TextStyle(color: AppConstants.secondaryTextColor, fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Knockout stage will begin after Matchday 3', style: TextStyle(color: AppConstants.secondaryTextColor)),
                ],
              ),
            );
          }
          return _buildMenu(context, matches);
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor)),
        error: (_, __) => const Center(child: EmptyState(icon: Icons.wifi_off, title: 'Connection error', subtitle: 'Pull to refresh')),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, List<dynamic> matches) {
    final r32 = matches.where((m) => m.stage == 'round_of_32').length;
    final r16 = matches.where((m) => m.stage == 'round_of_16').length;
    final qf = matches.where((m) => m.stage == 'quarter_final').length;
    final sf = matches.where((m) => m.stage == 'semi_final').length;
    final fin = matches.where((m) => m.stage == 'final').length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _menuCard(
          context,
          icon: Icons.account_tree,
          title: 'Tournament Bracket',
          subtitle: 'View the full knockout tree',
          color: AppConstants.primaryColor,
          onTap: () => context.push('/bracket-tree'),
        ),
        const SizedBox(height: 16),
        _menuCard(
          context,
          icon: Icons.sports,
          title: 'Round of 32',
          subtitle: '$r32 matches',
          color: AppConstants.secondaryColor,
          onTap: () => context.push('/bracket-tree'),
        ),
        const SizedBox(height: 12),
        if (r16 > 0) _menuCard(context, icon: Icons.sports, title: 'Round of 16', subtitle: '$r16 matches', color: AppConstants.secondaryColor, onTap: () => context.push('/bracket-tree')),
        if (r16 > 0) const SizedBox(height: 12),
        if (qf > 0) _menuCard(context, icon: Icons.sports, title: 'Quarter-Finals', subtitle: '$qf matches', color: AppConstants.secondaryColor, onTap: () => context.push('/bracket-tree')),
        if (qf > 0) const SizedBox(height: 12),
        if (sf > 0) _menuCard(context, icon: Icons.sports, title: 'Semi-Finals', subtitle: '$sf matches', color: AppConstants.secondaryColor, onTap: () => context.push('/bracket-tree')),
        if (sf > 0) const SizedBox(height: 12),
        if (fin > 0) _menuCard(context, icon: Icons.emoji_events, title: 'Final', subtitle: '1 match', color: const Color(0xFFFFD700), onTap: () => context.push('/bracket-tree')),
      ],
    );
  }

  Widget _menuCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConstants.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: AppConstants.secondaryTextColor, fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }
}
