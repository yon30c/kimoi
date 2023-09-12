import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/providers/animes/anime_info_provider.dart';
import 'package:kimoi/src/UI/providers/storage/favorites_animes_provider.dart';
import 'package:kimoi/src/UI/providers/storage/local_storage_provider.dart';
import 'package:kimoi/src/UI/providers/storage/watching_provider.dart';
import 'package:kimoi/src/UI/screens/loading/full_loading_screen.dart';
import 'package:kimoi/src/infrastructure/datasources/anime_mac_datasource.dart';
import 'package:kimoi/src/infrastructure/models/extra_data.dart';

import '../../../domain/domain.dart';
import '../../items/expandable_text.dart';
import '../../items/items.dart';
import '../../items/scroll_to_hide_widget.dart';

final isFavoriteProvider =
    FutureProvider.family.autoDispose((ref, String animeTitle) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isAnimeFavorite(animeTitle);
});

final checkWatchingChapter =
    FutureProvider.family.autoDispose((ref, String id) {
  final localStorageRepository = ref.watch(isWatchingAnimeProvider.notifier);
  return localStorageRepository.loadWatchingChapter(id);
});

final lastChapterProvider2 =
    FutureProvider.family.autoDispose((ref, String animeTitle) {
  final localStorageRepository = ref.watch(isWatchingAnimeProvider.notifier);
  return localStorageRepository.loadLastWatchingChapter(animeTitle);
});

class DetailsScreen extends ConsumerStatefulWidget {
  static const String name = 'anime-screen';

  const DetailsScreen({super.key});

  @override
  DetailsScreenState createState() => DetailsScreenState();
}

