import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rv;
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/items/servers_dialog.dart';
import 'package:kimoi/src/UI/providers/animes/anime_info_provider.dart';
import 'package:kimoi/src/UI/providers/storage/watching_provider.dart';
import 'package:kimoi/src/domain/domain.dart';

class AnimesView extends StatefulWidget {
  const AnimesView({super.key, required this.animes, required this.title});

  final List<Anime> animes;
  final String title;

  @override
  State<AnimesView> createState() {
    return AnimesViewState();
  }
}

class AnimesViewState extends State<AnimesView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final color = Theme.of(context).colorScheme;

    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    List<List<Anime>> subList = [];

    int h = 0;
    int j = 3;
    for (var i = 0; j <= widget.animes.length; i++) {
      final list = widget.animes.sublist(h, j);

      subList.add(list);

      h = h + 3;
      j = j + 3;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.only( top: 15, bottom: 3),
          child: Column(
            children: [
              // Divider(),

              Text(
                widget.title,
                style: textStyle.titleLarge,
              ),
              const Divider()
            ],
          ),
        ),
        SizedBox(
          width: size.width,
          height: size.height * 0.62,
          child: _Swiper(subList: subList),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _Swiper extends StatelessWidget {
  const _Swiper({
    required this.subList,
  });

  final List<List<Anime>> subList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      addAutomaticKeepAlives: true,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      scrollDirection: Axis.horizontal,
      itemCount: subList.length,
      itemBuilder: (BuildContext context, int index) {
        final animeList = subList[index];
        return _SwiperView(animeList: animeList);
      },
    );
  }
}

class _SwiperView extends rv.ConsumerWidget {
  const _SwiperView({
    required this.animeList,
  });

  final List<Anime> animeList;

  @override
  Widget build(BuildContext context, ref) {
    final color = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...animeList
            .map(
              (anime) => PopupMenuButton(
                color: color.surfaceVariant,
                position: PopupMenuPosition.under,
                itemBuilder: (context) {
                  return <PopupMenuEntry>[
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.remove_red_eye),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Ver ahora'),
                        ],
                      ),
                      onTap: () {
                        final chapt = Chapter(
                            title: '',
                            id: '',
                            chapterUrl: '',
                            chapterNumber: 0,
                            servers: [],
                            chapterInfo: '',
                            chapter: '');

                        showDialog(
                            context: context,
                            builder: (context) => ServerDialog(anime, chapt));
                      },
                    ),
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.info),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Informacion'),
                        ],
                      ),
                      onTap: () async {
                        ref
                            .read(animeProvider.notifier)
                            .update((state) => anime);

                        await ref
                            .read(isWatchingAnimeProvider.notifier)
                            .loadLastWatchingChapter(anime.animeTitle)
                            .then((value) {
                          ref
                              .read(lastChapterWProvider.notifier)
                              .update((state) => value);
                          context.push('/anime-screen');
                        });
                      },
                    ),
                  ];
                },
                child: animeItem(
                    anime: anime,
                    size: size,
                    textStyles: textStyle,
                    color: color),
              ),
            )
            .toList()
      ],
    );
  }

  Widget animeItem(
      {required Anime anime,
      required Size size,
      required TextTheme textStyles,
      required ColorScheme color}) {
    return GestureDetector(
      // onTap:onAnimeSelected,
      child: FadeIn(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          child: Container(
            height: size.height * 0.196,
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                // Image
                Stack(
                  children: [
                    SizedBox(
                      width: size.width * 0.42,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: FadeInImage(
                            height: size.height * 0.11,
                            fit: BoxFit.cover,
                            image: NetworkImage(anime.imageUrl),
                            placeholder:
                                const AssetImage('assets/jar-loading.gif'),
                          )),
                    ),
                    Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              color: color.primaryContainer,
                            ),
                            padding: const EdgeInsets.all(3),
                            child: Text(anime.type!,
                                style: textStyles.labelMedium?.copyWith(
                                    color: color.onPrimaryContainer)))),
                  ],
                ),

                const SizedBox(height: 5),

                // Description
                SizedBox(
                  height: size.height * 0.07,
                  width: size.width * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        anime.animeTitle,
                        style: textStyles.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(anime.chapterInfo!,
                          style: textStyles.labelMedium
                              ?.copyWith(color: color.primary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
