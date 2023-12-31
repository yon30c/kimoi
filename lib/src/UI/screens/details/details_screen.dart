import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kimoi/main.dart';
import 'package:kimoi/src/infrastructure/datasources/monoschinos_datasource.dart';
import 'package:kimoi/src/utils/extensions/extension.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/providers/animes/anime_info_provider.dart';
import 'package:kimoi/src/UI/providers/storage/local_storage_provider.dart';
import 'package:kimoi/src/UI/providers/storage/watching_provider.dart';
import 'package:kimoi/src/UI/screens/loading/full_loading_screen.dart';
import 'package:kimoi/src/UI/screens/player/youtube_player.dart';
import 'package:kimoi/src/infrastructure/models/extra_data.dart';

import '../../../domain/domain.dart';
import '../../components/items.dart';
import '../home/home.dart';

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

class DetailsScreen extends StatefulHookConsumerWidget {
  static const String name = 'anime-screen';

  const DetailsScreen({super.key});

  @override
  DetailsScreenState createState() => DetailsScreenState();
}

class DetailsScreenState extends ConsumerState<DetailsScreen> {
  int index = 0;
  XData? _xData;
  bool isSorted = true;
  bool initialCharge = false;
  bool isLoading = true;
  List<List<Chapter>> subList = [];
  List<Chapter> sortedEpisodes = [];
  bool isPermission = false;

  String get sortLabel {
    if (isSorted) return "Ascendente";
    return "Descendente";
  }

  getAniInfo(String url, Anime anime) async {
    if (anime.type == 'Donghua') {
      await ref.read(getAnimeInfoProvider.notifier).getAnimeInf(url);
      final animeInfo = ref.watch(getAnimeInfoProvider).first;
      getXData(
          anime, animeInfo.title == '' ? anime.animeTitle : animeInfo.title);
    } else if (anime.animeTitle.contains("86 2nd")) {
      getXData(anime, "86 2");
      await ref.read(getAnimeInfoProvider.notifier).getAnimeInf(url);
    } else if (
      anime.animeTitle.contains("Akuma-kun (2023)") || 
      anime.animeTitle.contains("Blue Eye Samurai") || anime.animeTitle.contains("Latino")) {
      await ref.read(getAnimeInfoProvider.notifier).getAnimeInf(url);

    } 
    
    else {
      getXData(anime, anime.animeTitle);
      await ref.read(getAnimeInfoProvider.notifier).getAnimeInf(url);
    }

    listen();
  }

  @override
  void initState() {
    super.initState();
    final anime = ref.read(animeProvider);
    getAniInfo(anime!.animeUrl, anime);
    // scrollController.addListener(listen);
  }

  void listen() {
    final animeInf = ref.read(getAnimeInfoProvider);
    final animeInfo = animeInf.first;
    subList.addAll(animeInfo.episodes);
    sortedEpisodes = subList.first;
    setState(() {});
  }

  void getXData(Anime anime, String title) async {
    _xData = await MonoschinosDatasource().getExtraData(anime, title);
    setState(() {});
  }

  SliverPersistentHeader makeHeader(Widget child) {
    return SliverPersistentHeader(
      pinned: false,
      delegate:
          SliverAppBarDelegate(minHeight: 60.0, maxHeight: 60.0, child: child),
    );
  }

