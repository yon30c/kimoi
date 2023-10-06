import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/items/filter_dialog.dart';
import 'package:kimoi/src/UI/items/search_icon.dart';
import 'package:kimoi/src/UI/providers/jikan/jikan_provider.dart';
import 'package:kimoi/src/UI/screens/loading/full_loading_screen.dart';
import 'package:kimoi/src/UI/screens/player/youtube_player.dart';
// import 'package:kimoi/src/UI/providers/jikan/jikan_provider.dart';
import 'package:kimoi/src/infrastructure/models/jikan_upcoming.dart' as up;

import '../../items/items.dart';
import '../../providers/providers.dart';

class HomeDirectory extends ConsumerStatefulWidget {
  const HomeDirectory({super.key});

  @override
  HomeDirectoryState createState() => HomeDirectoryState();
}

class HomeDirectoryState extends ConsumerState<HomeDirectory>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Explorar'),
          actions: const [
            SearchIcon()
          ],
          bottom: TabBar(
            isScrollable: true,
            controller: tabController,
            tabs: const [
              Tab(
                text: 'TODO EL ANIME',
              ),
              Tab(
                text: 'GÉNEROS',
              ),
              Tab(
                text: 'PRÓXIMAMENTE',
              ),
            ],
          ),
        ),
        body: TabBarView(
            controller: tabController,
            children: const [_AllAnimesPage(), _GenrePage(), _UpcomingPage()]));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

class _AllAnimesPage extends ConsumerStatefulWidget {
  const _AllAnimesPage();

  @override
  _AllAnimesPageState createState() => _AllAnimesPageState();
}

