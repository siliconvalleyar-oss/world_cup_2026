import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/news_model.dart';
import 'api_provider.dart';

final newsListProvider = StateNotifierProvider<NewsListNotifier, AsyncValue<List<NewsModel>>>((ref) {
  return NewsListNotifier(ref);
});

final newsDetailProvider = FutureProvider.family<NewsModel?, String>((ref, id) async {
  final asyncNews = ref.watch(newsListProvider);
  final news = asyncNews.when(
    data: (data) => data,
    loading: () => <NewsModel>[],
    error: (_, __) => <NewsModel>[],
  );
  try {
    return news.firstWhere((n) => n.id == id);
  } catch (_) {
    return null;
  }
});

final latestNewsProvider = Provider<AsyncValue<List<NewsModel>>>((ref) {
  final newsAsync = ref.watch(newsListProvider);
  return newsAsync.whenData(
    (news) {
      final sorted = List<NewsModel>.from(news)
        ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      return sorted.take(5).toList();
    },
  );
});

final newsSearchProvider = StateProvider<String>((ref) => '');

final filteredNewsProvider = Provider<AsyncValue<List<NewsModel>>>((ref) {
  final query = ref.watch(newsSearchProvider);
  final newsAsync = ref.watch(newsListProvider);
  if (query.isEmpty) return newsAsync;
  return newsAsync.whenData(
    (news) => news.where((n) {
      final q = query.toLowerCase();
      final title = n.title.toLowerCase();
      final summary = n.summary?.toLowerCase() ?? '';
      return title.contains(q) || summary.contains(q);
    }).toList(),
  );
});

class NewsListNotifier extends StateNotifier<AsyncValue<List<NewsModel>>> {
  final Ref ref;

  NewsListNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadNews();
  }

  Future<void> loadNews() async {
    try {
      final service = ref.read(theSportsDBServiceProvider);
      final news = await service.getNews();
      if (mounted) state = AsyncValue.data(news);
    } catch (e, st) {
      if (mounted) state = AsyncValue.data([]);
    }
  }

  Future<void> refresh() async {
    await loadNews();
  }
}
