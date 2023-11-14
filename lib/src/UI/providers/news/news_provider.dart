import 'package:kimoi/src/UI/providers/news/news_repository_provider.dart';
import 'package:riverpod/riverpod.dart';

import '../../../infrastructure/models/article_info.dart';

final articlesProvider = StateProvider((ref) => ref.read(recentNewsProvider));

final animeNewsProvider =
    StateNotifierProvider<KudasaiNotifier, List<ArticleInfo>>((ref) {
  final fetchAnime = ref.watch(newsRepositoryProvider).getAnimeNews;
  return KudasaiNotifier(fetchAnime);
});

final popularNewsProvider =
    StateNotifierProvider<KudasaiNotifier, List<ArticleInfo>>((ref) {
  final fetchAnime = ref.watch(newsRepositoryProvider).getPopularNews;
  return KudasaiNotifier(fetchAnime);
});

final mangaNewsProvider =
    StateNotifierProvider<KudasaiNotifier, List<ArticleInfo>>((ref) {
  final fetchAnime = ref.watch(newsRepositoryProvider).getMangaNews;
  return KudasaiNotifier(fetchAnime);
});

final japonNewsProvider =
    StateNotifierProvider<KudasaiNotifier, List<ArticleInfo>>((ref) {
  final fetchAnime = ref.watch(newsRepositoryProvider).getJaponNews;
  return KudasaiNotifier(fetchAnime);
});

final recentNewsProvider =
    StateNotifierProvider<KudasaiNotifier, List<ArticleInfo>>((ref) {
  final fetchAnime = ref.watch(newsRepositoryProvider).getRecentNews;
  return KudasaiNotifier(fetchAnime);
});

typedef FetchMoreNews = Future<List<ArticleInfo>> Function(int);

class KudasaiNotifier extends StateNotifier<List<ArticleInfo>> {
  KudasaiNotifier(this.fetchMoreNews) : super([]);

  final FetchMoreNews fetchMoreNews;

  int currentPage = 0;
  bool isLoading = false;

  Future<void> getNews() async {
    if (isLoading) return;

    isLoading = true;

    currentPage++;

    final news = await fetchMoreNews(currentPage);

    state = [...state, ...news];

    await Future.delayed(const Duration(milliseconds: 300));

    isLoading = false;
  }
}
