import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimoi/src/domain/entities/searched_anime.dart';

import '../../../domain/domain.dart';
import 'local_storage_provider.dart';

final searchedAnimeProvider =
    StateNotifierProvider<HistoryNotifier, List<SearchedAnime>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return HistoryNotifier(localStorageRepository: localStorageRepository);
});

class HistoryNotifier extends StateNotifier<List<SearchedAnime>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  HistoryNotifier({required this.localStorageRepository}) : super([]);

  Future<void> addOnSearch(SearchedAnime anime) async {
    await localStorageRepository.searched(anime);
    // final bool isWatchingChapter = state.contains(anime);
    // final index = state.indexWhere((element) => element.id == anime.id);

    // if (isWatchingChapter) {
    //   // state.remove(anime.id);
    //   state[index] = anime;
    //   state = [...state];
    // } else {
    //   state = [...state, anime];
    // }
  }
}

final searcheAnimeHistoryProvider =
    StateNotifierProvider<SearchedNotifier, Map<String, SearchedAnime>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return SearchedNotifier(localStorageRepository: localStorageRepository);
});

class SearchedNotifier extends StateNotifier<Map<String, SearchedAnime>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  SearchedNotifier({required this.localStorageRepository}) : super({});

  Future<List<SearchedAnime>> loadNextPage() async {
    final animes = await localStorageRepository.loadSearchedHistory(
        offset: page * 10, limit: 20);
    page++;
    final tempAnimesMap = <String, SearchedAnime>{};
    for (final anime in animes) {
      tempAnimesMap[anime.animeTitle] = anime;
    }
    state = {...state, ...tempAnimesMap};
    return animes;
  }

  Future<void> addOnSearch(SearchedAnime anime) async {
    await localStorageRepository.searched(anime);
  }

  Future<void> clearSearchHistory() async {
    await localStorageRepository.clearSearchHistory();
  }
}
