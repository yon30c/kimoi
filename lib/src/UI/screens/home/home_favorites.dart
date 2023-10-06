import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/items/items.dart';
import 'package:kimoi/src/UI/items/search_icon.dart';
import 'package:kimoi/src/UI/providers/providers.dart';
import 'package:kimoi/src/UI/providers/storage/favorites_animes_provider.dart';
import 'package:kimoi/src/UI/screens/player/local_player.dart';
import 'package:kimoi/src/domain/domain.dart';
import 'package:kimoi/src/infrastructure/models/chapter_to_anime.dart';

class HomeFavorites extends ConsumerStatefulWidget {
  const HomeFavorites({super.key});

  @override
  HomeFavoritesState createState() => HomeFavoritesState();
}

class HomeFavoritesState extends ConsumerState<HomeFavorites>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TabController tabController;
  int index = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() => index = tabController.index);
      });
    ref.read(favoriteAnimesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Mis listas'),
          bottom: PreferredSize(
            preferredSize: Size(size.width, 45),
            child: TabBar(controller: tabController, tabs: const [
              Tab(
                text: 'FAVORITOS',
              ),
              Tab(
                text: 'HISTORIAL',
              ),
            ]),
          ),
          actions: const [
            SearchIcon()
          ],
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            _FavoritesView(),
            _HistoryPage(),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

// ********************************************************** //
// * ----------------- FAVORITE VIEW  --------------------- * //
// ********************************************************** //

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
            Icon(Icons.save, size: 60, color: colors.primary),
            const SizedBox(height: 20),
            const Text('No tienes animes guardados',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
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

// ********************************************************** //
// * -----------------  HISTORY PAGE  --------------------- * //
// ********************************************************** //

class _HistoryPage extends ConsumerStatefulWidget {
  const _HistoryPage();

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<_HistoryPage> {
  bool isWatchinLastPage = false;
  bool isWatchinLoading = false;
  late final ScrollController controller;

  List<Chapter> history = [];

  ValueNotifier label = ValueNotifier('Todo');
  ValueNotifier<bool?> isCompleted = ValueNotifier(null);

  final estados = ["Todo", "Completado", "Viendo"];

  void loadWatchin() async {
    if (isWatchinLoading || isWatchinLastPage) return;
    isWatchinLoading = true;
    setState(() {});
    final animes = await ref
        .read(watchingHistoryProvider.notifier)
        .loadNextPage(isCompleted.value);

    await Future.delayed(const Duration(seconds: 2));

    isWatchinLoading = false;
    setState(() {});
    if (animes.isEmpty) {
      isWatchinLastPage = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    filterChapters('');
    controller.addListener(listen);
  }

  void listen() {
    if (controller.position.pixels >
        (controller.position.maxScrollExtent - 200)) {
      loadWatchin();
    }
  }

  SliverPersistentHeader makeHeader(Widget child) {
    return SliverPersistentHeader(
      // pinned: true,
      floating: true,
      delegate:
          SliverAppBarDelegate(minHeight: 40.0, maxHeight: 40.0, child: child),
    );
  }

  Future<void> filterChapters(String e) async {
    switch (e) {
      case "Completado":
        isCompleted.value = true;
        history = await ref
            .refresh(watchingHistoryProvider.notifier)
            .loadNextPage(true);
        setState(() {});
        break;
      case "Viendo":
        isCompleted.value = false;
        history = await ref
            .refresh(watchingHistoryProvider.notifier)
            .loadNextPage(false);
        setState(() {});
        break;
      default:
        isCompleted.value = null;
        history = await ref
            .refresh(watchingHistoryProvider.notifier)
            .loadNextPage(null);
        setState(() {});
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        controller: controller,
        slivers: [
          makeHeader(DecoratedBox(
            decoration: BoxDecoration(color: color.background),
            child: Row(
              children: [
                const SizedBox(width: 8),
                PopupMenuButton(
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_drop_down,
                          color: color.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          label.value,
                          style: textStyle.labelLarge?.copyWith(color: color.primary),
                        ),
                      ],
                    ),
                    itemBuilder: (context) => estados
                        .map((e) => PopupMenuItem(
                              child: Text(
                                e,
                                style: textStyle.titleSmall,
                              ),
                              onTap: () async {
                                setState(() {
                                  isWatchinLastPage = false;
                                  label.value = e;
                                });
                                await filterChapters(e);
                              },
                            ))
                        .toList()),
                const Spacer(),
                // IconButton(
                //     onPressed: () {}, icon: const Icon(Icons.filter_alt)),
                IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text("Limpiar historial"),
                      content:
                          const Text("¿Deseas eliminar todo el historial?"),
                      actions: [
                        TextButton(
                            onPressed: () => context.pop(),
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.red),
                            )),
                        TextButton(
                            onPressed: () async {
                              await ref
                                  .read(watchingHistoryProvider.notifier)
                                  .clearHistory()
                                  .then((value) =>
                                      ref.refresh(watchingHistoryProvider));

                              await Future(() => context.pop());

                              setState(() {});
                            },
                            child: const Text("Aceptar")),
                      ],
                    ),
                  ),
                  icon: const Icon(Icons.delete_forever),
                  color: Colors.red,
                )
              ],
            ),
          )),
          if (history.isEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 60, color: color.primary),
                    const SizedBox(height: 20),
                    const Text('Historial vacio',
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ),
          if (history.isNotEmpty)
            SliverList.builder(
              itemCount: history.length,
              itemBuilder: (BuildContext context, int index) {
                final chapter = history[index];

                final Anime anime = Anime(
                  animeUrl: chapter.animeUrl!,
                  imageUrl: chapter.imageUrl!,
                  animeTitle: chapter.title,
                  chapterInfo: chapter.chapterInfo,
                  chapterUrl: chapter.chapterUrl,
                );
                return GestureDetector(
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (context) => ServerDialog(anime, chapter));
                  },
                  child: _HistoryTile(
                    chapter: chapter,
                    isCompleted: isCompleted.value,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _HistoryTile extends ConsumerStatefulWidget {
  const _HistoryTile({required this.chapter, required this.isCompleted});

  final Chapter chapter;
  final bool? isCompleted;

  @override
  _HistoryTileState createState() => _HistoryTileState();
}

class _HistoryTileState extends ConsumerState<_HistoryTile> {
  @override
  Widget build(BuildContext context) {
    final res = widget.chapter.duration - widget.chapter.position;
    final size = MediaQuery.of(context).size;
    final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: size.width * 0.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.chapter.imageUrl!))),
                  ),
                  Container(
                    color: Colors.black54,
                    width: size.width * 0.2,
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: size.width * 0.45,
                    child: Text(
                      widget.chapter.title,
                      style: textStyle.titleSmall
                          ?.copyWith(color: color.surfaceTint),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
                const SizedBox(height: 3),
                Text(
                  widget.chapter.chapter,
                  style: textStyle.labelMedium
                      ?.copyWith(color: color.onBackground, fontSize: 14),
                ),
                const SizedBox(height: 3),
                if (widget.chapter.isCompleted)
                  Text('Completado',
                      style:
                          textStyle.labelMedium?.copyWith(color: color.outline)),
                if (widget.chapter.isWatching)
                  Text(
                    'Restante ${formatDuration(res)}',
                    style: textStyle.labelMedium?.copyWith(color: color.outline),
                  ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: widget.chapter.isCompleted
                        ? Icon(
                            Icons.remove_red_eye,
                            color: color.primary,
                          )
                        : const Icon(Icons.remove_red_eye_outlined)),
      
                PopupMenuButton(
                  position: PopupMenuPosition.under,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info,
                              color: color.primary,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text('Informacion'),
                          ],
                        ),
                        onTap: () async {
                          final anime = chapterToAnime(widget.chapter);
      
                          ref
                              .read(animeProvider.notifier)
                              .update((state) => anime);
      
                          await ref
                              .read(isWatchingAnimeProvider.notifier)
                              .loadLastWatchingChapter(widget.chapter.title)
                              .then((value) {
                            ref
                                .read(lastChapterWProvider.notifier)
                                .update((state) => value);
                            GoRouter.of(context).push('/anime-screen');
                          });
                        },
                      ),
                      PopupMenuItem(
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Eliminar'),
                          ],
                        ),
                        onTap: () async {
                          if (widget.isCompleted != null) {
                            await ref
                                .read(isWatchingAnimeProvider.notifier)
                                .removeChapter(widget.chapter)
                                .then((value) => ref
                                    .refresh(watchingHistoryProvider.notifier)
                                    .loadNextPage(widget.isCompleted));
                            setState(() {});
                          } else {
                            await ref
                                .read(isWatchingAnimeProvider.notifier)
                                .removeChapter(widget.chapter)
                                .then((value) {
                              ref
                                  .refresh(watchingHistoryProvider.notifier)
                                  .loadNextPage(null);
                            });
                          }
                        },
                      ),
                      // const PopupMenuItem(child: Text('Ver detalles')),
                    ];
                  },
                )
                // IconButton(
                //     onPressed: () {}, icon: const Icon(Icons.more_vert)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
