import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kimoi/src/UI/items/anime_poster_link.dart';

import '../../domain/domain.dart';

class AnimeMasonry extends StatefulWidget {
  final List<Anime> animes;
  final VoidCallback? loadNextPage;

  const AnimeMasonry({super.key, required this.animes, this.loadNextPage});

  @override
  State<AnimeMasonry> createState() => _AnimeMasonryState();
}

class _AnimeMasonryState extends State<AnimeMasonry> with AutomaticKeepAliveClientMixin {
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
                AnimePosterLink(anime: widget.animes[index])
              ],
            );
          }

          return AnimePosterLink(anime: widget.animes[index]);
        },
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
