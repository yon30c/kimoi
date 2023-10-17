import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kimoi/src/UI/items/search_icon.dart';
import 'package:kimoi/src/UI/items/servers_dialog.dart';
import 'package:kimoi/src/UI/screens/home/home.dart';
import 'package:kimoi/src/UI/screens/loading/full_loading_screen.dart';
import 'package:kimoi/src/UI/screens/player/local_player.dart';
import 'package:kimoi/src/infrastructure/infrastructure.dart';

import '../../../domain/domain.dart';
import '../../providers/providers.dart';
import '../../views/views.dart';

class HomeAnime extends StatefulHookConsumerWidget {
  static const String name = 'Home-screen';

  const HomeAnime({super.key});

  @override
  HomeAnimeState createState() => HomeAnimeState();
}

class HomeAnimeState extends ConsumerState<HomeAnime> {
  List<Anime> animes = [];
  List<Anime> latanimes = [];
  List<Chapter> nowWatching = [];
  bool listView2 = false;
  bool listView3 = false;
  bool lastCharge = false;
  bool secondCharge = false;
  Map<String, Chapter> watching = {};

  int getRandomYear() {
    final allowedYears = [2023, 2022, 2021, 2020, 2019, 2018, 2017];
    return allowedYears[Random().nextInt(allowedYears.length)];
  }

  int getRandomPage() {
    final allowedPage = [1, 2, 3, 4, 5, 6, 7, 8];
    return allowedPage[Random().nextInt(allowedPage.length)];
  }

  Future<void> fetchData() async {
    animes = await ref
        .read(animeRepositoryProvider)
        .getDirectory(estreno: getRandomYear(), p: getRandomPage());
    setState(() {});
  }

  void listen(ScrollController controller) async {
    if (controller.position.pixels == controller.position.maxScrollExtent && !lastCharge) {
      if (lastCharge) return;
      lastCharge = true;
      await ref.read(lastAnimesAddedProvider.notifier).getAnimes();
      setState(() {});
    } else if (
      controller.position.pixels == controller.position.maxScrollExtent &&
      lastCharge) {
      if (secondCharge) return;
      secondCharge = true;
      latanimes = await ref
          .read(animeRepositoryProvider)
          .getDirectory(genero: "latino", p: getRandomPage());
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    ref.read(recentAnimesProvider.notifier).getAnimes();
    ref.read(nowWatchingProvider.notifier).loadWatching();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final lastAnimes = ref.watch(lastAnimesAddedProvider);
    final lastEpisodes = ref.watch(recentAnimesProvider);
    nowWatching = ref.watch(nowWatchingProvider);

    final controller = useScrollController();

    controller.addListener(() => listen(controller));

    // final popularNews = ref.watch(popularNewsProvider);

    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth > 600) {
        return FadeIn(
            child: const Scaffold(
                body: Center(child: CircularProgressIndicator())));
      }

      if (lastEpisodes.isEmpty) {
        return const Scaffold(body: FullScreenLoader());
      }

      return FadeIn(
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              animes.clear();
              fetchData();
              await ref.refresh(recentAnimesProvider.notifier).getAnimes();
            },
            child: CustomScrollView(
              controller: controller,
              slivers: [
                const SliverAppBar(
                  title: Text('Animes'),
                  actions: [SearchIcon()],
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(
                        height: 10,
                      ),
                      RandomListView(
                        animes: animes,
                      ),

                      AnimesView(
                        animes: lastEpisodes,
                        title: 'Últimos episodios',
                      ),
                      if (nowWatching.isNotEmpty)
                        KeepWatching(nowWatching: nowWatching),

                      if (lastCharge)
                        AnimesListview(
                          height: 180,
                          width: 130,
                          animes: lastAnimes,
                          title: 'Últimos animes',
                          subtitle: '2023',
                        ),
                      if (secondCharge)
                        AnimesListview(
                          height: 180,
                          width: 130,
                          animes: latanimes,
                          title: 'En latino',
                          subtitle: 'Ver más',
                          genre: GenresTab(
                              id: "latino",
                              iconPath: null,
                              name: "Latino",
                              title: "Latino",
                              imagePath: '',
                              icon: FontAwesomeIcons.map),
                        ), //         .getAnimes),

                      const SizedBox(
                        height: 15,
                      ),
                      if (!lastCharge || !secondCharge)
                        const Center(
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class KeepWatching extends ConsumerWidget {
  const KeepWatching({
    super.key,
    required this.nowWatching,
  });

  final List<Chapter> nowWatching;

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Continuar viendo',
              style: textStyle.titleLarge,
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              itemCount: nowWatching.length,
              itemBuilder: (context, index) {
                final chapt = nowWatching[index];
                final anime = chapterToAnime(chapt);

                return GestureDetector(
                  onTap: () async {
                    final anime = chapterToAnime(chapt);
                    showDialog(
                        context: context,
                        builder: (context) => ServerDialog(anime, chapt));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: size.width * 0.25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(chapt.imageUrl!))),
                            ),
                            Container(
                              color: Colors.black54,
                              width: size.width * 0.25,
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
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                            padding: const EdgeInsets.all(4),
                            width: size.width * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chapt.title,
                                  maxLines: 2,
                                  style: textStyle.labelLarge
                                      ?.copyWith(color: color.primary),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  chapt.chapter,
                                  maxLines: 2,
                                  style: textStyle.labelLarge,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Restante: ${formatDuration(chapt.duration - chapt.position)}',
                                  maxLines: 2,
                                  style: textStyle.labelMedium,
                                ),
                              ],
                            )),
                        PopupMenuButton(
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.play_circle_fill_rounded,
                                          color: color.primary,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text('Ver ahora'),
                                      ],
                                    ),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              ServerDialog(anime, chapt));
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: Row(
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
                                      ref
                                          .read(animeProvider.notifier)
                                          .update((state) => anime);

                                      await ref
                                          .read(
                                              isWatchingAnimeProvider.notifier)
                                          .loadLastWatchingChapter(
                                              anime.animeTitle)
                                          .then((value) {
                                        ref
                                            .read(lastChapterWProvider.notifier)
                                            .update((state) => value);
                                        context.push('/anime-screen');
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
                                      await ref
                                          .read(
                                              isWatchingAnimeProvider.notifier)
                                          .removeChapter(chapt)
                                          .then((value) => ref
                                              .refresh(
                                                  nowWatchingProvider.notifier)
                                              .loadWatching());
                                    },
                                  ),
                                ])
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
