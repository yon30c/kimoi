import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kimoi/src/UI/providers/animes/anime_info_provider.dart';
import 'package:kimoi/src/UI/providers/storage/watching_provider.dart';

import '../../domain/domain.dart';

// class AnimeMasonry extends StatefulHookConsumerWidget {

//   @override
//   AnimeMasonryState createState() => AnimeMasonryState();
// }

class AnimeMasonry extends HookConsumerWidget {
  final List<Anime> animes;
  final VoidCallback? loadNextPage;

  const AnimeMasonry({super.key, required this.animes, this.loadNextPage});

  @override
  Widget build(BuildContext context, ref) {
    useAutomaticKeepAlive();

    final scrollController = useScrollController();

    scrollController.addListener(() {
      if (loadNextPage == null) return;

      if ((scrollController.position.pixels + 100) >=
          scrollController.position.maxScrollExtent) {
        loadNextPage!();
      }
    });

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
        itemCount: animes.length,
        itemBuilder: (context, index) {
          return animePosterLink(
              anime: animes[index], context: context, ref: ref);
        },
      ),
    );
  }

  Widget animePosterLink(
      {required Anime anime,
      required BuildContext context,
      required WidgetRef ref}) {
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
                image: NetworkImage(anime.imageUrl),
                fit: BoxFit.cover,
              )),
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
}
