
import '../../domain/domain.dart';
import '../infrastructure.dart';

class NewRepositoryImpl extends NewsRepository {
  final NewsDatasource datasource;

  NewRepositoryImpl(this.datasource);

  @override
  Future<List<ArticleInfo>> getAnimeNews(int page) {
    return datasource.getAnimeNews(page);
  }

  @override
  Future<List<ArticleInfo>> getJaponNews(int page) {
    return datasource.getJaponNews(page);
  }

  @override
  Future<List<ArticleInfo>> getMangaNews(int page) {
    return datasource.getMangaNews(page);
  }

  @override
  Future<List<ArticleInfo>> getPopularNews(int page) {
    return datasource.getPopularNews(page);
  }

  @override
  Future<List<ArticleInfo>> getRecentNews(int page) {
    return datasource.getRecentNews(page);
  }
}
