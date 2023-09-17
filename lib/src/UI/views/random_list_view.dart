import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/items/servers_dialog.dart';
import 'package:kimoi/src/domain/entities/anime.dart';

import '../providers/providers.dart';

class RandomListView extends StatefulWidget {
  const RandomListView({super.key, required this.animes});

  final List<Anime> animes;

  @override
  State<RandomListView> createState() => _RandomListViewState();
}

class _RandomListViewState extends State<RandomListView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.20,
      child: Swiper(
        viewportFraction: 0.85,
        itemCount: widget.animes.length,
        scale: 0.9,
        autoplay: true,
        autoplayDelay: 7000,
        itemBuilder: (context, index) {
          final anime = widget.animes[index];

          return RandomSlide(anime: anime);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class RandomSlide extends ConsumerStatefulWidget {
  const RandomSlide({super.key, required this.anime});

  final Anime anime;

  @override
  RandomSlideState createState() => RandomSlideState();
}

class RandomSlideState extends ConsumerState<RandomSlide> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            image: NetworkImage(widget.anime.imageUrl),
            fit: BoxFit.cover,
            opacity: 0.4,
            colorFilter:
                const ColorFilter.mode(Colors.black54, BlendMode.color)),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, 10))
        ]);

    final textStyle = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: decoration,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                widget.anime.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const DecoratedBox(
                      decoration: BoxDecoration(color: Colors.black12),
                    );
                  }
                  return FadeIn(child: child);
                },
              ),
              Column(
                children: [
                  Container(
                    width: size.width * 0.48,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Text(
                      widget.anime.animeTitle,
                      style: widget.anime.animeTitle.length < 20
                          ? textStyle.titleLarge?.copyWith(color: Colors.white)
                          : textStyle.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: size.width * 0.45,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Text(
                      ' ${widget.anime.type} • ${widget.anime.release}',
                      style:
                          textStyle.titleMedium?.copyWith(color: Colors.white),
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      FilledButton.icon(
                          icon: const Icon(Icons.play_arrow_rounded),
                          onPressed: () async {
                           showDialog(
                            context: context,
                            builder: (context) => ServerDialog(widget.anime));
                          },
                          label: const Text('Ver ahora'),
                          style: const ButtonStyle(
                              visualDensity: VisualDensity.compact)),
                      const SizedBox(
                        width: 5,
                      ),
                      IconButton.filled(
                        icon: const Icon(Icons.info),
                        onPressed: () {
                          ref
                              .read(animeProvider.notifier)
                              .update((state) => widget.anime);
                          context.push(
                            '/anime-screen',
                          );
                        },
                        style: const ButtonStyle(
                            visualDensity: VisualDensity.compact),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  )
                ],
              ),
            ],
          )),
    );
  }
}