class _AllAnimesPageState extends ConsumerState<_AllAnimesPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  int? estreno;
  int? estado;
  String? tipo;
  String? genero;
  int? idioma;

  int initialLength = 0;
  int finalLength = 0;

  bool isLastPage = false;
  bool isLoading = false;

  ValueNotifier label = ValueNotifier<String>('Año');
  ValueNotifier filterLabel = ValueNotifier<String>('');

  late final ScrollController scrollController;
  late final TabController tabController;

  void clearAllFilter() {
    ref.read(estadoProvider.notifier).update((state) => 0);
    ref.read(estrenoProvider.notifier).update((state) => 0);
    ref.read(generoProvider.notifier).update((state) => '0');
    ref.read(tipoProvider.notifier).update((state) => '0');
    ref.read(idiomaProvider.notifier).update((state) => 0);

    ref.refresh(animeDirectoryProvider.notifier).getAnimes();
  }

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

      if ((scrollController.position.pixels + 500) >=
              scrollController.position.maxScrollExtent &&
          tabController.index == 0) {
        // add5();
        fetchData();
      }

      listen();
    });
  }

  Future fetchData() async {
    if (isLoading) return;
    if (isLastPage) return;

    initialLength = ref.read(animeDirectoryProvider).length;
    isLoading = true;
    setState(() {});

    ref.read(animeDirectoryProvider.notifier).getAnimes(
        estado: ref.read(estadoProvider),
        estreno: ref.read(estrenoProvider),
        tipo: ref.read(tipoProvider),
        genero: ref.read(generoProvider),
        idioma: ref.read(idiomaProvider));

    await Future.delayed(const Duration(seconds: 3), () {
      isLoading = false;
      finalLength = ref.read(animeDirectoryProvider).length;
    });
    setState(() {});

    // if (scrollController.position.pixels + 100 <=
    //     scrollController.position.maxScrollExtent) return;
    // if (scrollController.position.pixels + 200 <=
    //     scrollController.position.maxScrollExtent) return;

    // scrollController.animateTo(scrollController.position.pixels + 100,
    //     duration: const Duration(milliseconds: 300),
    //     curve: Curves.fastLinearToSlowEaseIn);

    if (initialLength == finalLength) {
      isLastPage = true;
    }
  }

  bool isFabActive = false;

  void listen() {
    final direction = scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
    if (scrollController.position.pixels ==
        scrollController.position.minScrollExtent) {
      hide();
    }
  }

  void show() {
    if (!isFabActive) setState(() => isFabActive = true);
  }

  void hide() {
    if (isFabActive) setState(() => isFabActive = false);
  }

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

    final animes = ref.watch(animeDirectoryProvider);
    filterLabel.value = ref.watch(labelProvider);

    final textStyle = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: isFabActive
          ? FloatingActionButton(
              key: const Key('all-ani-fab'),
              heroTag: 'all-ani-fab',
              onPressed: () {
                scrollController.animateTo(
                    scrollController.position.minScrollExtent,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.bounceIn);
              },
              child: const Icon(Icons.keyboard_arrow_up),
            )
          : null,
      body: Stack(
        children: [
          CustomScrollView(
            controller: scrollController,
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
                              style: TextStyle(color: color.primary),
                            ),
                          ],
                        ),
                        itemBuilder: (context) => years
                            .map((e) => PopupMenuItem(
                                  child: Text(
                                    e,
                                    style: textStyle.titleSmall,
                                  ),
                                  onTap: () {
                                    label.value = e;
                                    if (e != 'Año') {
                                      isLastPage = false;
                                      setState(() {});
                                      ref
                                          .read(estrenoProvider.notifier)
                                          .update((state) => int.parse(e));
                                      ref
                                          .refresh(
                                              animeDirectoryProvider.notifier)
                                          .getAnimes(
                                              estreno:
                                                  ref.read(estrenoProvider),
                                              tipo: ref.read(tipoProvider));
                                    } else {
                                      ref
                                          .read(estrenoProvider.notifier)
                                          .update((state) => 0);
                                      ref
                                          .refresh(
                                              animeDirectoryProvider.notifier)
                                          .getAnimes(
                                              tipo: ref.read(tipoProvider));
                                    }
                                  },
                                ))
                            .toList()),
                    const Spacer(),
                    if (filterLabel.value != '')
                      TextButton.icon(
                          onPressed: () {
                            isLastPage = false;
                            setState(() {});
                            ref
                                .read(labelProvider.notifier)
                                .update((state) => '');
                            ref
                                .read(tipoProvider.notifier)
                                .update((state) => '');
                            ref
                                .read(typeValueProvider.notifier)
                                .update((state) => Type.Todo);
                            ref
                                .refresh(animeDirectoryProvider.notifier)
                                .getAnimes(
                                  estreno: ref.read(estrenoProvider),
                                );
                          },
                          icon: const Icon(Icons.close_rounded, size: 18),
                          label: Text(filterLabel.value)),
                    IconButton(
                        onPressed: () {
                          isLastPage = false;
                          setState(() {});
                          showGeneralDialog(
                              context: context,
                              pageBuilder: (_, __, ___) {
                                return const FilterDialog();
                              });
                        },
                        icon: const Icon(Icons.tune_rounded)),
                  ],
                ),
              )),
              if (animes.isEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                      height: size.height * 0.5,
                      width: size.width,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      )),
                ),
              SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: size.height * 0.38),
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
          if (isLoading)
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
  bool get wantKeepAlive => true;
}

List<String> years = [
  'Año',
  '2023',
  '2022',
  '2021',
  '2020',
  '2019',
  '2018',
  '2017',
  '2016',
  '2015',
  '2014',
  '2013',
  '2012',
  '2011',
  '2010',
  '2009',
  '2008',
  '2007',
  '2006',
  '2005',
  '2004',
  '2003',
  '2002',
  '2001 ',
  '2000',
  '1999',
  '1998',
  '1997',
  '1996',
  '1995',
  '1994',
  '1993',
  '1992',
  '1991'
];

final genre = GenresTab(
    id: 'latino',
    iconPath: null,
    name: "Latino",
    title: "Latino",
    imagePath: "assets/images/ani-esp.webp",
    icon: FontAwesomeIcons.map);

