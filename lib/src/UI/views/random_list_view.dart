import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/items/servers_dialog.dart';
import 'package:kimoi/src/domain/domain.dart';

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
      height: size.height * 0.22,
      child: Swiper(
        viewportFraction: 0.999,
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
        image: DecorationImage(
            image: NetworkImage(widget.anime.imageUrl),
            fit: BoxFit.cover,
            opacity: 0.5,
            filterQuality: FilterQuality.high,
            colorFilter: const ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            )),
        boxShadow: const [
          BoxShadow(
              color: Colors.black38,
              blurRadius: 5.0,
              offset: Offset(0, 0),
              blurStyle: BlurStyle.solid)
        ]);

    final textStyle = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: decoration,
      child: _Background(
        anime: widget.anime,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FadeIn(
              child: Container(
                width: size.width * 0.35,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(
                    widget.anime.imageUrl,
                  ),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            Column(
              children: [
                Container(
                  width: size.width * 0.6,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                  width: size.width * 0.6,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Text(
                    ' ${widget.anime.type} • ${widget.anime.release}',
                    style:
                        textStyle.titleMedium?.copyWith(color: Colors.white70),
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 8,
                    ),
                    FilledButton.icon(
                        icon: const Icon(Icons.play_arrow_rounded),
                        onPressed: () async {
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
                              builder: (context) =>
                                  ServerDialog(widget.anime, chapt));
                        },
                        label: const Text('Ver ahora'),
                        style: const ButtonStyle(
                            visualDensity: VisualDensity.compact)),
                    const SizedBox(
                      width: 8,
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
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({required this.anime, required this.child});

  final Anime anime;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(anime.imageUrl), fit: BoxFit.cover)),
          child: _BlurBackgroundWidget(child: child),
        ),
        
      ],
    );
  }
}

class _BlurBackgroundWidget extends StatelessWidget {
  final Widget child;

  const _BlurBackgroundWidget({required this.child});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10), // Ajusta los valores de sigmaX y sigmaY según lo desees
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black38 // Ajusta el color y la opacidad del fondo borroso
              ),
              width: double.infinity,
              // height: size.height * 0.75,
            ),
          ),
        ),
        child
      ],
    );
  }
}
