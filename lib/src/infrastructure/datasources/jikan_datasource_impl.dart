import 'package:http/http.dart';
import 'package:kimoi/src/domain/datasources/jikan_datasource.dart';
import 'package:kimoi/src/infrastructure/models/jikan_recommendations.dart' as jr;
import 'package:kimoi/src/infrastructure/models/jikan_response.dart';
import 'package:kimoi/src/infrastructure/models/jikan_upcoming.dart';

class JikanDatasourceImpl extends JikanDatasource {
  final client = Client();

  @override
  Future<Datum> getRandomAnime() async {
    final res =
        await client.get(Uri.parse('https://api.jikan.moe/v4/random/anime'));

    return Datum.fromRawJson(res.body);
  }

  @override
  Future<jr.JikanRecomendations> getRecommendations(int page) async {
    final res = await client
        .get(Uri.parse('https://api.jikan.moe/v4/recommendations/anime'));
    return jr.JikanRecomendations.fromRawJson(res.body);
  }

  @override
  Future<JikanUpcoming> getSeasonUpcoming(int page) async {
    final res = await client
        .get(Uri.parse('https://api.jikan.moe/v4/seasons/upcoming?page=$page'));
    return JikanUpcoming.fromRawJson(res.body);
  }

  @override
  Future<JikanResponse> getTopAnime(int page) async {
    final res =
        await client.get(Uri.parse('https://api.jikan.moe/v4/top/anime'));
    return JikanResponse.fromRawJson(res.body);
  }
}
