


import 'package:kimoi/src/domain/domain.dart';

abstract class LocalStorageRepository {
  Future<void> toggleFavorite(Anime anime);

  Future<bool> isAnimeFavorite(String title);

  Future<List<Anime>> loadAnimes({int limit = 10, offset = 0});
  Future<void> onWatching(Chapter chapter);
  Future<Chapter?> loadWatchingAnime(String id);


  Future<Chapter?> loadLastWatchedChapterAnime(String title);
  Future<List<Chapter>> loadWatchedHistory({int limit = 10, offset = 0});
  Future<void> removeWatchetChapter( Chapter chapter );


  Future<void> clearHistory();
  
}