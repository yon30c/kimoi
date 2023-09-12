
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/anime.dart';

class AnimeItem extends StatelessWidget {
  final Anime anime;
  final void Function()? onAnimeSelected;

  const AnimeItem({super.key, required this.anime, required this.onAnimeSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final color = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap:onAnimeSelected,
      child: FadeIn(
        child:Card(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                // Image
                SizedBox(
                  width: size.width * 0.15,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: FadeInImage(
                        height: size.height * 0.11,
                        fit: BoxFit.cover,
                        image: NetworkImage(anime.imageUrl),
                        placeholder: const AssetImage('assets/jar-loading.gif'),
                      )),
                ),
                  
                const SizedBox(width: 10),
                  
                // Description
                SizedBox(
                  width: size.width * 0.32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(anime.animeTitle, style: textStyles.titleSmall, maxLines: 3, overflow: TextOverflow.ellipsis,),
                      Text(anime.chapterInfo!, style: textStyles.labelMedium?.copyWith(color: color.primary)),
                      const SizedBox(height: 5),
                     
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
