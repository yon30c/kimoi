

import 'package:kimoi/src/infrastructure/models/article_info.dart';

abstract class NewsRepository {
  Future<List<ArticleInfo>> getPopularNews(int page);
  Future<List<ArticleInfo>> getRecentNews(int page);
  Future<List<ArticleInfo>> getAnimeNews(int page);
  Future<List<ArticleInfo>> getMangaNews(int page);
  Future<List<ArticleInfo>> getJaponNews(int page);
}