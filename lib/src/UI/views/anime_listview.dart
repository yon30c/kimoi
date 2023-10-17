import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kimoi/src/UI/items/anime_card.dart';
import 'package:kimoi/src/UI/providers/animes/anime_filter_provider.dart';
import 'package:kimoi/src/UI/screens/home/home.dart';

import '../../domain/entities/anime.dart';

class AnimesListview extends StatefulHookConsumerWidget {
  final String? subtitle;
  final String? title;
  final List<Anime> animes;
  final VoidCallback? loadNextPage;
  final GenresTab? genre;

  final double? height;
  final double? width;

  const AnimesListview(
      {super.key,
      this.title,
      this.genre,
      required this.animes,
      this.subtitle,
      this.height,
      this.width,
      this.loadNextPage});

  @override
  AnimesListviewState createState() => AnimesListviewState();
}

class AnimesListviewState extends ConsumerState<AnimesListview>
    with AutomaticKeepAliveClientMixin {
  final ScrollController scrollController = ScrollController();

  List optional = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: 320,
      child: Column(
        children: [
          if (widget.title != null || widget.subtitle != null)
            _Title(
              genre: widget.genre,
              title: widget.title,
              subtitle: widget.subtitle,
            ),
          const SizedBox(
            height: 5,
          ),
          if (widget.animes.isEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: optional.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return FadeInRight(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      child: Container(
                        height: 250,
                        width: 130,
                      ),
                    ),
                  );
                },
              ),
            ),
          if (widget.animes.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                controller: scrollController,
                itemCount: widget.animes.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return FadeInRight(
                      child: AnimeCard(
                    anime: widget.animes[index],
                    width: widget.width,
                    height: widget.height,
                  ));
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _Title extends ConsumerWidget {
  final String? title;
  final String? subtitle;
  final GenresTab? genre;
  const _Title({this.title, this.subtitle, this.genre});

  @override
  Widget build(BuildContext context, ref) {
    final textStyle = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 8),
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          if (title != null)
            Text(
              title!,
              style: textStyle.titleLarge,
            ),
          const Spacer(),
          if (subtitle != null)
            FilledButton.tonal(
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                onPressed: () {
                  if (genre != null) {
                    ref.read(genreProvider.notifier).update((state) => genre);
                    ref
                        .read(generoProvider.notifier)
                        .update((state) => genre!.id);
                    context.push('/explorar/genre-screen/${genre!.title}');
                  }
                },
                child: Text(subtitle!))
        ],
      ),
    );
  }
}
