
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class AnimeMasonryState extends ConsumerState<AnimeMasonry>
    with AutomaticKeepAliveClientMixin {
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
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 7,
          mainAxisExtent: 240,
          crossAxisSpacing: 2,
        ),
        itemCount: widget.animes.length,
        itemBuilder: (context, index) {
          return animePosterLink(anime: widget.animes[index]);
        },
      ),
    );
  }

  Widget animePosterLink({required Anime anime}) {

    final textStyle = Theme.of(context).textTheme;

    return GestureDetector(
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
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(2)),
        
        child: Column(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
              image: DecorationImage(
                image: 
               NetworkImage(anime.imageUrl),
              fit: BoxFit.cover,
              )
                
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                anime.animeTitle,
                style: textStyle.labelMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
