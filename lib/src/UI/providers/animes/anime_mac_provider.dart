import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimoi/src/UI/providers/animes/anime_repository_provider.dart';

import '../../../domain/entities/anime.dart';

typedef AnimeCallback = Future<List<Anime>> Function({int? year, int? page});
typedef AnimeInfoCallback = Future Function(String path);

final recentAnimesProvider =
    StateNotifierProvider<AnimeNotifier, List<Anime>>((ref) {
  final fetchMoreAnimes = ref.watch(animeRepositoryProvider).getRecentAnime;
  return AnimeNotifier(fetchMoreAnimes: fetchMoreAnimes);
});

final lastAnimesAddedProvider =
    StateNotifierProvider<AnimeNotifier, List<Anime>>((ref) {
  final fetchMoreAnimes = ref.watch(animeRepositoryProvider).getLastAnimeAdded;
  return AnimeNotifier(fetchMoreAnimes: fetchMoreAnimes);
});

class AnimeNotifier extends StateNotifier<List<Anime>> {
  AnimeNotifier({required this.fetchMoreAnimes}) : super([]);

  final AnimeCallback fetchMoreAnimes;

  bool isLoading = false;
  int currentPage = 0;
  int year = 2023;


  Future<void> getAnimes() async {
    if (isLoading) return;

    isLoading = true;

    List<Anime> animes = [];

    currentPage++;

    animes = await fetchMoreAnimes(page: currentPage, year: year);

    state = [...state, ...animes];

    await Future.delayed(const Duration(milliseconds: 300));

    isLoading = false;
  }
}
