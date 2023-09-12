import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/domain.dart';
import '../../../domain/repositories/local_storage_repository.dart';
import 'local_storage_provider.dart';

final lastChapterWProvider = StateProvider<Chapter?>((ref) => null);

final isWatchingAnimeProvider =
    StateNotifierProvider<HistoryNotifier, List<Chapter>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return HistoryNotifier(localStorageRepository: localStorageRepository);
});

class HistoryNotifier extends StateNotifier<List<Chapter>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  HistoryNotifier({required this.localStorageRepository}) : super([]);

  Future<Chapter?> loadWatchingChapter(String id) async {
    final tmpChapter = await localStorageRepository.loadWatchingAnime(id);

    return tmpChapter;
  }

  Future<Chapter?> loadLastWatchingChapter(String title) async {
    final tmpChapter =
        await localStorageRepository.loadLastWatchedChapterAnime(title);

    return tmpChapter;
  }

  Future<void> addOnWatching(Chapter chapter) async {
    await localStorageRepository.onWatching(chapter);
    final bool isWatchingChapter = state.contains(chapter);
    final index = state.indexWhere((element) => element.id == chapter.id);

    if (isWatchingChapter) {
      // state.remove(anime.id);
      state[index] = chapter;
      state = [...state];
    } else {
      state = [...state, chapter];
    }
  }
}

final watchingHistoryProvider =
    StateNotifierProvider<WatchingNotifier, List<Chapter>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return WatchingNotifier(localStorageRepository: localStorageRepository);
});

class WatchingNotifier extends StateNotifier<List<Chapter>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  WatchingNotifier({required this.localStorageRepository}) : super([]);

  Future<List<Chapter>> loadNextPage() async {
    final animes = await localStorageRepository.loadWatchedHistory(
        offset: page * 10, limit: 20);
    page++;

    state = [...state, ...animes];
    return state;
  }
}