class _GenrePage extends ConsumerWidget {
  const _GenrePage();

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: GestureDetector(
            onTap: () {
              ref.read(genreProvider.notifier).update((state) => genre);
              ref.read(generoProvider.notifier).update((state) => genre.id);
              context.push('/explorar/genre-screen/${genre.title}');
            },
            child: Card(
              margin: const EdgeInsets.all(4),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      image: AssetImage(genre.imagePath), fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
        SliverGrid.builder(
          // controller: scrollController,
          // padding: const EdgeInsets.only(bottom: 30, top: 10),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2)),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(genre.imagePath),
                                fit: BoxFit.cover),
                          ),
                        )),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        color: Colors.black38,
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          genre.icon != null
                              ? FaIcon(genre.icon, color: Colors.white)
                              : !genre.iconPath!.endsWith("svg")
                                  ? Image.asset(
                                      genre.iconPath!,
                                      height: 30,
                                    )
                                  : SvgPicture.asset(genre.iconPath!,
                                      height: 30,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                      semanticsLabel: 'A red up arrow'),
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
        ),
      ],
    );
  }
}

class GenresTab {
  final String id;
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
    id: 'accion',
    title: 'ACCIÓN',
    imagePath: 'assets/images/acc-ani.jpeg',
    icon: FontAwesomeIcons.fire,
  ),
  GenresTab(
      iconPath: null,
      name: 'Aventura',
      id: 'aventura',
      title: 'AVENTURA',
      imagePath: 'assets/images/av-ani.jpeg',
      icon: Icons.map_rounded),
  GenresTab(
      iconPath: 'assets/icons/laughing.png',
      name: 'Comedia',
      id: 'comedia',
      title: 'COMEDIA',
      imagePath: 'assets/images/com-ani.jpeg',
      icon: Icons.theater_comedy),
  GenresTab(
      iconPath: null,
      name: 'Drama',
      id: 'drama',
      title: 'DRAMA',
      imagePath: 'assets/images/dra-ani.jpeg',
      icon: FontAwesomeIcons.heartCrack),
  GenresTab(
      iconPath: null,
      name: 'Ecchi',
      id: 'ecchi',
      title: 'ECCHI',
      imagePath: 'assets/images/ecchi-ani.jpeg',
      icon: FontAwesomeIcons.fireFlameCurved),
  GenresTab(
      iconPath: null,
      name: 'Escolares',
      id: 'escolares',
      title: 'ESCOLARES',
      imagePath: 'assets/images/anime-esc.webp',
      icon: Icons.school_rounded),
  GenresTab(
      iconPath: null,
      name: 'Harem',
      id: 'harem',
      title: 'HAREM',
      imagePath: 'assets/images/harem-anime.jpg',
      icon: Icons.groups_3),
  GenresTab(
    iconPath: null,
    name: 'Fantasia',
    id: 'fantasia',
    title: 'FANTASIA',
    imagePath: 'assets/images/fan-ani.jpeg',
    icon: FontAwesomeIcons.fantasyFlightGames,
  ),
  GenresTab(
    iconPath: null,
    name: 'Militar',
    id: 'militar',
    title: 'MILITAR',
    imagePath: 'assets/images/militar.jpeg',
    icon: Icons.military_tech,
  ),
  GenresTab(
      iconPath: null,
      name: 'Musical',
      id: 'musica',
      title: 'MUSICAL',
      imagePath: 'assets/images/mus-ani.jpeg',
      icon: FontAwesomeIcons.music),
  GenresTab(
      iconPath: null,
      name: 'Romance',
      id: 'romance',
      title: 'ROMANCE',
      imagePath: 'assets/images/rom-ani.jpeg',
      icon: FontAwesomeIcons.heartPulse),
  GenresTab(
    iconPath: null,
    name: 'Ciencia Ficción',
    id: 'ciencia-ficcion',
    title: 'CIENCIA FICCIÓN',
    imagePath: 'assets/images/cie-ani.jpeg',
    icon: Icons.science,
  ),
  GenresTab(
    iconPath: "assets/icons/mystery.svg",
    name: 'Misterio',
    id: 'misterio',
    title: 'MISTERIO',
    imagePath: 'assets/images/anime-misterio.jpg',
    icon: null,
  ),
  GenresTab(
    iconPath: null,
    name: 'Seinen',
    id: 'seinen',
    title: 'SEINEN',
    imagePath: 'assets/images/sei-ani2.jpeg',
    icon: Icons.interests,
  ),
  GenresTab(
      iconPath: 'assets/icons/watch-movie.png',
      name: 'Shoujo',
      id: 'shojo',
      title: 'SHOUJO',
      imagePath: 'assets/images/shou-ani2.jpeg',
      icon: null),
  GenresTab(
      iconPath: null,
      name: 'Shounen',
      id: 'shonen',
      title: 'SHOUNEN',
      imagePath: 'assets/images/shoune-ani2.jpeg',
      icon: FontAwesomeIcons.gamepad),
  GenresTab(
      iconPath: null,
      name: 'Recuentos de la vida',
      id: 'recuerdos-de-la-vida',
      title: 'RECUENTOS DE LA VIDA',
      imagePath: 'assets/images/rec-ani.jpeg',
      icon: FontAwesomeIcons.calendarDay),
  GenresTab(
      iconPath: null,
      name: 'Deportes',
      id: 'deportes',
      title: 'DEPORTES',
      imagePath: 'assets/images/dep-ani.jpeg',
      icon: FontAwesomeIcons.basketball),
  GenresTab(
      iconPath: null,
      name: 'Sobrenatural',
      id: 'sobrenatural',
      title: 'SOBRENATURAL',
      imagePath: 'assets/images/sob-ani2.jpeg',
      icon: FontAwesomeIcons.ghost),
  GenresTab(
      iconPath: 'assets/icons/triller.svg',
      name: 'Triller',
      id: 'horror',
      title: 'TRILLER',
      imagePath: 'assets/images/tri-ani.jpeg',
      icon: null)
];

