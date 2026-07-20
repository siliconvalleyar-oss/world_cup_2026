import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/design_system/app_colors.dart';
import '../providers/settings_provider.dart';

class LiquidBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const LiquidBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F5F5),
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [const Color(0xF20A0A0A), const Color(0xFF0A0A0A)]
                  : [const Color(0xF2F5F5F5), const Color(0xFFF5F5F5)],
            ),
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.glassBorder : const Color(0x22000000),
                width: 0.5,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (index) {
                final isSelected = index == currentIndex;
                return _buildItem(
                  item: _items[index],
                  isSelected: isSelected,
                  isDark: isDark,
                  onTap: () => onTap(index),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  static const _items = [
    _NavItem(icon: Icons.home_rounded, labelEn: 'Home', labelEs: 'Inicio'),
    _NavItem(icon: Icons.calendar_month_rounded, labelEn: 'Fixture', labelEs: 'Calendario'),
    _NavItem(icon: Icons.leaderboard_rounded, labelEn: 'Standings', labelEs: 'Posiciones'),
    _NavItem(icon: Icons.groups_rounded, labelEn: 'Teams', labelEs: 'Equipos'),
    _NavItem(icon: Icons.account_tree_rounded, labelEn: 'Bracket', labelEs: 'Arbol'),
  ];

  Widget _buildItem({
    required _NavItem item,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final label = SettingsNotifier.currentLanguage == 'es' ? item.labelEs : item.labelEn;
    final primaryColor = AppColors.primary;
    final secondaryTextColor = isDark ? AppColors.textSecondary : const Color(0xFF666666);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.all(8),
              decoration: isSelected
                  ? BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              child: Icon(
                item.icon,
                size: 24,
                color: isSelected ? primaryColor : secondaryTextColor,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? primaryColor : secondaryTextColor,
              ),
              child: Text(label),
            ),
          ],
        ),
      ).animate(target: isSelected ? 1 : 0).scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1.0, 1.0),
            duration: 200.ms,
            curve: Curves.easeOut,
          ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String labelEn;
  final String labelEs;

  const _NavItem({required this.icon, required this.labelEn, required this.labelEs});
}
