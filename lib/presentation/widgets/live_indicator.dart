import 'package:flutter/material.dart';

import '../../core/design_system/app_colors.dart';
import '../../core/design_system/app_typography.dart';

class LiveIndicator extends StatefulWidget {
  final double size;
  final bool showText;
  final Color color;

  const LiveIndicator({
    super.key,
    this.size = 8,
    this.showText = true,
    this.color = AppColors.liveIndicator,
  });

  @override
  State<LiveIndicator> createState() => _LiveIndicatorState();
}

class _LiveIndicatorState extends State<LiveIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withOpacity(_animation.value),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(_animation.value * 0.6),
                    blurRadius: widget.size * 0.8,
                    spreadRadius: 0,
                  ),
                ],
              ),
            );
          },
        ),
        if (widget.showText) ...[
          const SizedBox(width: 6),
          Text(
            'LIVE',
            style: AppTypography.labelSmall.copyWith(
              color: widget.color,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}
