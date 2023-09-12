import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kimoi/src/infrastructure/models/article_info.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../services/webview/webview.dart';

class NewsSlideshow extends StatelessWidget {
  final List<ArticleInfo> articles;
  const NewsSlideshow({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SizedBox(
      height: 210,
      width: double.infinity,
      child: Swiper(
        pagination: SwiperPagination(
            margin: const EdgeInsets.only(top: 0),
            builder: DotSwiperPaginationBuilder(
              activeColor: color.primary,
              color: color.secondary,
            )),
        viewportFraction: 0.8,
        itemCount: articles.length,
        scale: 0.9,
        autoplay: true,
        autoplayDelay: 5000,
        itemBuilder: (context, index) {
          final article = articles[index];

          return GestureDetector(
              onTap: () {
                browser.openUrlRequest(
                    urlRequest: URLRequest(url: Uri.parse(article.url)),
                    options: options);
              },
              child: _Slide(article: article));
        },
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final ArticleInfo article;

  const _Slide({required this.article});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Colors.black45, blurRadius: 10, offset: Offset(0, 10))
        ]);

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _NetworkImage(article: article),
                const _ShadowBox(),
                _Description(article: article),
                _Buttons(article: article)
              ],
            )),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({
    required this.article,
  });

  final ArticleInfo article;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Positioned(
      right: 0,
      top: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton.filled(
                style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    backgroundColor:
                        MaterialStatePropertyAll(color.onPrimaryContainer)),
                onPressed: () {
                  browser.openUrlRequest(
                      urlRequest: URLRequest(url: Uri.parse(article.url)),
                      options: options);
                },
                icon: const Icon(
                  Symbols.remove_red_eye_sharp,
                )),
            IconButton.filled(
                style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    backgroundColor:
                        MaterialStatePropertyAll(color.onPrimaryContainer)),
                onPressed: () {},
                icon: const Icon(Symbols.share))
          ],
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({
    required this.article,
  });

  final ArticleInfo article;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Text(
        article.description,
        style: textStyle.titleMedium?.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _ShadowBox extends StatelessWidget {
  const _ShadowBox();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  stops: [
            0.0,
            0.4
          ],
                  colors: [
            Colors.transparent,
            Colors.black38,
          ]))),
    );
  }
}

class _NetworkImage extends StatelessWidget {
  const _NetworkImage({
    required this.article,
  });

  final ArticleInfo article;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      article.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress != null) {
          return const DecoratedBox(
            decoration: BoxDecoration(color: Colors.black12),
          );
        }
        return FadeIn(child: child);
      },
    );
  }
}