  SliverAppBar _customAppbar(
      Anime anime,
      AnimeInfo animeInfo,
      XData? xData,
      AsyncValue<bool> isFavoriteFuture,
      Size size,
      ColorScheme color,
      BuildContext context) {

      if (xData != null) {
        return SliverAppBar(
      // systemOverlayStyle: SystemUiOverlayStyle.light,
      pinned: true,
      leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: color.onBackground,
          )),
      actions: [
        if (xData.trailer != null)
          FilledButton.icon(
              style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: MaterialStatePropertyAll(color.background)),
              onPressed: () {
                final route = MaterialPageRoute(
                    builder: (context) => YoutubePlayerScreen(
                          id: xData.trailer!,
                        ));
                Navigator.of(context).push(route);
              },
              label: Text(
                "Ver trailer",
                style: TextStyle(color: color.onBackground),
              ),
              icon: const FaIcon(
                FontAwesomeIcons.youtube,
                color: Colors.red,
              )),
        const SizedBox(
          width: 8,
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
                  0.25
                ],
                            colors: [
                  shadow(context),
                  Colors.transparent,
                ])))),
          ],
        ),
      ),
    );
      } else {
         return SliverAppBar(
      // systemOverlayStyle: SystemUiOverlayStyle.light,
      pinned: true,
      leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: color.onBackground,
          )),
     
      expandedHeight: size.height * 0.6,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        background: Stack(
          children: [
            SizedBox.expand(
                child: Image.network(
              anime.imageUrl,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
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
                  0.25
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
  }

  @override
  Widget build(BuildContext context) {
    final anime = ref.watch(animeProvider);
    final animeInfoL = ref.watch(getAnimeInfoProvider);

    final scrollController = useScrollController();

    if (animeInfoL.isEmpty) {
      return const Scaffold(body: FullScreenLoader());
    }

    final xData = _xData;

    final animeInfo = ref.watch(getAnimeInfoProvider).first;
    // if (!xData!.title.contains(anime!.animeTitle)) {
    //   xData.largeImageUrl = animeInfo.imageUrl;
    // }

    final isFavoriteFuture = ref.watch(isFavoriteProvider(anime!.animeTitle));

    final size = MediaQuery.of(context).size;
    final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          _customAppbar(
              anime, animeInfo, xData, isFavoriteFuture, size, color, context),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 8,
            ),
            _CustomTitleBar(anime: anime, animeInfo: animeInfo),
            if (xData != null)
            _RatingBar(xData: xData),
            
            _ExtraDataBar(
              animeInfo: animeInfo,
              xData: xData,
              anime: anime,
            ),
            _GenresBar(
              animeInfo: animeInfo,
            ),
            ExpandableText(
              maxLines: 50,
              minLines: 3,
              text: animeInfo.description ?? '',
            )
          ])),
          SliverToBoxAdapter(
            child: anime.type == "Pelicula" &&
                    animeInfo.episodes.first.length == 1
                ? const SizedBox()
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: color.secondaryContainer,
                    ),
                    margin: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      "Episodios",
                      style: textStyle.titleMedium
                          ?.copyWith(color: color.onPrimaryContainer),
                    ),
                  ),
          ),
          SliverToBoxAdapter(
            child: anime.type == "Pelicula" &&
                    animeInfo.episodes.first.length == 1
                ? const SizedBox(height: 10)
                : Row(
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
                      if (subList.length > 1)
                        DropdownMenu(
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
                                    label: e.isNotEmpty ?
                                        '${e.first.chapterNumber} - ${e.last.chapterNumber}': "") )
                                .toList(),
                            onSelected: (value) {
                              setState(() {
                                final val = value as List<Chapter>;
                                isSorted
                                    ? sortedEpisodes = val
                                    : sortedEpisodes = val.reversed.toList();
                              });
                            }),
                    ],
                  ),
          ),
          SliverList.builder(
            itemCount: sortedEpisodes.length,
            itemBuilder: (context, index) {
              final eps = sortedEpisodes[index];

              return _EpisodesTile(
                anime: anime,
                eps: eps,
                xData: xData,
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
              animeInfo: animeInfo,
              anime: anime,
              isSorted: isSorted,
              sortedEpisodes: sortedEpisodes),
        ),
      ),
    );
  }
}

class _ExtraDataBar extends StatelessWidget {
  const _ExtraDataBar({
    required this.animeInfo,
    required this.xData,
    required this.anime,
  });

  final AnimeInfo animeInfo;
  final XData? xData;
  final Anime anime;



  String get year {
    if (anime.release != null && anime.release != '') {
      return anime.release!;
    }
    return animeInfo.estreno.substringAfterLast(' ');
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final tipo = anime.type ?? animeInfo.tipo;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Text( xData != null ?
          '$tipo • ${xData!.season} $year' : '$tipo • $year' ,
          style: textStyle.labelMedium,
        ),
        const Spacer(),
        if (xData != null && xData!.studios != '' && animeInfo.title.contains(xData!.title))
          Text('Estudio: ${xData!.studios}', style: textStyle.labelMedium),
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
    required this.xData,
    required this.anime,
    required this.eps,
  });

  final Anime anime;
  final Chapter eps;
  final XData? xData;

  @override
  _EpisodesTileState createState() => _EpisodesTileState();
}

class _EpisodesTileState extends ConsumerState<_EpisodesTile> {
  @override
  void initState() {
    super.initState();
  }

  void onTap(Chapter eps, Anime anime) async {
    final ani = anime;
    ani.chapterUrl = eps.chapterUrl;
    showDialog(context: context, builder: (context) => ServerDialog(ani, eps));
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    final chapter = ref.watch(checkWatchingChapter(widget.eps.id));

    return GestureDetector(
      onTap: () {
        onTap(widget.eps, widget.anime);
      },
      child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(
                      widget.xData != null &&  widget.anime.animeTitle.contains(widget.xData!.title)
                          ? widget.xData!.largeImageUrl
                          : widget.anime.imageUrl,
                    ),
                  )),
                  height: 100,
                  width: 70,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: /* widget.anime.type == "Pelicula"
                ? Text(
                  widget.anime.type!,
                  style: textStyle.titleMedium,
                  maxLines: 2,
                )  
                 : */
                    Text(
                  widget.eps.chapter,
                  style: textStyle.titleMedium,
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
                          ? Icon(
                              Icons.remove_red_eye,
                              color: color.primary,
                            )
                          : const Icon(Icons.remove_red_eye_outlined);
                    },
                    error: (error, stackTrace) => Text('Error: $error'),
                    loading: () => const CircularProgressIndicator(),
                  )),
              IconButton(
                  onPressed: () => onTap(widget.eps, widget.anime),
                  icon: const Icon(Icons.play_arrow_rounded)),
            ],
          )),
    );
  }
}

