



import 'package:kimoi/src/infrastructure/models/extra_data.dart';

import '../domain.dart';

abstract class AnimeRepository {
  Future<List<Anime>> getRecentAnime({int? year, int? page});
  Future<List<Anime>> getLastAnimeAdded({int? year, int? page});
  Future<AnimeInfo> getAnimeInfo(String path);
  Future<List<Chapter>> getChapterData(String path);
  Future<XData> getExtraData(Anime anime);


    Future<List<Anime>> getDirectory(
      {int? estado,
      int? tipo,
      int? p,
      int? genero,
      int? estreno,
      int? idioma,
      String? q});
  Future<List<Anime>> searchAnime(String query);

}