class DetailsScreenState extends ConsumerState<DetailsScreen>
    with SingleTickerProviderStateMixin {
  int index = 0;
  XData? _xData;
  bool isSorted = true;
  bool initialCharge = false;
  bool isLoading = true;
  List<List<Chapter>> subList = [];
  List<Chapter> sortedEpisodes = [];
  late TabController tabController;
  late ScrollController scrollController;
  final tabs = [const Tab(text: 'Episodios'), const Tab(text: 'Relacionados')];

  String get sortLabel {
    if (isSorted) return "Ascendente";
    return "Descendente";
  }

  getAniInfo(String url) async {
    await ref.read(getAnimeInfoProvider.notifier).getAnimeInf(url);
    listen();
  }

  @override
  void initState() {
    super.initState();
    final anime = ref.read(animeProvider);
    scrollController = ScrollController();
    tabController = TabController(length: 2, vsync: this);
    getXData(anime!);
    getAniInfo(anime.animeUrl);
    // scrollController.addListener(listen);
  }

  void listen() {
    final animeInf = ref.read(getAnimeInfoProvider);
    final animeInfo = animeInf.first;
    subList.addAll(animeInfo.episodes);
    sortedEpisodes = subList.first;
    setState(() {});
  }

  void getXData(Anime anime) async {
    _xData = await AnimeMacDatasource().getExtraData(anime);
    setState(() {});
  }

  SliverPersistentHeader makeHeader(Widget child) {
    return SliverPersistentHeader(
      pinned: false,
      delegate:
          SliverAppBarDelegate(minHeight: 60.0, maxHeight: 60.0, child: child),
    );
  }

  void onTap(String url, String id, Anime anime) async {
    final chapter = await ref
        .read(isWatchingAnimeProvider.notifier)
        .loadWatchingChapter(id);

    if (chapter != null) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        context.push('/local-player', extra: chapter);
      });
    } else {
      await ref
          .read(getVideoDataProvider.notifier)
          .getVideos(url)
          .then((value) async {
        final chapter = ref.read(getVideoDataProvider).first;

        chapter.isWatching = true;
        chapter.imageUrl = anime.imageUrl;
        chapter.animeUrl = anime.animeUrl;
        context.push('/local-player', extra: chapter);
      });
    }
  }

  SliverAppBar _customAppbar(
      Anime anime,
      AnimeInfo animeInfo,
      XData xData,
      AsyncValue<bool> isFavoriteFuture,
      Size size,
      ColorScheme color,
      BuildContext context) {
    return SliverAppBar(
      // systemOverlayStyle: SystemUiOverlayStyle.light,
      pinned: true,
      leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
          )),
      actions: [
        IconButton(
          onPressed: () async {
            await ref
                .read(favoriteAnimesProvider.notifier)
                .toggleFavorite(anime);
            ref.invalidate(isFavoriteProvider(anime.animeTitle));
            setState(() {});
          },
          icon: isFavoriteFuture.when(
            loading: () => const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(strokeWidth: 2)),
            data: (isFavorite) => isFavorite
                ? const Icon(Icons.favorite_rounded, color: Colors.red)
                : const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ),
            error: (_, __) => throw UnimplementedError(),
          ),
        )
      ],
      expandedHeight: size.height * 0.6,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        background: Stack(
          children: [
            SizedBox.expand(
                child: Image.network(
              xData.largeImageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress != null) {
                  return const DecoratedBox(
                    decoration: BoxDecoration(color: Colors.black12),
                  );
                }
                return FadeIn(child: child);
              },
            )),
            SizedBox.expand(
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [
                  0.0,
                  0.2
                ],
                            colors: [
                  shadow(context),
                  Colors.transparent,
                ])))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final anime = ref.watch(animeProvider);
    final animeInfoL = ref.watch(getAnimeInfoProvider);

    if (_xData == null || animeInfoL.isEmpty) {
      return const Scaffold(body: FullScreenLoader());
    }

    final xData = _xData;
    final animeInfo = ref.watch(getAnimeInfoProvider).first;
    final isFavoriteFuture = ref.watch(isFavoriteProvider(anime!.animeTitle));

    final size = MediaQuery.of(context).size;
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          _customAppbar(
              anime, animeInfo, xData!, isFavoriteFuture, size, color, context),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 8,
            ),
            _CustomTitleBar(anime: anime, animeInfo: animeInfo),
            _RatingBar(xData: xData),
            _ExtraDataBar(animeInfo: animeInfo, xData: xData),
            _GenresBar(
              animeInfo: animeInfo,
            ),
            ExpandableText(
              maxLines: 50,
              minLines: 3,
              text: animeInfo.description ?? xData.synopsis ?? '',
            )
          ])),
          makeHeader(TabBar.secondary(
            isScrollable: true,

            // dividerColor: Colors.transparent,
            controller: tabController,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            tabs: tabs,
            onTap: (value) {
              index = value;
              setState(() {});
            },
          )),
          const SliverToBoxAdapter(
            child: Divider(
              height: 1,
              indent: 8.0,
              endIndent: 8.0,
            ),
          ),
          if (index == 0 && subList.length > 1)
            SliverToBoxAdapter(
                child: DropdownMenu(
                    hintText:
                        '${subList.first.first.chapterNumber} - ${subList.first.last.chapterNumber}',
                    inputDecorationTheme: const InputDecorationTheme(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15),
                    ),
                    initialSelection: <List<Chapter>>[subList.first],
                    dropdownMenuEntries: subList
                        .map((e) => DropdownMenuEntry(
                            value: e,
                            label:
                                '${e.first.chapterNumber} - ${e.last.chapterNumber}'))
                        .toList(),
                    onSelected: (value) {
                      sortedEpisodes = value! as List<Chapter>;
                      setState(() {});
                    })),
          if (index == 0)
            SliverToBoxAdapter(
              child: Row(
                children: [
                  TextButton.icon(
                      label: Text(sortLabel),
                      onPressed: () {
                        isSorted = !isSorted;
                        sortedEpisodes = sortedEpisodes.reversed.toList();
                        setState(() {});
                      },
                      icon: const Icon(Icons.sort)),
                  const Spacer(),
                  const Text('Decargar todo'),
                  const IconButton(onPressed: null, icon: Icon(Icons.download))
                ],
              ),
            ),
          if (index == 0)
            SliverList.builder(
              itemCount: sortedEpisodes.length,
              itemBuilder: (context, index) {
                final eps = sortedEpisodes[index];

                return GestureDetector(
                  onTap: () => onTap(eps.chapterUrl, eps.id, anime),
                  child: _EpisodesTile(anime: anime, eps: eps),
                );
              },
            ),
          if (index == 1)
            SliverList.builder(
              itemCount: animeInfo.related.length,
              itemBuilder: (context, index) {
                final eps = animeInfo.related[index];
                return CsTile(
                  anime: eps,
                );
              },
            ),
          const SliverPadding(padding: EdgeInsets.all(20))
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: ScrollToHideWidget(
          controller: scrollController,
          child: _BottomAppBar(
              anime: anime, isSorted: isSorted, sortedEpisodes: sortedEpisodes),
        ),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}

class _ExtraDataBar extends StatelessWidget {
  const _ExtraDataBar({
    required this.animeInfo,
    required this.xData,
  });

  final AnimeInfo animeInfo;
  final XData xData;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Text(
          '${animeInfo.tipo} • ${xData.season} ${animeInfo.estreno}',
          style: textStyle.labelMedium,
        ),
        const Spacer(),
        Text('Estudio: ${xData.studios}', style: textStyle.labelMedium),
      ]),
    );
  }
}

class _CustomTitleBar extends StatelessWidget {
  const _CustomTitleBar({
    required this.anime,
    required this.animeInfo,
  });

  final Anime anime;
  final AnimeInfo animeInfo;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          SizedBox(
            // color: Colors.red,
            width: size.width * 0.60,
            child: Text(
              anime.animeTitle,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20, color: color.onBackground),
            ),
          ),
          const Spacer(),
          FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () {},
              child: Text(animeInfo.estado)),
        ],
      ),
    );
  }
}

