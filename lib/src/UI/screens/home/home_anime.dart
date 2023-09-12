import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/screens/loading/full_loading_screen.dart';
import 'package:kimoi/src/UI/services/delegates/search_delegate.dart';

import '../../../domain/domain.dart';
import '../../providers/providers.dart';
import '../../views/views.dart';

class HomeAnime extends ConsumerStatefulWidget {
  static const String name = 'Home-screen';

  const HomeAnime({super.key});

  @override
  HomeAnimeState createState() => HomeAnimeState();
}

class HomeAnimeState extends ConsumerState<HomeAnime> {
  List<Anime> shounenAnime = [];
  List<Anime> accionAnime = [];

  @override
  void initState() {
    super.initState();
    ref.read(lastAnimesAddedProvider.notifier).getAnimes();
    ref.read(recentAnimesProvider.notifier).getAnimes();
    getShounenAnime();
    getAccionAnime();
  }

  getShounenAnime() async {
    shounenAnime =
        await ref.read(animeRepositoryProvider).getDirectory(genero: 9);
    setState(() {});
  }

  getAccionAnime() async {
    accionAnime =
        await ref.read(animeRepositoryProvider).getDirectory(genero: 1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final lastAnimes = ref.watch(lastAnimesAddedProvider);
    final lastEpisodes = ref.watch(recentAnimesProvider);

    // final popularNews = ref.watch(popularNewsProvider);

    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth > 600) {
        return FadeIn(
            child: const Scaffold(
                body: Center(child: CircularProgressIndicator())));
      }

      if (lastAnimes.isEmpty || lastEpisodes.isEmpty) {
        return const Scaffold(body: FullScreenLoader());
      }

      return FadeIn(
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async =>
                await ref.read(recentAnimesProvider.notifier).getAnimes(),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  title: const Text('Animes'),
                  actions: [
                    IconButton(
                        onPressed: () async {
                          await showSearch(
                                  context: context,
                                  delegate: SearchAnimeDelegate(
                                      searchAnimes: ref
                                          .watch(
                                              searchedMoviesProvider.notifier)
                                          .searchAnimes))
                              .then((value) {
                            if (value == null) return;
                            ref
                                .read(animeProvider.notifier)
                                .update((state) => value);
                            context.push('/anime-screen');
                          });
                        },
                        icon: const Icon(Icons.search, size: 30))
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(
                        height: 10,
                      ),
                      RandomListView(
                        animes: lastAnimes,
                      ),
                      AnimesView(
                        animes: lastEpisodes,
                        title: 'Últimos episodios',
                      ),
                      AnimesListview(
                          height: 180,
                          width: 130,
                          animes: lastAnimes,
                          title: 'Últimos animes',
                          subtitle: '2023',
                          loadNextPage: ref
                              .read(lastAnimesAddedProvider.notifier)
                              .getAnimes),
                      AnimesListview(
                          height: 180,
                          width: 130,
                          animes: accionAnime,
                          title: 'Accion',
                          loadNextPage: ref
                              .read(lastAnimesAddedProvider.notifier)
                              .getAnimes),
                      AnimesListview(
                          height: 180,
                          width: 130,
                          animes: shounenAnime,
                          title: 'Shounen',
                          loadNextPage: ref
                              .read(lastAnimesAddedProvider.notifier)
                              .getAnimes),
                      const SizedBox(
                        height: 15,
                      )
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
