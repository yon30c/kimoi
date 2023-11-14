import 'package:kimoi/src/infrastructure/infrastructure.dart';
import 'package:riverpod/riverpod.dart';

import '../../../domain/domain.dart';

final localStorageRepository = LocalStorageRepositoryImpl(IsarDatasource());

class StorageAnimesNotifier extends Notifier<Map<String, Anime>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageAnimesNotifier({required this.localStorageRepository});

  Future<List<Anime>> loadNextPage() async {
    final animes =
        await localStorageRepository.loadAnimes(offset: page * 10, limit: 20);
    page++;
    final tempAnimesMap = <String, Anime>{};
    for (final anime in animes) {
      tempAnimesMap[anime.animeTitle] = anime;
    }
    state = {...state, ...tempAnimesMap};
    return animes;
  }

   void loadNext() async {
    final animes =
        await localStorageRepository.loadAnimes(offset: page * 10, limit: 20);
    page++;
    final tempAnimesMap = <String, Anime>{};
    for (final anime in animes) {
      tempAnimesMap[anime.animeTitle] = anime;
    }
    state = {...state, ...tempAnimesMap};
  }

  Future<void> toggleFavorite(Anime anime) async {
    await localStorageRepository.toggleFavorite(anime);

    final bool isAnimeInFavorites = state.containsKey(anime.animeTitle);

    if (isAnimeInFavorites) {
      Map<String, Anime> animes = state;
      animes.remove(anime.animeTitle);
      state = animes;
    } else {
      state = {...state, anime.animeTitle: anime};
    }
  }

  @override
  Map<String, Anime> build() {
    return {};
  }
}
