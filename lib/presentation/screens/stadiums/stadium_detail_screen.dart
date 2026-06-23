import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/data/models/venue_model.dart';
import 'package:world_cup_2026/presentation/providers/stadium_provider.dart';
import 'package:world_cup_2026/presentation/widgets/glassmorphism_card.dart';
import 'package:world_cup_2026/presentation/widgets/error_widget.dart';

class StadiumDetailScreen extends ConsumerWidget {
  final String stadiumId;

  const StadiumDetailScreen({super.key, required this.stadiumId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stadiumAsync = ref.watch(stadiumDetailProvider(stadiumId));

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: stadiumAsync.when(
        data: (stadium) {
          if (stadium == null) {
            return const Center(child: AppErrorWidget(message: 'Stadium not found'));
          }
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(stadium),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildStadiumInfo(stadium),
                    _buildLocationSection(stadium),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppConstants.primaryColor),
        ),
        error: (error, stack) => Center(
          child: AppErrorWidget(
            message: error.toString(),
            onRetry: () => ref.refresh(stadiumDetailProvider(stadiumId)),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(VenueModel stadium) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppConstants.backgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          stadium.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: stadium.image != null
            ? Image.network(
                stadium.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, url, error) => Container(
                  color: AppConstants.cardColor,
                  child: const Icon(Icons.stadium,
                      size: 80, color: AppConstants.secondaryTextColor),
                ),
              )
            : Container(
                color: AppConstants.cardColor,
                child: const Icon(Icons.stadium,
                    size: 80, color: AppConstants.secondaryTextColor),
              ),
      ),
    );
  }

  Widget _buildStadiumInfo(VenueModel stadium) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GlassmorphismCard(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (stadium.capacity != null)
                  _buildInfoItem(
                    Icons.people,
                    '${stadium.capacity}',
                    'Capacity',
                  ),
                _buildInfoItem(
                  Icons.location_on,
                  stadium.city,
                  'City',
                ),
                if (stadium.country != null)
                  _buildInfoItem(
                    Icons.flag,
                    stadium.country!,
                    'Country',
                  ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppConstants.primaryColor, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppConstants.secondaryTextColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection(VenueModel stadium) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          GlassmorphismCard(
            child: Column(
              children: [
                if (stadium.latitude != null && stadium.longitude != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: AppConstants.cardColor,
                      child: const Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.map,
                            size: 80,
                            color: AppConstants.secondaryTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  '${stadium.city}${stadium.country != null ? ', ${stadium.country}' : ''}',
                  style: const TextStyle(
                    color: AppConstants.secondaryTextColor,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }
}
