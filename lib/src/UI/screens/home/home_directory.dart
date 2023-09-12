import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/items/anime_card.dart';
import 'package:kimoi/src/UI/services/delegates/search_delegate.dart';
import 'package:kimoi/src/domain/entities/anime.dart';

import '../../items/items.dart';
import '../../providers/providers.dart';

class HomeDirectory extends ConsumerStatefulWidget {
  const HomeDirectory({super.key});

  @override
  HomeDirectoryState createState() => HomeDirectoryState();
}

class HomeDirectoryState extends ConsumerState<HomeDirectory>
    with SingleTickerProviderStateMixin {
  int? estreno;
  int? estado;
  int? tipo;
  int? genero;
  int? idioma;

  bool isLoading = false;
  bool activeFloatingButtom = false;

  late final ScrollController scrollController;
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    ref.read(animeDirectoryProvider.notifier).getAnimes(
        estado: estado,
        estreno: estreno,
        tipo: tipo,
        genero: genero,
        idioma: idioma);

    scrollController.addListener(() {
      // if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 300) >=
              scrollController.position.maxScrollExtent &&
          tabController.index == 0) {
        // add5();
        fetchData();
      }

      if (scrollController.position.pixels > 500) activateFloatingB();
      if (scrollController.position.pixels ==
          scrollController.position.minScrollExtent) desactivateFloatingB();
    });
  }

  void activateFloatingB() {
    if (activeFloatingButtom) return;
    activeFloatingButtom = true;
    setState(() {});
  }

  void desactivateFloatingB() {
    if (!activeFloatingButtom) return;
    activeFloatingButtom = false;
    setState(() {});
  }

  Future fetchData() async {
    if (isLoading) return;

    isLoading = true;
    setState(() {});

    ref.read(animeDirectoryProvider.notifier).getAnimes(
        estado: ref.read(estadoProvider),
        estreno: ref.read(estrenoProvider),
        tipo: ref.read(tipoProvider),
        genero: ref.read(generoProvider),
        idioma: ref.read(idiomaProvider));
    await Future.delayed(const Duration(seconds: 3));

    isLoading = false;
    setState(() {});

    if (scrollController.position.pixels + 100 <=
        scrollController.position.maxScrollExtent) return;

    scrollController.animateTo(scrollController.position.pixels + 300,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
  }

  bool activeFilter = false;

  double height = 64;

  void clearAllFilter() {
    ref.read(estadoProvider.notifier).update((state) => 0);
    ref.read(estrenoProvider.notifier).update((state) => 0);
    ref.read(generoProvider.notifier).update((state) => 0);
    ref.read(tipoProvider.notifier).update((state) => 0);
    ref.read(idiomaProvider.notifier).update((state) => 0);

    ref.refresh(animeDirectoryProvider.notifier).getAnimes();
  }

  @override
  Widget build(BuildContext context) {
    final animes = ref.watch(animeDirectoryProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Explorar'),
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
          bottom: PreferredSize(
            preferredSize: Size(size.width, 50),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TabBar.secondary(
                        dividerColor: Colors.transparent,
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        controller: tabController,
                        tabs: const [
                          Tab(
                            text: 'TODO EL ANIME',
                          ),
                          Tab(
                            text: 'GÉNEROS',
                          ),
                        ]),
                  ],
                ),
                const Divider(
                  height: 1,
                )
              ],
            ),
          ),
        ),
        body: TabBarView(controller: tabController, children: [
          _AllAnimesPage(
              scrollController: scrollController,
              animes: animes,
              isLoading: isLoading),
          const _GenrePage()
        ]));
  }

  @override
  void dispose() {
    tabController.removeListener(() {});
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }
}

class _AllAnimesPage extends StatefulWidget {
  const _AllAnimesPage({
    required this.scrollController,
    required this.animes,
    required this.isLoading,
  });

  final ScrollController scrollController;
  final List<Anime> animes;
  final bool isLoading;

  @override
  State<_AllAnimesPage> createState() => _AllAnimesPageState();
}

