import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

class CsTile extends StatelessWidget {
  const CsTile({
    super.key,
    this.onTap,
    required this.anime,
  });

  final Anime anime;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: FadeIn(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                // Image
                SizedBox(
                  width: size.width * 0.15,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage(
                        height: 90,
                        fit: BoxFit.cover,
                        image: NetworkImage(anime.imageUrl),
                        placeholder: const AssetImage('assets/jar-loading.gif'),
                      )),
                ),
      
                const SizedBox(width: 10),
      
                // Description
                SizedBox(
                  width: size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(anime.animeTitle, style: textStyle.titleMedium),
                      Text(anime.chapterInfo!),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            '${anime.type} • ${anime.release} ',
                            style: textStyle.labelMedium!
                                .copyWith(color: color.primary),
                          ),
                        ],
                      )
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
