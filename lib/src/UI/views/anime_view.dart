import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rv;
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/items/servers_dialog.dart';
import 'package:kimoi/src/UI/providers/animes/anime_info_provider.dart';
import 'package:kimoi/src/UI/providers/storage/watching_provider.dart';

import '../../domain/entities/anime.dart';
import '../items/anime_item.dart';

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
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          child: FilledButton(
            onPressed: null,
            child: Text(
              widget.title,
              style: textStyle.titleMedium,
            ),
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
                        showDialog(
                            context: context,
                            builder: (context) => ServerDialog(anime));
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
                child: AnimeItem(
                  anime: anime,
                ),
              ),
            )
            .toList()
      ],
    );
  }
}
