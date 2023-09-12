import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import '../../domain/domain.dart';
import '../infrastructure.dart';

class KudasaiNewsDatasource extends NewsDatasource {
  final dio = Dio(BaseOptions(baseUrl: 'https://somoskudasai.com/'));

  @override
  Future<List<ArticleInfo>> getAnimeNews(int page) async {
    final res = await dio.get('categoria/noticias/anime/page/$page');

    Document document = parse(res.data);

    final articles = document.querySelectorAll('article');

    List<ArticleInfo> articlesInfo = [];

    for (var article in articles) {
      final String category = article.querySelector('span')!.text;
      final String description = article.querySelector('h2')!.text;
      final String imageUrl = article.querySelector('img')!.attributes["src"]!;
      final String url = article.querySelector('a')!.attributes["href"]!;

      articlesInfo.add(ArticleInfo(
          category: category,
          imageUrl: imageUrl,
          url: url,
          description: description));
    }

    return articlesInfo;
  }

  @override
  Future<List<ArticleInfo>> getJaponNews(int page) async {
    final res = await dio.get('categoria/noticias/japon/page/$page');

    Document document = parse(res.data);

    final articles = document.querySelectorAll('article');

    List<ArticleInfo> articlesInfo = [];

    for (var article in articles) {
      final String category = article.querySelector('span')!.text;
      final String description = article.querySelector('h2')!.text;
      final String imageUrl = article.querySelector('img')!.attributes["src"]!;
      final String url = article.querySelector('a')!.attributes["href"]!;

      articlesInfo.add(ArticleInfo(
          category: category,
          imageUrl: imageUrl,
          url: url,
          description: description));
    }

    return articlesInfo;
  }

  @override
  Future<List<ArticleInfo>> getMangaNews(int page) async {
    final res = await dio.get('categoria/noticias/manga/page/$page');

    Document document = parse(res.data);

    final articles = document.querySelectorAll('article');

    List<ArticleInfo> articlesInfo = [];

    for (var article in articles) {
      final String category = article.querySelector('span')!.text;
      final String description = article.querySelector('h2')!.text;
      final String imageUrl = article.querySelector('img')!.attributes["src"]!;
      final String url = article.querySelector('a')!.attributes["href"]!;

      articlesInfo.add(ArticleInfo(
          category: category,
          imageUrl: imageUrl,
          url: url,
          description: description));
    }

    return articlesInfo;
  }

  @override
  Future<List<ArticleInfo>> getPopularNews(int page) async {
    final res = await dio.get('');

    Document document = parse(res.data);

    final articles = document
        .querySelector('.ar-featured')!
        .getElementsByClassName('swiper-slide');

    final popularNews = <ArticleInfo>[];

    for (var article in articles) {
      final String category = article.querySelector('span')!.text;
      final String description = article.querySelector('h2')!.text;
      final String imageUrl = article.querySelector('img')!.attributes["src"]!;
      final String url = article.querySelector('a')!.attributes["href"]!;

      popularNews.add(ArticleInfo(
          category: category,
          imageUrl: imageUrl,
          url: url,
          description: description));
    }

    return popularNews;
  }

  @override
  Future<List<ArticleInfo>> getRecentNews(int page) async {
    final res = await dio.get('noticias/page/$page');

    Document document = parse(res.data);

    final articles =
        document.querySelector('section')!.querySelectorAll('article');

    List<ArticleInfo> articlesInfo = [];

    for (var article in articles) {
      final String category = article.querySelector('span')!.text;
      final String description = article.querySelector('h2')!.text;
      final String imageUrl = article.querySelector('img')?.attributes["src"] ??
          'https://t4.ftcdn.net/jpg/04/70/29/97/360_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg';
      final String url = article.querySelector('a')!.attributes["href"]!;

      articlesInfo.add(ArticleInfo(
          category: category,
          imageUrl: imageUrl,
          url: url,
          description: description));
    }

    return articlesInfo;
  }
}
