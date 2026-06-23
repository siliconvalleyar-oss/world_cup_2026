import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/design_system/app_colors.dart';

enum ShimmerPattern { listTile, card, textLine, circle, custom }

class ShimmerLoading extends StatelessWidget {
  final ShimmerPattern pattern;
  final Widget? customChild;
  final double? width;
  final double? height;

  const ShimmerLoading({
    super.key,
    this.pattern = ShimmerPattern.listTile,
    this.customChild,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: _buildPattern(),
    );
  }

  Widget _buildPattern() {
    switch (pattern) {
      case ShimmerPattern.listTile:
        return _buildListTile();
      case ShimmerPattern.card:
        return _buildCard();
      case ShimmerPattern.textLine:
        return _buildTextLine();
      case ShimmerPattern.circle:
        return _buildCircle();
      case ShimmerPattern.custom:
        return customChild ?? const SizedBox.shrink();
    }
  }

  Widget _buildListTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: height ?? 160,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildTextLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        height: height ?? 12,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildCircle() {
    return Container(
      width: width ?? 64,
      height: height ?? 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  static Widget listTile() => const ShimmerLoading(pattern: ShimmerPattern.listTile);
  static Widget card() => const ShimmerLoading(pattern: ShimmerPattern.card);
  static Widget textLine({double? width}) => ShimmerLoading(
        pattern: ShimmerPattern.textLine,
        width: width,
      );
  static Widget circle({double? size}) => ShimmerLoading(
        pattern: ShimmerPattern.circle,
        width: size,
        height: size,
      );
}
