
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/anime.dart';

class AnimeItem extends StatelessWidget {
  final Anime anime;
  // final void Function()? onAnimeSelected;

  const AnimeItem({super.key, required this.anime,/*  required this.onAnimeSelected */});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final color = Theme.of(context).colorScheme;

    return GestureDetector(
      // onTap:onAnimeSelected,
      child: FadeIn(
        child:Card(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Container(
            height: size.height * 0.196,
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                // Image
                Stack(
                  children: [
                    SizedBox(
                      width: size.width * 0.42,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: FadeInImage(
                            height: size.height * 0.11,
                            fit: BoxFit.cover,
                            image: NetworkImage(anime.imageUrl),
                            placeholder: const AssetImage('assets/jar-loading.gif'),
                          )),
                      
                    ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5)),

                          color: color.primaryContainer,
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Text(anime.type!, style: textStyles.labelMedium?.copyWith(color: color.onPrimaryContainer)))),
                  ],
                ),
                  
                const SizedBox(height: 5),
                  
                // Description
                SizedBox(
                  height: size.height * 0.07,
                  width: size.width * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(anime.animeTitle, style: textStyles.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis,),                     
                      Text(anime.chapterInfo!, style: textStyles.labelMedium?.copyWith(color: color.primary)),
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
