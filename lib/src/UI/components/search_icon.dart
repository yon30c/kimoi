import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kimoi/src/UI/providers/providers.dart';
import 'package:kimoi/src/UI/providers/storage/searched_provider.dart';
import 'package:kimoi/src/UI/services/delegates/search_delegate.dart';
import 'package:kimoi/src/domain/domain.dart';
import 'package:kimoi/src/domain/entities/searched_anime.dart';

final sAHP = FutureProvider.autoDispose(
    (ref) => ref.read(searcheAnimeHistoryProvider.notifier).loadNextPage());

class SearchIcon extends ConsumerStatefulWidget {
  const SearchIcon({super.key});

  @override
  SearchIconState createState() => SearchIconState();
}

class SearchIconState extends ConsumerState<SearchIcon> {
  @override
  void initState() {
    super.initState();
    ref.read(searcheAnimeHistoryProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          final searchedAnime = ref.read(searcheAnimeHistoryProvider);
          List<Anime> initialAnimes = [];

          for (var element in searchedAnime.values) {
            initialAnimes.add(searchedAnimeToAnime(element));
          }

          await showSearch(
                  context: context,
                  delegate: SearchAnimeDelegate(
                      initialAnimes: initialAnimes,
                      searchAnimes: ref
                          .watch(searchedMoviesProvider.notifier)
                          .searchAnimes))
              .then((value) async {
            if (value == null) return;

            final anime = animeToSearchedAnime(value);

            ref
                .read(searcheAnimeHistoryProvider.notifier)
                .addOnSearch(anime)
                .then((value) => ref
                    .refresh(searcheAnimeHistoryProvider.notifier)
                    .loadNextPage());
            // ref.invalidate(sAHP);
            ref.read(animeProvider.notifier).update((state) => value);
            Future(() => context.push('/anime-screen'));
          });
        },
        icon: const Icon(
          Icons.search,
          size: 30,
        ));
  }
}

SearchedAnime animeToSearchedAnime(Anime anime) => SearchedAnime(
    animeUrl: anime.animeUrl,
    imageUrl: anime.imageUrl,
    animeTitle: anime.animeTitle,
    chapterInfo: anime.chapterInfo,
    chapterUrl: anime.chapterUrl,
    date: DateTime.now(),
    release: anime.release,
    type: anime.type);

Anime searchedAnimeToAnime(SearchedAnime anime) => Anime(
    animeUrl: anime.animeUrl,
    imageUrl: anime.imageUrl,
    animeTitle: anime.animeTitle,
    chapterInfo: anime.chapterInfo,
    chapterUrl: anime.chapterUrl,
    release: anime.release,
    type: anime.type);