class _UpcomingPage extends ConsumerStatefulWidget {
  const _UpcomingPage();

  @override
  _UpcomingPageState createState() => _UpcomingPageState();
}

class _UpcomingPageState extends ConsumerState<_UpcomingPage> {
  late ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    ref.read(upcomingProvider.notifier).getAnimes();

    controller.addListener(() {
      if (controller.position.pixels + 200 >=
          controller.position.maxScrollExtent) {
        fetchMoreUp();
      }
    });
  }

  fetchMoreUp() async {
    ref.read(upcomingProvider.notifier).getAnimes();
  }

  @override
  Widget build(BuildContext context) {
    final animes = ref.watch(upcomingProvider);

    final size = MediaQuery.of(context).size;

    if (animes.isEmpty) {
      return const Scaffold(
        body: FullScreenLoader(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        controller: controller,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 7,
          mainAxisExtent: size.height * 0.4,
          crossAxisSpacing: 2,
        ),
        itemCount: animes.length,
        itemBuilder: (context, index) {
          return animePosterLink(anime: animes[index]);
        },
      ),
    );
  }

  Widget animePosterLink({required up.UpDatum anime}) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final color = Theme.of(context).colorScheme;

    return GestureDetector(
      child: Card(
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(2)),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(
                        anime.images.entries.first.value.imageUrl),
                    fit: BoxFit.cover,
                  )),
                ),
                if (anime.trailer.youtubeId != null)
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: IconButton.filled(
                      onPressed: () {
                        showGeneralDialog(
                          context: context,
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return YoutubePlayerScreen(
                                id: anime.trailer.youtubeId!);
                          },
                        );
                      },
                      style: const ButtonStyle(
                          visualDensity: VisualDensity.compact,
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white)),
                      icon: const FaIcon(
                        FontAwesomeIcons.youtube,
                        color: Colors.red,
                      ),
                      // label: const Text('Trailer', style: TextStyle(color: Colors.white),)
                    ),
                  )
              ],
            ),
            Container(
              height: size.height * 0.09,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    anime.title,
                    style: textStyle.labelMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Text(
                    anime.aired.string,
                    style:
                        textStyle.labelMedium?.copyWith(color: color.primary),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
