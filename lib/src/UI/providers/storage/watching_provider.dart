import 'package:kimoi/src/UI/providers/storage/favorites_animes_provider.dart';
import 'package:riverpod/riverpod.dart';

import '../../../domain/domain.dart';
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

  Future<void> removeChapter(Chapter chapter) async {
    await localStorageRepository.removeWatchetChapter(chapter);
  }
}

final watchingHistoryProvider =
    NotifierProvider<WatchingNotifier, Map<String, Chapter>>(() {
  final watchingNotifier =
      WatchingNotifier(localStorageRepository: localStorageRepository);
  return watchingNotifier;
});

class WatchingNotifier extends Notifier<Map<String, Chapter>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  WatchingNotifier({required this.localStorageRepository}) {
    loadNextPage();
  }

  Future<List<Chapter>> loadNextPage() async {
    final tempAnimesMap = <String, Chapter>{};
    final animes = await localStorageRepository.loadWatchedHistory();
    for (final anime in animes) {
      tempAnimesMap[anime.id] = anime;
    }
    state = {...state, ...tempAnimesMap};
    return animes;
  }

  Future<void> clearHistory() async {
    await localStorageRepository.clearHistory();
  }

  Future<void> removeChapter(Chapter chapter) async {
    state.remove(chapter.id);
    await localStorageRepository.removeWatchetChapter(chapter);
  }

  @override
  Map<String, Chapter> build() {
    return {};
  }
}

final nowWatchingProvider =
    NotifierProvider<NowWatchingNotifier, List<Chapter>>(() {
  return NowWatchingNotifier(localStorageRepository: localStorageRepository);
});

class NowWatchingNotifier extends Notifier<List<Chapter>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  NowWatchingNotifier({required this.localStorageRepository});

  Future<List<Chapter>> loadWatching() async {
    final animes = await localStorageRepository.loadWatchedHistory(
        offset: page * 10, limit: 20, isCompleted: false);

    final watching = animes.where((element) => !element.isCompleted).toList();

    state = [
      ...state,
      ...watching,
    ];

    return animes;
  }

  @override
  List<Chapter> build() {
    return [];
  }
}
