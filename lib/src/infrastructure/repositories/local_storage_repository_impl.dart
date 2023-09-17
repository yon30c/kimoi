import 'package:kimoi/src/domain/datasources/local_storage_datasource.dart';
import 'package:kimoi/src/domain/entities/anime.dart';
import 'package:kimoi/src/domain/entities/chapter.dart';
import 'package:kimoi/src/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource datasource;

  LocalStorageRepositoryImpl(this.datasource);

  @override
  Future<bool> isAnimeFavorite(String title) {
    return datasource.isAnimeFavorite(title);
  }

  @override
  Future<List<Anime>> loadAnimes({int limit = 10, offset = 0}) {
    return datasource.loadAnimes(limit: limit, offset: offset);
  }

  @override
  Future<void> toggleFavorite(Anime anime) {
    return datasource.toggleFavorite(anime);
  }

  @override
  Future<void> onWatching(Chapter chapter) {
    return datasource.onWatching(chapter);
  }

  @override
  Future<Chapter?> loadWatchingAnime(String id) {
    return datasource.loadWatchingAnime(id);
  }

  @override
  Future<Chapter?> loadLastWatchedChapterAnime(String title) {
    return datasource.loadLastWatchedChapterAnime(title);
  }

  @override
  Future<List<Chapter>> loadWatchedHistory({int limit = 10, offset = 0}) {
    return datasource.loadWatchedHistory(limit: limit, offset: offset);
  }

  @override
  Future<void> clearHistory() {
    return datasource.clearHistory();
  }
}
