import 'package:kimoi/src/infrastructure/models/extra_data.dart';

import '../../domain/domain.dart';

class AnimeRepositoryImpl extends AnimeRepository {
  final AnimeDatasource datasource;

  AnimeRepositoryImpl(this.datasource);

  @override
  Future<List<Anime>> getLastAnimeAdded({int? year, int? page}) {
    return datasource.getLastAnimeAdded(page: page, year: year);
  }

  @override
  Future<List<Anime>> getRecentAnime({int? year, int? page}) {
    return datasource.getRecentAnime(year: year, page: page);
  }

  @override
  Future<AnimeInfo> getAnimeInfo(String path) {
    return datasource.getAnimeInfo(path);
  }

  @override
  Future<List<Chapter>> getChapterData(String path) {
    return datasource.getChapterData(path);
  }

  @override
  Future<List<Anime>> getDirectory(
      {int? estado,
      int? p,
      String? tipo,
      String? genero,
      int? estreno,
      int? idioma,
      String? q}) async {
    return datasource.getDirectory(
        p: p,
        estado: estado,
        estreno: estreno,
        genero: genero,
        tipo: tipo,
        q: q,
        idioma: idioma);
  }

  @override
  Future<List<Anime>> searchAnime(String query) {
    return datasource.searchAnime(query);
  }

  @override
  Future<XData> getExtraData(Anime anime) {
    return datasource.getExtraData(anime);
  }
}
