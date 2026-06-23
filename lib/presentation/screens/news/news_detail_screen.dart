import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:world_cup_2026/core/constants/app_constants.dart';
import 'package:world_cup_2026/data/models/news_model.dart';
import 'package:world_cup_2026/presentation/providers/news_provider.dart';
import 'package:world_cup_2026/presentation/widgets/glassmorphism_card.dart';
import 'package:world_cup_2026/presentation/widgets/error_widget.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends ConsumerWidget {
  final String articleId;

  const NewsDetailScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleAsync = ref.watch(newsDetailProvider(articleId));

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: articleAsync.when(
        data: (article) {
          if (article == null) {
            return const Center(child: AppErrorWidget(message: 'Article not found'));
          }
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(article),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildArticleHeader(article),
                    _buildArticleContent(article),
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
            onRetry: () => ref.refresh(newsDetailProvider(articleId)),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(NewsModel article) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppConstants.backgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        background: article.imageUrl != null
            ? Image.network(
                article.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, url, error) => Container(
                  color: AppConstants.cardColor,
                  child: const Icon(Icons.error,
                      size: 60, color: AppConstants.secondaryTextColor),
                ),
              )
            : Container(
                color: AppConstants.cardColor,
                child: const Icon(Icons.article,
                    size: 60, color: AppConstants.secondaryTextColor),
              ),
      ),
    );
  }

  Widget _buildArticleHeader(NewsModel article) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (article.source != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    article.source!,
                    style: const TextStyle(
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                DateFormat('MMMM d, yyyy • h:mm a').format(article.publishedAt),
                style: const TextStyle(
                  color: AppConstants.secondaryTextColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            article.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              height: 1.3,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildArticleContent(NewsModel article) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassmorphismCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.summary != null && article.summary!.isNotEmpty) ...[
              Text(
                article.summary!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
            ],
            if (article.content != null)
              Text(
                article.content!,
                style: const TextStyle(
                  color: AppConstants.secondaryTextColor,
                  fontSize: 16,
                  height: 1.8,
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }
}