class _AllAnimesPageState extends State<_AllAnimesPage>
    with AutomaticKeepAliveClientMixin {
  SliverPersistentHeader makeHeader(Widget child) {
    return SliverPersistentHeader(
      // pinned: true,
      floating: true,
      delegate:
          SliverAppBarDelegate(minHeight: 40.0, maxHeight: 40.0, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final textStyle = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            makeHeader(DecoratedBox(
              decoration: BoxDecoration(color: color.background),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Text(
                    'Popular',
                    style: textStyle.titleMedium,
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        //Todo:
                      },
                      icon: const Icon(Icons.sort)),
                  IconButton(
                      onPressed: () {
                        //Todo:
                      },
                      icon: const Icon(Icons.filter_alt)),
                ],
              ),
            )),
            SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: size.height * 0.40),
              itemCount: widget.animes.length,
              itemBuilder: (BuildContext context, int index) {
                final size = MediaQuery.of(context).size;
                final anime = widget.animes[index];
                if (widget.animes.isEmpty) {
                  return const CircularProgressIndicator();
                }
                return AnimeCard(
                  height: size.height * 0.27,
                  width: (size.width / 2) - 5,
                  anime: anime,
                  borderRadius: 5,
                  // onTap: () => showButtonSheet(context, ref: ref, anime: anime),
                );
              },
            ),
          ],
        ),
        if (widget.isLoading)
          Positioned(
              right: (size.width / 2) - 25,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                height: 50,
                width: 50,
                child: const CircularProgressIndicator(),
              )),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _GenrePage extends ConsumerWidget {
  const _GenrePage();

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    return GridView.builder(
      // controller: scrollController,
      padding: const EdgeInsets.only(bottom: 30, top: 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: size.height * 0.15, crossAxisCount: 2),
      itemCount: genresTab.length,
      itemBuilder: (context, index) {
        final genre = genresTab[index];
        return GestureDetector(
          onTap: () {
            ref.read(genreProvider.notifier).update((state) => genre);
            ref.read(generoProvider.notifier).update((state) => genre.id);
            context.push('/explorar/genre-screen/${genre.title}');
          },
          child: Card(
            child: Stack(
              children: [
                ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox.expand(
                        child: Image.asset(
                      genre.imagePath,
                      fit: BoxFit.cover,
                    ))),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.black38,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      genre.icon != null
                          ? FaIcon(genre.icon)
                          : Image.asset(
                              genre.iconPath!,
                              height: 30,
                            ),
                      Text(
                        genre.title,
                        style: textStyle.labelMedium
                            ?.copyWith(color: Colors.white),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class GenresTab {
  final int id;
  final String title;
  final String imagePath;
  final IconData? icon;
  final String name;
  final String? iconPath;

  GenresTab(
      {required this.id,
      required this.iconPath,
      required this.name,
      required this.title,
      required this.imagePath,
      required this.icon});
}

List<GenresTab> genresTab = [
  GenresTab(
    iconPath: null,
    name: 'Acción',
    id: 1,
    title: 'ACCIÓN',
    imagePath: 'assets/images/acc-ani.jpeg',
    icon: FontAwesomeIcons.fire,
  ),
  GenresTab(
      iconPath: null,
      name: 'Aventura',
      id: 23,
      title: 'AVENTURA',
      imagePath: 'assets/images/av-ani.jpeg',
      icon: Icons.map_rounded),
  GenresTab(
      iconPath: 'assets/icons/laughing.png',
      name: 'Comedia',
      id: 5,
      title: 'COMEDIA',
      imagePath: 'assets/images/com-ani.jpeg',
      icon: null),
  GenresTab(
      iconPath: null,
      name: 'Drama',
      id: 6,
      title: 'DRAMA',
      imagePath: 'assets/images/dra-ani.jpeg',
      icon: FontAwesomeIcons.heartCrack),
  GenresTab(
      iconPath: null,
      name: 'Ecchi',
      id: 11,
      title: 'ECCHI',
      imagePath: 'assets/images/ecchi-ani.jpeg',
      icon: FontAwesomeIcons.fireFlameCurved),
  GenresTab(
    iconPath: null,
    name: 'Fantasia',
    id: 13,
    title: 'FANTASIA',
    imagePath: 'assets/images/fan-ani.jpeg',
    icon: FontAwesomeIcons.fantasyFlightGames,
  ),
  GenresTab(
      iconPath: null,
      name: 'Musical',
      id: 36,
      title: 'MUSICAL',
      imagePath: 'assets/images/mus-ani.jpeg',
      icon: FontAwesomeIcons.music),
  GenresTab(
      iconPath: null,
      name: 'Romance',
      id: 3,
      title: 'ROMANCE',
      imagePath: 'assets/images/rom-ani.jpeg',
      icon: FontAwesomeIcons.heartPulse),
  GenresTab(
    iconPath: null,
    name: 'Ciencia Ficción',
    id: 20,
    title: 'CIENCIA FICCIÓN',
    imagePath: 'assets/images/cie-ani.jpeg',
    icon: Icons.science,
  ),
  GenresTab(
    iconPath: null,
    name: 'Seinen',
    id: 7,
    title: 'SEINEN',
    imagePath: 'assets/images/sei-ani2.jpeg',
    icon: Icons.interests,
  ),
  GenresTab(
      iconPath: 'assets/icons/watch-movie.png',
      name: 'Shoujo',
      id: 4,
      title: 'SHOUJO',
      imagePath: 'assets/images/shou-ani2.jpeg',
      icon: null),
  GenresTab(
      iconPath: null,
      name: 'Shounen',
      id: 9,
      title: 'SHOUNEN',
      imagePath: 'assets/images/shoune-ani2.jpeg',
      icon: FontAwesomeIcons.gamepad),
  GenresTab(
      iconPath: null,
      name: 'Recuentos de la vida',
      id: 10,
      title: 'RECUENTOS DE LA VIDA',
      imagePath: 'assets/images/rec-ani.jpeg',
      icon: FontAwesomeIcons.calendarDay),
  GenresTab(
      iconPath: null,
      name: 'Deportes',
      id: 8,
      title: 'DEPORTES',
      imagePath: 'assets/images/dep-ani.jpeg',
      icon: FontAwesomeIcons.basketball),
  GenresTab(
      iconPath: null,
      name: 'Sobrenatural',
      id: 12,
      title: 'SOBRENATURAL',
      imagePath: 'assets/images/sob-ani2.jpeg',
      icon: FontAwesomeIcons.ghost),
  GenresTab(
      iconPath: 'assets/icons/knif.png',
      name: 'Triller',
      id: 27,
      title: 'TRILLER',
      imagePath: 'assets/images/tri-ani.jpeg',
      icon: null)
];
