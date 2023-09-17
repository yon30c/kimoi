import 'package:kimoi/src/infrastructure/models/extra_data.dart';

import '../domain.dart';

abstract class AnimeDatasource {
  Future<List<Anime>> getRecentAnime({int? year, int? page});
  Future<List<Anime>> getLastAnimeAdded({int? year, int? page});
  Future<AnimeInfo> getAnimeInfo(String path);
  Future<List<Chapter>> getChapterData(String path);
  Future<XData> getExtraData(Anime anime);

  Future<List<Anime>> getDirectory(
      {
      int? estado,
      int? p,
      String? tipo,
      String? genero,
      int? estreno,
      int? idioma,
      String? q});

  Future<List<Anime>> searchAnime(String query);

}
