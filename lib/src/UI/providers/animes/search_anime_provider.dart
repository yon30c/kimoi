

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/domain.dart';
import '../providers.dart';


final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvider = StateNotifierProvider<SearchedAnimesNotifier, List<Anime>>((ref) {

  final searchAnime = ref.read( animeRepositoryProvider ).searchAnime;

  return SearchedAnimesNotifier(
    searchAnimes: searchAnime ,
    ref: ref
  );
});


typedef SearchAnimesCallback = Future<List<Anime>> Function(String query);

class SearchedAnimesNotifier extends StateNotifier<List<Anime>> {

  final SearchAnimesCallback searchAnimes;
  final Ref ref;

  SearchedAnimesNotifier({
    required this.searchAnimes,
    required this.ref,
  }): super([]);


  Future<List<Anime>> searchAnimesByQuery( String query ) async{
    
    final List<Anime> animes = await searchAnimes(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);

    state = animes;
    return animes;
  }

}





