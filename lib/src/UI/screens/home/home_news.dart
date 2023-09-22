import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimoi/src/UI/services/webview/webview.dart';

import '../../../infrastructure/infrastructure.dart';
import '../../items/items.dart';
import '../../providers/providers.dart';
import '../screens.dart';

class HomeNews extends ConsumerStatefulWidget {
  static const String name = 'Home-screen';

  const HomeNews({super.key});

  @override
  HomeNewsState createState() => HomeNewsState();
}

class HomeNewsState extends ConsumerState<HomeNews>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  List<ArticleInfo> articles = [];

  late ScrollController scrollController;

  List<Tab> tabs = const [
    Tab(text: 'Recientes'),
    Tab(text: 'Anime'),
    Tab(text: 'Manga'),
    Tab(text: 'Japon'),
  ];

  bool isLoading = false;

  late KudasaiNotifier kudasaiNotifier;

  @override
  void initState() {
    super.initState();

    ref.read(initialNewsLoadingProvider);

    kudasaiNotifier = ref.read(recentNewsProvider.notifier);
    scrollController = ScrollController();
    controller = TabController(length: tabs.length, vsync: this);
    ref.read(popularNewsProvider.notifier).getNews();
    ref.read(recentNewsProvider.notifier).getNews();

    scrollController.addListener(listen);
  }

  void listen() {
    if ((scrollController.position.pixels + 300) >=
        scrollController.position.maxScrollExtent) {
      // add5();
      fetchData();
    }

    final direction = scrollController.position.userScrollDirection;

    if (direction == ScrollDirection.forward) {
      activateFloatingB();
    } else if (direction == ScrollDirection.reverse) {
      desactivateFloatingB();
    }

    if (scrollController.position.pixels ==
        scrollController.position.minScrollExtent) {
      desactivateFloatingB();
    }
  }

  void activateFloatingB() {
    if (!activeFloatingButtom) setState(() => activeFloatingButtom = true);
  }

  void desactivateFloatingB() {
    if (activeFloatingButtom) setState(() => activeFloatingButtom = false);
  }

  Future fetchData() async {
    if (isLoading) return;

    isLoading = true;
    setState(() {});

    kudasaiNotifier.getNews();
    await Future.delayed(const Duration(seconds: 3));

    kudasaiNotifier.addListener((state) {
      articles = state;
    });

    isLoading = false;
    setState(() {});

    if (scrollController.position.pixels + 100 <=
        scrollController.position.maxScrollExtent) return;

    scrollController.animateTo(scrollController.position.pixels + 120,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
  }

  int index = 0;
  bool flag = true;
  bool loading = false;
  bool activeFloatingButtom = false;

  @override
  Widget build(BuildContext context) {
    void onTap(int value) async {
      switch (value) {
        case 0:
          if (index != 0) {
            index = 0;
            loading = true;
            setState(() {});
            await Future.delayed(const Duration(milliseconds: 200));
            articles = ref.read(recentNewsProvider);
            kudasaiNotifier = ref.read(recentNewsProvider.notifier);
            loading = false;
            setState(() {});
          }
          break;
        case 1:
          if (index != 1) {
            index = 1;
            loading = true;
            setState(() {});
            await ref.read(animeNewsProvider.notifier).getNews();
            await Future.delayed(const Duration(milliseconds: 100));
            articles = ref.read(animeNewsProvider);
            kudasaiNotifier = ref.read(animeNewsProvider.notifier);
            loading = false;
            setState(() {});
          }
          break;
        case 2:
          if (index != 2) {
            index = 2;
            loading = true;
            setState(() {});
            await ref.read(mangaNewsProvider.notifier).getNews();
            await Future.delayed(const Duration(milliseconds: 100));
            articles = ref.read(mangaNewsProvider);
            kudasaiNotifier = ref.read(mangaNewsProvider.notifier);
            loading = false;
            setState(() {});
          }
          break;
        case 3:
          if (index != 3) {
            index = 3;
            loading = true;
            setState(() {});
            await ref.read(japonNewsProvider.notifier).getNews();
            await Future.delayed(const Duration(milliseconds: 100));
            articles = ref.read(japonNewsProvider);
            kudasaiNotifier = ref.read(japonNewsProvider.notifier);
            loading = false;
            setState(() {});
          }
          break;
        default:
          await Future.delayed(const Duration(milliseconds: 200));
          articles = ref.read(recentNewsProvider);
          kudasaiNotifier = ref.read(recentNewsProvider.notifier);
          setState(() {});
      }
    }

    final popularNews = ref.watch(popularNewsProvider);
    final size = MediaQuery.of(context).size;

    final initialLoading = ref.watch(initialNewsLoadingProvider);
    if (initialLoading) return const FullScreenLoader();

    if (!initialLoading && flag) {
      articles = ref.watch(recentNewsProvider);
      flag = false;
    }

    SliverPersistentHeader makeHeader(Widget child) {
      return SliverPersistentHeader(
        // pinned: true,
        delegate: SliverAppBarDelegate(
            minHeight: kToolbarHeight, maxHeight: kToolbarHeight, child: child),
      );
    }

    return Scaffold(
        floatingActionButton: activeFloatingButtom
            ? FloatingActionButton(
                heroTag: "news-screen",
                onPressed: () {
                  scrollController.animateTo(
                      scrollController.position.minScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn);
                  activeFloatingButtom = false;
                  setState(() {});
                },
                child: const Icon(Icons.keyboard_arrow_up),
              )
            : null,
        body: CustomScrollView(controller: scrollController, slivers: [
          const SliverAppBar(
            title: Text('Noticias'),
            // pinned: true,
          ),
          SliverToBoxAdapter(
            child: popularNews.isEmpty
                ? SizedBox(
                    height: size.height * 0.25,
                    width: size.width,
                    child: const Center(child: CircularProgressIndicator()))
                : NewsSlideshow(articles: popularNews),
          ),
          makeHeader(
            TabBar(
              tabs: tabs,
              controller: controller,
              onTap: onTap,
            ),
          ),
          SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final e = articles[index];
              return article(
                articleInfo: e,
                loading: loading,
              );
            },
          ),
          if (isLoading)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            )
        ]));
  }

  Widget article({required ArticleInfo articleInfo, required bool loading}) {
    final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(1),
      child: GestureDetector(
        onTap: () => browser.openUrlRequest(
            urlRequest: URLRequest(url: Uri.parse(articleInfo.url)),
            options: options),
        child: Card(
          clipBehavior: Clip.antiAlias,
          color: color.background,
          child: (loading)
              ? const SizedBox(
                  height: 120,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ))
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      FadeInImage(
                        image: NetworkImage(articleInfo.imageUrl),
                        placeholder: const AssetImage("assets/loading4.gif"),
                        height: 105,
                        // width: (size.width * 2) - 10 ,
                        placeholderFit: BoxFit.cover,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.black54,
                        ),
                        padding: const EdgeInsets.all(3.0),
                        margin: const EdgeInsets.all(3.0),
                        child: Text(
                          articleInfo.category,
                          style: textStyle.labelSmall
                              ?.copyWith(color: color.primary),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      articleInfo.description,
                      maxLines: 3,
                      style: textStyle.labelMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
