import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/anime.dart';
import '../../utils/methods/show_bottom_sheet.dart';
import '../items/anime_item.dart';

class AnimesView extends StatefulWidget {
  const AnimesView({super.key, required this.animes, required this.title});

  final List<Anime> animes;
  final String title;

   @override
  State<AnimesView> createState() {
    return AnimesViewState();
  }
}

class AnimesViewState extends State<AnimesView> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    List<List<Anime>> subList = [];

    int h = 0;
    int j = 4;
    for (var i = 0; j <= widget.animes.length; i++) {
      final list = widget.animes.sublist(h, j);

      subList.add(list);

      h = h + 4;
      j = j + 4;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: FilledButton(
            onPressed: null,
            child: Text(
              widget.title,
              style: textStyle.titleMedium,
            ),
          ),
        ),
        SizedBox(
          width: size.width,
          height: size.height * 0.505,
          child: _Swiper(subList: subList),
        ),
      ],
    );
  }
  
  @override
  bool get wantKeepAlive => true;
  
 
}

class _Swiper extends StatelessWidget {
  const _Swiper({
    required this.subList,
  });

  final List<List<Anime>> subList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      scrollDirection: Axis.horizontal,
      itemCount: subList.length,
      itemBuilder: (BuildContext context, int index) {
        final animeList = subList[index];
        return _SwiperView(animeList: animeList);
      },
    );
  }
}

class _SwiperView extends ConsumerWidget {
  const _SwiperView({
    required this.animeList,
  });

  final List<Anime> animeList;

  @override
  Widget build(BuildContext context, ref) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...animeList
            .map(
              (anime) => AnimeItem(
                anime: anime, onAnimeSelected: 
                     () => showButtonSheet(context,
                        anime: anime, ref: ref),
              ),
            )
            .toList()
      ],
    );
  }
}
