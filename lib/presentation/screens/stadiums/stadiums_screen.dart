import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/data/models/venue_model.dart';
import 'package:world_cup_2026/presentation/providers/stadium_provider.dart';
import 'package:world_cup_2026/presentation/widgets/glassmorphism_card.dart';
import 'package:world_cup_2026/presentation/widgets/empty_state.dart';
import 'package:world_cup_2026/presentation/widgets/shimmer_loading.dart';

class StadiumsScreen extends ConsumerStatefulWidget {
  const StadiumsScreen({super.key});

  @override
  ConsumerState<StadiumsScreen> createState() => _StadiumsScreenState();
}

class _StadiumsScreenState extends ConsumerState<StadiumsScreen> {
  bool _isGridView = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stadiumsAsync = ref.watch(stadiumListProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        title: const Text(
          'Stadiums',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list : Icons.grid_view,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() => _isGridView = !_isGridView);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: stadiumsAsync.when(
              data: (stadiums) {
                final filteredStadiums = _filterStadiums(stadiums);
                if (filteredStadiums.isEmpty) {
                  return const EmptyState(
                    icon: Icons.stadium,
                    title: 'No stadiums found',
                    subtitle: 'Try adjusting your search',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(stadiumListProvider.notifier).loadStadiums();
                  },
                  color: AppConstants.primaryColor,
                  backgroundColor: AppConstants.cardColor,
                  child: _isGridView
                      ? _buildGridView(filteredStadiums)
                      : _buildListView(filteredStadiums),
                );
              },
              loading: () => _isGridView
                  ? _buildGridShimmer()
                  : _buildListShimmer(),
              error: (_, __) => const Center(
                child: EmptyState(icon: Icons.wifi_off, title: 'Connection error', subtitle: 'Pull to refresh'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search stadiums...',
          hintStyle: const TextStyle(color: AppConstants.secondaryTextColor),
          prefixIcon:
              const Icon(Icons.search, color: AppConstants.primaryColor),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear,
                      color: AppConstants.secondaryTextColor),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: AppConstants.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppConstants.primaryColor),
          ),
        ),
      ),
    );
  }

  List<VenueModel> _filterStadiums(List<VenueModel> stadiums) {
    if (_searchQuery.isEmpty) return stadiums;
    final query = _searchQuery.toLowerCase();
    return stadiums.where((stadium) {
      return stadium.name.toLowerCase().contains(query) ||
          stadium.city.toLowerCase().contains(query) ||
          (stadium.country?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  Widget _buildGridView(List<VenueModel> stadiums) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: stadiums.length,
      itemBuilder: (context, index) {
        final stadium = stadiums[index];
        return _buildStadiumGridCard(stadium, index);
      },
    );
  }

  Widget _buildListView(List<VenueModel> stadiums) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stadiums.length,
      itemBuilder: (context, index) {
        final stadium = stadiums[index];
        return _buildStadiumListCard(stadium, index);
      },
    );
  }

  Widget _buildStadiumGridCard(VenueModel stadium, int index) {
    return GestureDetector(
      onTap: () => context.push('/stadium/${stadium.id}'),
      child: GlassmorphismCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: stadium.image != null
                    ? Image.network(
                        stadium.image!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, url, error) => Container(
                          color: AppConstants.cardColor,
                          child: const Icon(Icons.stadium,
                              size: 40, color: AppConstants.secondaryTextColor),
                        ),
                      )
                    : Container(
                        color: AppConstants.cardColor,
                        child: const Icon(Icons.stadium,
                            size: 40, color: AppConstants.secondaryTextColor),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stadium.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: AppConstants.primaryColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          stadium.city,
                          style: const TextStyle(
                            color: AppConstants.secondaryTextColor,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
        delay: Duration(milliseconds: 50 * index), duration: 300.ms);
  }

  Widget _buildStadiumListCard(VenueModel stadium, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => context.push('/stadium/${stadium.id}'),
        child: GlassmorphismCard(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16)),
                child: stadium.image != null
                    ? Image.network(
                        stadium.image!,
                        width: 120,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, url, error) => Container(
                          width: 120,
                          height: 100,
                          color: AppConstants.cardColor,
                          child: const Icon(Icons.stadium,
                              color: AppConstants.secondaryTextColor),
                        ),
                      )
                    : Container(
                        width: 120,
                        height: 100,
                        color: AppConstants.cardColor,
                        child: const Icon(Icons.stadium,
                            color: AppConstants.secondaryTextColor),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stadium.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: AppConstants.primaryColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${stadium.city}${stadium.country != null ? ', ${stadium.country}' : ''}',
                              style: const TextStyle(
                                color: AppConstants.secondaryTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (stadium.capacity != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.people,
                                size: 16, color: AppConstants.secondaryColor),
                            const SizedBox(width: 4),
                            Text(
                              '${stadium.capacity} capacity',
                              style: const TextStyle(
                                color: AppConstants.secondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppConstants.secondaryTextColor,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(
        delay: Duration(milliseconds: 50 * index), duration: 300.ms);
  }

  Widget _buildGridShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return const ShimmerLoading(pattern: ShimmerPattern.card);
      },
    );
  }

  Widget _buildListShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: ShimmerLoading(pattern: ShimmerPattern.listTile),
        );
      },
    );
  }
}
