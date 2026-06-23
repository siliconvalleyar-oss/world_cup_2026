import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/design_system/app_colors.dart';
import '../../core/design_system/app_radius.dart';

enum TeamFlagShape { circular, rectangular }

class TeamFlag extends StatelessWidget {
  final String? imageUrl;
  final String teamName;
  final double size;
  final TeamFlagShape shape;
  final bool showBorder;

  const TeamFlag({
    super.key,
    this.imageUrl,
    required this.teamName,
    this.size = 48,
    this.shape = TeamFlagShape.circular,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = shape == TeamFlagShape.circular
        ? BorderRadius.circular(size / 2)
        : AppRadius.sm;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: showBorder
            ? Border.all(
                color: AppColors.glassBorder,
                width: 1,
              )
            : null,
        color: AppColors.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => _buildPlaceholder(),
              errorWidget: (context, url, error) => _buildPlaceholder(),
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.card,
      child: Center(
        child: Text(
          teamName.isNotEmpty ? teamName[0].toUpperCase() : '?',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