class _BottomAppBar extends ConsumerStatefulWidget {
  const _BottomAppBar({
    required this.anime,
    required this.isSorted,
    required this.animeInfo,
    required this.sortedEpisodes,
  });

  final Anime anime;
  final bool isSorted;
  final AnimeInfo animeInfo;
  final List<Chapter> sortedEpisodes;

  @override
  _BottomAppBarState createState() => _BottomAppBarState();
}

class _BottomAppBarState extends ConsumerState<_BottomAppBar> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    final isFavoriteFuture =
        ref.watch(isFavoriteProvider(widget.anime.animeTitle));

    final lastChapter =
        ref.watch(lastChapterProvider2(widget.anime.animeTitle));

    isFavoriteFuture.whenData((value) => isFavorite = value);

    return BottomAppBar(
      padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Row(
        children: [
          Expanded(
              child: lastChapter.when(
                  data: (data) {
                    if (data == null) {
                      return FilledButton.icon(
                        style: const ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))))),
                        onPressed: widget.sortedEpisodes.isEmpty
                            ? null
                            : () async {
                                final ani = widget.anime;
                                final chapt = Chapter(
                                    title: ani.animeTitle,
                                    id: '',
                                    chapterUrl: ' ',
                                    chapterNumber: 0,
                                    servers: [],
                                    chapterInfo: '',
                                    chapter: '');
                                String url = widget.isSorted
                                    ? widget.sortedEpisodes.first.chapterUrl
                                    : widget.sortedEpisodes.last.chapterUrl;
                                ani.chapterUrl = url;
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        ServerDialog(ani, chapt));
                              },
                        label: widget.sortedEpisodes.isEmpty
                            ? const Text('Próximamente')
                            : widget.anime.type == "Pelicula" &&
                                    widget.sortedEpisodes.length == 1
                                ? const Text('Ver pelicula')
                                : const Text('Comenzar a ver Ep. 1'),
                        icon: const Icon(Icons.play_arrow_rounded),
                      );
                    }

                    final eps = widget.sortedEpisodes.indexWhere((element) =>
                        element.chapterNumber == (data.chapterNumber + 1));

                    return FilledButton.icon(
                      style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))))),
                      onPressed: () async {
                        if (data.isCompleted && eps != -1) {
                          final ani = widget.anime;
                          String url = widget.sortedEpisodes[eps].chapterUrl;

                          data.position = 0;
                          ani.chapterUrl = url;

                          showDialog(
                              context: context,
                              builder: (context) => ServerDialog(ani, data));
                        } else {
                          final ani = widget.anime;
                          ani.chapterUrl = data.chapterUrl;

                          showDialog(
                              context: context,
                              builder: (context) => ServerDialog(ani, data));
                        }
                      },
                      label: data.isCompleted && eps != -1
                          ? Text('Comenzar a ver Ep. ${data.chapterNumber + 1}')
                          : Text('Continuar Ep. ${data.chapterNumber}'),
                      icon: const Icon(Icons.play_arrow_rounded),
                    );
                  },
                  error: (error, stackTrace) => Text('Error: $error'),
                  loading: () => const FilledButton(
                      onPressed: null,
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator())))),
          const SizedBox(width: 5),
          IconButton.filledTonal(
            style: const ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))))),
            onPressed: () async {
              final ani = Anime(
                  animeUrl: widget.anime.animeUrl,
                  imageUrl: widget.animeInfo.imageUrl,
                  animeTitle: widget.anime.animeTitle,
                  chapterInfo: widget.anime.chapterInfo,
                  chapterUrl: widget.anime.chapterUrl,
                  release: widget.anime.release,
                  type: widget.anime.type);

              await ref
                  .read(favoriteAnimesProvider.notifier)
                  .toggleFavorite(ani);
              ref.invalidate(isFavoriteProvider(widget.anime.animeTitle));

              await ref.read(favoriteAnimesProvider.notifier).loadNextPage();

              setState(() {});
            },
            icon: isFavoriteFuture.when(
              loading: () => const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(strokeWidth: 2)),
              data: (isFavorite) => isFavorite
                  ? const Icon(Icons.bookmark_added)
                  : const Icon(
                      Icons.bookmark_add_outlined,
                      // color: Colors.white,
                    ),
              error: (_, __) => throw UnimplementedError(),
            ),
          )
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
          xData.rating != null ? xData.rating! : '',
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
  if (themeController.themeMode == ThemeMode.dark) {
    return Colors.black87;
  } else if (themeController.themeMode == ThemeMode.light) {
    return Colors.white70;
  } else {
    if (SystemChrome.latestStyle!.statusBarBrightness == Brightness.dark) {
      return Colors.black87;
    } else {
      return Colors.white70;
    }
  }
}
