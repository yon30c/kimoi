import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/domain.dart';
import 'local_storage_provider.dart';


final favoriteAnimesProvider =
    StateNotifierProvider<StorageAnimesNotifier, Map<int, Anime>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return StorageAnimesNotifier(localStorageRepository: localStorageRepository);
});

/*
  {
    1234: Movie,
    1645: Movie,
    6523: Movie,
  }

*/

class StorageAnimesNotifier extends StateNotifier<Map<int, Anime>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageAnimesNotifier({required this.localStorageRepository}) : super({});

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
}