class _EpisodesTile extends ConsumerStatefulWidget {
  const _EpisodesTile({
    required this.anime,
    required this.eps,
  });

  final Anime anime;
  final Chapter eps;

  @override
  _EpisodesTileState createState() => _EpisodesTileState();
}

class _EpisodesTileState extends ConsumerState<_EpisodesTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    final chapter = ref.watch(checkWatchingChapter(widget.eps.id));

    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/jar-loading.gif',
                image: widget.anime.imageUrl,
                height: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.eps.chapter,
                    style: textStyle.titleMedium,
                  ),
                  Text(
                    widget.eps.chapterInfo,
                    style: textStyle.labelMedium,
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: chapter.when(
                  data: (data) {
                    if (data == null) {
                      return const Icon(Icons.remove_red_eye_outlined);
                    }
                    return data.isCompleted
                        ? const Icon(Icons.remove_red_eye)
                        : const Icon(Icons.remove_red_eye_outlined);
                  },
                  error: (error, stackTrace) => Text('Error: $error'),
                  loading: () => const CircularProgressIndicator(),
                )),
            const IconButton(onPressed: null, icon: Icon(Icons.download)),
          ],
        ));


  }
}

class _BottomAppBar extends ConsumerWidget {
  const _BottomAppBar({
    required this.anime,
    required this.isSorted,
    required this.sortedEpisodes,
  });

  final Anime anime;
  final bool isSorted;
  final List<Chapter> sortedEpisodes;

  @override
  Widget build(BuildContext context, ref) {
    // final number = anime.chapterUrl!.split('-').last;

    // final id = '${anime.animeTitle}/$number/${anime.chapterUrl}';
    final lastChapter = ref.watch(lastChapterProvider2(anime.animeTitle));

    return BottomAppBar(
      padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Row(
        children: [
          Expanded(
              child: lastChapter.when(
                  data: (data) {
                    return FilledButton.icon(
                      style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))))),
                      onPressed: () async {
                        final ani = anime;
                        String url = isSorted
                            ? sortedEpisodes.first.chapterUrl
                            : sortedEpisodes.last.chapterUrl;
                        ani.chapterUrl = url;

                        final chapter = ref.watch(lastChapterWProvider);
                        if (chapter != null) {
                          context.push('/local-player', extra: chapter);
                        } else {
                          await ref
                              .read(getVideoDataProvider.notifier)
                              .getVideos(url)
                              .then((value) async {
                            // context.pop();
                            final value = ref.read(getVideoDataProvider).first;

                            value.isWatching = true;
                            value.imageUrl = ani.imageUrl;

                            context.push('/local-player', extra: value);
                          });
                        }
                      },
                      label: data != null
                          ? Text('Continuar Ep. ${data.chapterNumber}')
                          : const Text('Comenzar a ver Ep. 1'),
                      icon: const Icon(Icons.play_arrow_rounded),
                    );
                  },
                  error: (error, stackTrace) => Text('Error: $error'),
                  loading: () => const FilledButton(
                      onPressed: null, child: CircularProgressIndicator()))),
          const SizedBox(width: 5),
          IconButton.filled(
              style: const ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))))),
              onPressed: () {},
              icon: const Icon(Icons.bookmark_add_outlined))
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  const _RatingBar({
    required this.xData,
  });

  final XData xData;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Row(
      children: [
        const SizedBox(
          width: 8,
        ),
        _RatingIndicator(xData: xData),
        const SizedBox(
          width: 8,
        ),
        Text(
          '${xData.score}',
          style: textStyle.labelLarge,
        ),
        const Spacer(),
        Text(
          '${xData.rating}',
          style: textStyle.labelMedium?.copyWith(color: color.error),
        ),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }
}

class _RatingIndicator extends StatelessWidget {
  const _RatingIndicator({
    required this.xData,
  });

  final XData xData;

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: xData.score != null ? xData.score! / 2 : 0.0,
      itemBuilder: (context, index) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: 20.0,
      direction: Axis.horizontal,
    );
  }
}

class _GenresBar extends StatelessWidget {
  const _GenresBar({
    required this.animeInfo,
  });

  final AnimeInfo animeInfo;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Generos:',
              style: textStyle.labelLarge?.copyWith(color: color.primary),
            ),
          ),
          Row(
              children: animeInfo.genres
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 3.0, vertical: 3),
                        child: Chip(label: Text(e)),
                      ))
                  .toList()),
        ],
      ),
    );
  }
}

Color shadow(BuildContext context) {
  if (MediaQuery.platformBrightnessOf(context) == Brightness.light) {
    return Colors.white70;
  } else {
    return Colors.black87;
  }
}
