import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/providers/providers.dart';
import 'package:kimoi/src/UI/providers/storage/watching_provider.dart';
import 'package:kimoi/src/domain/domain.dart';

class AnimeCard extends ConsumerWidget {
  final Anime anime;
  const AnimeCard(
      {super.key,
      required this.anime,
      this.height = 230,
      this.width = 150});

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context, ref) {
    final textStyle = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
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
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(1)),
        clipBehavior: Clip.antiAlias,
        // margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Esto es la imagen
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                      anime.imageUrl,
                    ),
                    fit: BoxFit.cover),

              ),
            ),

            const SizedBox(
              height: 5,
            ),

            //* Este es el titulo

            Container(
                padding: const EdgeInsets.symmetric( vertical:2, horizontal: 5),
                height: 43,
                width: width ?? 150,
                child: Text(
                  anime.animeTitle,
                  maxLines: 2,
                  style: textStyle.labelLarge,
                  overflow: TextOverflow.ellipsis,
                )),

            const SizedBox(
              height: 5,
            ),

            //* Rating

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                '${anime.type} • ${anime.release}',
                style: textStyle.labelMedium?.copyWith(color: color.primary),
              ),
            )
          ],
        ),
      ),
    );
  }
}
