import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/providers/providers.dart';
import 'package:kimoi/src/UI/providers/storage/watching_provider.dart';
import 'package:kimoi/src/domain/entities/anime.dart';

class AnimePosterLink extends ConsumerWidget {
  final Anime anime;

  const AnimePosterLink({super.key, required this.anime});

  @override
  Widget build(BuildContext context, ref) {
    final random = Random();

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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage(
            height: 180,
            fit: BoxFit.cover,
            placeholder: const AssetImage('assets/jar-loading.gif'),
            image: NetworkImage(anime.imageUrl),
          ),
        ),
      ),
    );
  }
}
