import 'package:kimoi/src/domain/datasources/jikan_datasource.dart';
import 'package:kimoi/src/domain/repositories/jikan_repository.dart';
import 'package:kimoi/src/infrastructure/models/jikan_recommendations.dart' as jr;
import 'package:kimoi/src/infrastructure/models/jikan_response.dart';
import 'package:kimoi/src/infrastructure/models/jikan_upcoming.dart';

class JikanRepositoryImpl extends JikanRepository {
  final JikanDatasource datasource;

  JikanRepositoryImpl(this.datasource);

  @override
  Future<Datum> getRandomAnime() {
    return datasource.getRandomAnime();
  }

  @override
  Future<jr.JikanRecomendations> getRecommendations(int page) {
    return datasource.getRecommendations(page);
  }

  @override
  Future<JikanUpcoming> getSeasonUpcoming(int page) {
    return datasource.getSeasonUpcoming(page);
  }

  @override
  Future<JikanResponse> getTopAnime(int page) {
    return datasource.getTopAnime(page);
  }
}
