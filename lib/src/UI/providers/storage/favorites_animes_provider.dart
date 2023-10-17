import 'package:kimoi/src/infrastructure/infrastructure.dart';
import 'package:riverpod/riverpod.dart';

import '../../../domain/domain.dart';

final localStorageRepository = LocalStorageRepositoryImpl(IsarDatasource());


class StorageAnimesNotifier extends Notifier<Map<int, Anime>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageAnimesNotifier({required this.localStorageRepository});

  Future<List<Anime>> loadNextPage() async {
    final animes =
        await localStorageRepository.loadAnimes(offset: page * 10, limit: 20);
    page++;
    final tempAnimesMap = <int, Anime>{};
    for (final anime in animes) {
      tempAnimesMap[anime.id] = anime;
    }
    state = {...state, ...tempAnimesMap};
    return animes;
  }

  Future<void> toggleFavorite(Anime anime) async {
    await localStorageRepository.toggleFavorite(anime);
    final bool isAnimeInFavorites = state[anime.id] != null;

    if (isAnimeInFavorites) {
      state.remove(anime.id);
      state = {...state};
    } else {
      state = {...state, anime.id: anime};
    }
  }

  @override
  Map<int, Anime> build() {
    return {};
  }
}
