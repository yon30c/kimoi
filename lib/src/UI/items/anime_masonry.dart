import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/providers/animes/anime_info_provider.dart';
import 'package:kimoi/src/UI/providers/storage/watching_provider.dart';

import '../../domain/domain.dart';

class AnimeMasonry extends ConsumerStatefulWidget {
  final List<Anime> animes;
  final VoidCallback? loadNextPage;

  const AnimeMasonry({super.key, required this.animes, this.loadNextPage});

  @override
  AnimeMasonryState createState() => AnimeMasonryState();
}

class AnimeMasonryState extends ConsumerState<AnimeMasonry> with AutomaticKeepAliveClientMixin {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 100) >=
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: MasonryGridView.count(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        crossAxisCount: 3,
        mainAxisSpacing: 7,
        crossAxisSpacing: 2,
        itemCount: widget.animes.length,
        itemBuilder: (context, index) {
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(height: 20),
                animePosterLink(anime: widget.animes[index])
              ],
            );
          }

          return animePosterLink(anime: widget.animes[index]);
        },
      ),
    );
  }
    animePosterLink({required Anime anime}) {
       final random = Random();

    final textStyle = Theme.of(context).textTheme;

    return FadeInUp(
      from: random.nextInt(100) + 80,
      delay: Duration(milliseconds: random.nextInt(450) + 0),
      child: GestureDetector(
        onTap: () async {
          ref.read(animeProvider.notifier).update((state) => anime);

          await ref
              .read(isWatchingAnimeProvider.notifier)
              .loadLastWatchingChapter(anime.animeTitle)
              .then((value) {
            ref.read(lastChapterWProvider.notifier).update((state) => value);
            context.push('/anime-screen');
          });
        },
        child: Card(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: FadeInImage(
                  height: 180,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage(anime.imageUrl),
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.all(5), 
                child: Text(anime.animeTitle, style: textStyle.labelMedium, maxLines: 2, overflow: TextOverflow.ellipsis,),)
            ],
          ),
        ),
      ),
    );
    }
  
  @override
  bool get wantKeepAlive => true;
}
