import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kimoi/src/UI/components/about_dialog.dart';
import 'package:kimoi/src/UI/services/webview/webview.dart';

import '../../../infrastructure/infrastructure.dart';
import '../../components/items.dart';
import '../../providers/providers.dart';
import '../screens.dart';

class HomeNews extends StatefulHookConsumerWidget {
  static const String name = 'Home-screen';

  const HomeNews({super.key});

  @override
  HomeNewsState createState() => HomeNewsState();
}

class HomeNewsState extends ConsumerState<HomeNews>
    {
  List<ArticleInfo> articles = [];

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
    ref.read(popularNewsProvider.notifier).getNews();
    ref.read(recentNewsProvider.notifier).getNews();
  }

  void listen(ScrollController scrollController) {
    if ((scrollController.position.pixels + 300) >=
        scrollController.position.maxScrollExtent) {
      // add5();
      fetchData(scrollController);
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

  Future fetchData(ScrollController scrollController) async {
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
    final scrollController = useScrollController();
    
    final controller = useTabController(initialLength: tabs.length);


    scrollController.addListener(() => listen(scrollController));

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
          SliverAppBar(
            title: const Text('Noticias'),
            actions: [
              IconButton(
                  onPressed: () => showGeneralDialog(
                        context: context,
                        pageBuilder: (context, __, ___) =>
                            const CsAboutDialog(),
                      ),
                  icon: const Icon(Icons.info)),
            ],
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
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(1)),
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
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(articleInfo.imageUrl),
                                fit: BoxFit.cover
                                // placeholder: const AssetImage("assets/loading4.gif"),
                                )),
                        height: 105,
                        // width: (size.width * 2) - 10 ,
                        // placeholderFit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: color.primary,
                        ),
                        padding: const EdgeInsets.all(3.0),
                        margin: const EdgeInsets.all(3.0),
                        child: Text(
                          articleInfo.category,
                          style: textStyle.labelSmall
                              ?.copyWith(color: color.onPrimary),
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
}
