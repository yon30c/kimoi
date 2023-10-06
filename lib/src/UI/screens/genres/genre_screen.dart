import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kimoi/src/UI/items/items.dart';
import 'package:kimoi/src/UI/items/search_icon.dart';
import 'package:kimoi/src/UI/providers/animes/anime_filter_provider.dart';
import 'package:kimoi/src/UI/providers/animes/anime_repository_provider.dart';
import 'package:kimoi/src/UI/screens/home/home.dart';
import 'package:kimoi/src/UI/screens/loading/full_loading_screen.dart';
import 'package:kimoi/src/domain/domain.dart';

class GenreScreen extends ConsumerStatefulWidget {
  const GenreScreen({
    super.key,
    required this.genero,
  });

  final String genero;

  @override
  GenreScreenState createState() => GenreScreenState();
}

class GenreScreenState extends ConsumerState<GenreScreen> {
  bool isLoading = false;
  bool isFechingMoreData = false;
  int page = 1;

  List<Anime> animes = [];
  late ScrollController scrollController;

  late GenresTab genre;

  Future fetchData() async {
    if (isLoading) return;
    isLoading = true;
    setState(() {});
    animes = await ref
        .read(animeRepositoryProvider)
        .getDirectory(genero: genre.id, p: page);
    isLoading = false;
    page++;
    setState(() {});
  }

  Future fetchMoreData() async {
    if (isFechingMoreData) return;
    isFechingMoreData = true;
    setState(() {});
    animes.addAll(await ref
        .read(animeRepositoryProvider)
        .getDirectory(genero: genre.id, p: page));
    // await Future.delayed(const Duration(seconds: 1));
    isFechingMoreData = false;
    page++;
    setState(() {});
    if (scrollController.position.pixels + 100 <=
        scrollController.position.maxScrollExtent) return;

    scrollController.animateTo(scrollController.position.pixels + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
  }

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    genre = ref.read(genreProvider)!;

    fetchData();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        fetchMoreData();
      }
    });
  }

  SliverPersistentHeader makeHeader(Widget child) {
    return SliverPersistentHeader(
      pinned: true,
      // floating: true,
      delegate:
          SliverAppBarDelegate(minHeight: 40.0, maxHeight: 40.0, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: isLoading
          ? const FullScreenLoader()
          : Stack(
              children: [
                CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      title: const Text('Géneros'),
                      actions: const [
                        SearchIcon()
                      ],
                      bottom: PreferredSize(
                        preferredSize: Size(size.width, 50),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              genre.icon != null
                                  ? FaIcon(
                                      genre.icon,
                                      color: color.primary,
                                    )
                                  : !genre.iconPath!.endsWith("svg")
                                      ? Image.asset(
                                          genre.iconPath!,
                                          height: 25,
                                          color: color.primary,
                                        )
                                      : SvgPicture.asset(genre.iconPath!,
                                          height: 25,
                                          colorFilter: ColorFilter.mode(
                                            color.primary, BlendMode.srcIn),),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                genre.name,
                                style: textStyle.titleMedium?.copyWith(color: color.primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverGrid.builder(
                      // controller: widget.scrollController,
                      // padding: const EdgeInsets.only(bottom: 20, top: 10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: size.height * 0.38),
                      itemCount: animes.length,
                      itemBuilder: (BuildContext context, int index) {
                        final size = MediaQuery.of(context).size;
                        final anime = animes[index];
                        if (animes.isEmpty) {
                          return const CircularProgressIndicator();
                        }
                        return AnimeCard(
                          height: size.height * 0.27,
                          width: (size.width / 2) - 5,
                          anime: anime,
                          // onTap: () => showButtonSheet(context, ref: ref, anime: anime),
                        );
                      },
                    ),
                  ],
                ),
                if (isFechingMoreData)
                  Positioned(
                      right: (size.width / 2) - 25,
                      bottom: 20,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: color.background, shape: BoxShape.circle),
                        height: 50,
                        width: 50,
                        child: const CircularProgressIndicator(),
                      )),
              ],
            ),
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }
}
