

import 'package:kimoi/src/infrastructure/infrastructure.dart';
import 'package:kimoi/src/infrastructure/models/jikan_recommendations.dart' as jr;
import 'package:kimoi/src/infrastructure/models/jikan_upcoming.dart';

abstract class JikanRepository {
  Future<jr.JikanRecomendations> getRecommendations(int page);
  Future<JikanUpcoming> getSeasonUpcoming(int page);
  Future<JikanResponse> getTopAnime(int page);
  Future<Datum> getRandomAnime();
}
