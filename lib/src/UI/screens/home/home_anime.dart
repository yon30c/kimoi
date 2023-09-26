import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/items/about_dialog.dart';
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
  List<Anime> animes = [];

  int getRandomYear() {
    final allowedYears = [2022, 2021, 2020, 2019];
    return allowedYears[Random().nextInt(allowedYears.length)];
  }

  int getRandomPage() {
    final allowedPage = [1, 2, 3, 4, 5];
    return allowedPage[Random().nextInt(allowedPage.length)];
  }

  Future fetchData() async {
    setState(() {});
    animes = await ref
        .read(animeRepositoryProvider)
        .getDirectory(estreno: getRandomYear(), p: getRandomPage());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ref.read(lastAnimesAddedProvider.notifier).getAnimes();
    ref.read(recentAnimesProvider.notifier).getAnimes();
    fetchData();
  }

  void onPressed() async {
    await showSearch(
            context: context,
            delegate: SearchAnimeDelegate(
                searchAnimes:
                    ref.watch(searchedMoviesProvider.notifier).searchAnimes))
        .then((value) {
      if (value == null) return;
      ref.read(animeProvider.notifier).update((state) => value);
      context.push('/anime-screen');
    });
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
            onRefresh: () async {
              animes.clear();
              fetchData();
              await ref.refresh(recentAnimesProvider.notifier).getAnimes();
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  title: const Text('Animes'),
                  actions: [
                    IconButton(
                        onPressed: () => showGeneralDialog(
                              context: context,
                              pageBuilder: (context, __, ___) =>
                                  const CsAboutDialog(),
                            ),
                        icon: const Icon(Icons.info)),
                    IconButton(
                        onPressed: onPressed,
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
                        animes: animes,
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
                      ),                      //         .getAnimes),
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
