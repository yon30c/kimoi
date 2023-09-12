import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/providers/providers.dart';
import 'package:kimoi/src/UI/providers/storage/favorites_animes_provider.dart';
import 'package:kimoi/src/UI/providers/storage/watching_provider.dart';
import 'package:kimoi/src/UI/screens/player/local_player.dart';
import 'package:kimoi/src/UI/services/delegates/search_delegate.dart';

import '../../items/anime_masonry.dart';

class HomeFavorites extends ConsumerStatefulWidget {
  const HomeFavorites({super.key});

  @override
  HomeFavoritesState createState() => HomeFavoritesState();
}

class HomeFavoritesState extends ConsumerState<HomeFavorites>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    ref.read(favoriteAnimesProvider.notifier).loadNextPage();
    ref.read(watchingHistoryProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Mis listas'),
            bottom: const TabBar(tabs: [
              Tab(text: 'Favoritos'),
              Tab(text: 'Historial'),
              Tab(text: 'Offline'),
            ]),
            actions: [
              IconButton(
                  onPressed: () async {
                    await showSearch(
                            context: context,
                            delegate: SearchAnimeDelegate(
                                searchAnimes: ref
                                    .watch(searchedMoviesProvider.notifier)
                                    .searchAnimes))
                        .then((value) {
                      if (value == null) return;
                      ref.read(animeProvider.notifier).update((state) => value);
                      context.push('/anime-screen');
                    });
                  },
                  icon: const Icon(
                    Icons.search,
                    size: 30,
                  ))
            ],
          ),
          body: const TabBarView(
            children: [
              _FavoritesView(),
              _HistoryPage(),
              Center(
                child: Text('offline - screen'),
              ),
            ],
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _FavoritesView extends ConsumerStatefulWidget {
  const _FavoritesView();

  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends ConsumerState<_FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;

  void loadNextPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;

    final movies =
        await ref.read(favoriteAnimesProvider.notifier).loadNextPage();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteAnimesProvider).values.toList();
    final colors = Theme.of(context).colorScheme;

    if (favoriteMovies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline_sharp, size: 60, color: colors.primary),
            Text('Ohhh no!!',
                style: TextStyle(fontSize: 30, color: colors.primary)),
            const Text('No tienes animes favoritos',
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            FilledButton.tonal(
                onPressed: () => context.go('/explorar'),
                child: const Text('Empieza a buscar'))
          ],
        ),
      );
    }

    return AnimeMasonry(loadNextPage: loadNextPage, animes: favoriteMovies);
  }
}

class _HistoryPage extends ConsumerStatefulWidget {
  const _HistoryPage();

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<_HistoryPage> {
  bool isWatchinLastPage = false;
  bool isWatchinLoading = false;

  void loadWatchin() async {
    if (isWatchinLoading || isWatchinLastPage) return;
    isWatchinLoading = true;

    final animes =
        await ref.read(watchingHistoryProvider.notifier).loadNextPage();
    isWatchinLoading = false;

    if (animes.isEmpty) {
      isWatchinLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    final history = ref.watch(watchingHistoryProvider);

    final color = Theme.of(context).colorScheme;
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (BuildContext context, int index) {
        final chapter = history.reversed.toList()[index];

        final res = chapter.duration - chapter.position;
        return GestureDetector(
          onTap: () {
            context.push('/local-player', extra: chapter);
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        chapter.imageUrl!,
                        height: 90,
                        width: 65,
                      ),
                      Container(
                        height: 90,
                        width: 65,
                        color: Colors.black45,
                      ),
                      const Icon(
                        Icons.play_arrow_rounded,
                        size: 30,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: size.width * 0.45,
                        child: Text(
                          chapter.title,
                          style: textStyle.titleSmall
                              ?.copyWith(color: color.surfaceTint),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                    const SizedBox(height: 3),
                    Text(
                      chapter.chapter,
                      style: textStyle.labelMedium
                          ?.copyWith(color: color.onBackground, fontSize: 14),
                    ),
                    const SizedBox(height: 3),
                    if (chapter.isCompleted)
                      Text('Completado',
                          style: textStyle.labelMedium
                              ?.copyWith(color: color.outline)),
                    if (chapter.isWatching)
                      Text(
                        'Restante ${formatDuration(res)}',
                        style: textStyle.labelMedium
                            ?.copyWith(color: color.outline),
                      ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: chapter.isCompleted
                            ? Icon(
                                Icons.remove_red_eye,
                                color: color.primary,
                              )
                            : const Icon(Icons.remove_red_eye_outlined)),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.more_vert)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
