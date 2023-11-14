import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kimoi/src/UI/components/anime_card.dart';
import 'package:kimoi/src/UI/components/placeholders.dart';
import 'package:kimoi/src/UI/providers/animes/anime_filter_provider.dart';
import 'package:kimoi/src/UI/screens/home/home.dart';
import 'package:shimmer/shimmer.dart';

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
                  return AnimePlaceholder(width: widget.width, height: widget.height,);
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
                  return AnimeCard(
                    anime: widget.animes[index],
                    width: widget.width,
                    height: widget.height,
                  );
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

class AnimePlaceholder extends StatelessWidget {
  const AnimePlaceholder({
    super.key,
    required this.width,
    required this.height,
  });

  final double? width;
  final double? height;


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade900,
        highlightColor: Colors.grey.shade400,
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Esto es la imagen
            BannerPlaceholder(width: width ?? 130, height: height ?? 180,),
    
            const SizedBox(
              height: 5,
            ),
    
            //* Este es el titulo
    
            TitlePlaceholder(width: width ?? 130),
    
            const SizedBox(
              height: 5,
            ),
    
          ],
        ),
      ),
    );
  }
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
