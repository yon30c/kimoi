import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:kimoi/src/infrastructure/models/extra_data.dart';
import 'package:kimoi/src/infrastructure/models/jikan_response.dart';

import '../../domain/domain.dart';

class AnimeMacDatasource extends AnimeDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://animemac.net/',
  ))
    ..httpClientAdapter;

  @override
  Future<List<Anime>> getLastAnimeAdded({int? year, int? page}) async {
    final res = await dio
        .get('directorio/', queryParameters: {'estreno': year, 'p': page});

    List<Anime> animes = [];

    final Document document = parse(res.data);

    final result =
        document.querySelector('.animes-container')!.querySelectorAll('li');

    for (var element in result) {
      final animeTitle = element.querySelectorAll('p').last.text;
      final animeUrl = element.querySelector('a')!.attributes['href']!;
      final imageUrl =
          'https://animemac.net${element.querySelectorAll('img').last.attributes['src']}';
      final type = element.querySelector('.tipo')!.text;
      final release = element.querySelector('.estreno')!.text;
      final tmp = animeUrl.replaceFirst('anime', 'ver');
      final chapterUrl = '$tmp-1';

      animes.add(Anime(
          chapterUrl: chapterUrl,
          animeTitle: animeTitle,
          animeUrl: animeUrl,
          imageUrl: imageUrl,
          chapterInfo: null,
          type: type,
          release: release));
    }

    return animes;
  }

  @override
  Future<List<Anime>> getRecentAnime({int? year, int? page}) async {
    final res = await dio.get('ultimos-episodios/');

    List<Anime> animes = [];

    final Document document = parse(res.data);

    final result = document.querySelector('section')!.querySelectorAll('li');

    for (var element in result) {
      final animeTitle = element.querySelectorAll('p').last.text;
      final chapterUrl = element.querySelector('a')!.attributes['href']!;
      final animeUrl =
          'anime/${element.querySelector('a')!.attributes['href']!.split('/').last.split('-').allExceptLast.join('-')}';
      final chapterInfo = element.querySelector('p')!.text.trim();
      final imageUrl =
          'https://animemac.net${element.querySelectorAll('img').last.attributes['src']}';

      animes.add(Anime(
          animeTitle: animeTitle,
          animeUrl: animeUrl,
          imageUrl: imageUrl,
          chapterInfo: chapterInfo,
          chapterUrl: chapterUrl));
    }

    return animes;
  }

  Future<List<Anime>> getPopularAnime() async {
    final res = await dio.get('');

    List<Anime> animes = [];

    final Document document = parse(res.data);

    final result = document.getElementsByClassName('card2');

    for (var element in result) {
      final animeTitle =
          element.querySelector('.anime-title')!.querySelector('h2')!.text;
      final chapterUrl =
          element.querySelectorAll('a').first.attributes['href']!;
      final animeUrl = element.querySelectorAll('a').last.attributes['href']!;
      final chapterInfo = element.querySelector('p')!.text.trim();
      final imageUrl =
          'https://animemac.net${element.querySelectorAll('img').last.attributes['src']}';

      // https://monoschinos2.com/anime/itai-no-wa-iya-nano-de-bougyoryoku-ni-kyokufuri-shitai-to-omoimasu-sub-espanol
      // https://monoschinos2.com/anime/itai-no-wa-iya-nano-de-bougyoryoku-ni-kyokufuri-shitai-a-omoimasu-sub-espanol

      final type = element.querySelector('.meta')!.querySelectorAll('span').first.text;
      final release = element.querySelector('.meta')!.querySelectorAll('span').last.text;

      animes.add(Anime(
        type: type,
        release: release,
          animeTitle: animeTitle,
          animeUrl: animeUrl,
          imageUrl: imageUrl,
          chapterInfo: chapterInfo,
          chapterUrl: chapterUrl));
    }

    return animes;
  }

  @override
  Future<AnimeInfo> getAnimeInfo(String path) async {
    final response = await dio.get(path);

    final Document document = parse(response.data);

    final animeTitle =
        document.querySelector('.titles')!.querySelector('h1')!.text;
    String? description = document.getElementById('sinopsis')?.text;
    final imageUrl = document.getElementById('anime_image')!.attributes['src']!;

    final eps = document.getElementById('eps')!.querySelectorAll('li');
    final gnrsWrap = document.querySelector('.generos-wrap');

    List<Element> gnrs = [];

    if (gnrsWrap != null) {
      gnrs = gnrsWrap.getElementsByClassName('item br');
    }

    final bannerInfo =
        document.querySelector('.banner-img')!.querySelectorAll('span');
    String estado = bannerInfo.first.text;

    final idioma = document.getElementsByClassName("idioma").first.text.trim();

    List<Chapter> episodes = [];
    List<String> genres = [];
    List<Anime> related = [];

    final element = document.getElementById('show-data');

    final tipo = element!.getElementsByClassName('item')[1].text;
    final estreno = element.getElementsByClassName('item')[2].text;
    final episodios = element.getElementsByClassName('item')[3].text;

    for (var episode in eps) {
      final title = episode.querySelector('p')!.text;
      final url = episode.querySelector('a')!.attributes['href']!;
      final date = episode.querySelectorAll('p').last.text;

      final number = url.split('-').last;

      final id = '$animeTitle/$number/$url';

      // final number = int.tryParse(title.split(' ').last);

      episodes.add(Chapter(
          chapter: title,
          servers: [],
          id: id,
          imageUrl: imageUrl,
          title: animeTitle,
          chapterUrl: url,
          chapterInfo: date,
          chapterNumber: int.parse(number)));
    }

    for (var genre in gnrs) {
      genres.add(genre.text);
    }

    final animesRight =
        document.getElementById('animes-right-side')!.querySelectorAll('a');

    for (var element in animesRight) {
      final relateTitle = element.querySelector('h3')!.text;
      final animeUrl = element.attributes['href']!;
      final imageUrl =
          'https://animemac.net${element.querySelector('img')!.attributes['src']!}';
      final type = element.querySelectorAll('span').first.text;
      final release = element.querySelectorAll('span').last.text;
      final tmp = animeUrl.replaceFirst('anime', 'ver');
      final chapterUrl = '$tmp-1';

      related.add(Anime(
          chapterInfo: release,
          animeTitle: relateTitle,
          animeUrl: animeUrl,
          imageUrl: imageUrl,
          chapterUrl: chapterUrl,
          type: type,
          release: release));
    }

    List<List<Chapter>> subList = [];

    if (episodes.length < 500) {
      final mod = episodes.length % 50;
      int h = 0;
      int j = 50;
      for (var i = 0; j <= episodes.length; i++) {
        final list = episodes.reversed.toList().sublist(h, j);
        subList.add(list);
        h = h + 50;
        j = j + 50;
      }
      subList.add(episodes.reversed.toList().sublist(h, (h + mod)));
    } else if (episodes.length >= 500) {
      final mod = episodes.length % 100;
      int h = 0;
      int j = 100;
      for (var i = 0; j <= episodes.length; i++) {
        final list = episodes.reversed.toList().sublist(h, j);
        subList.add(list);
        h = h + 100;
        j = j + 100;
      }
      subList.add(episodes.reversed.toList().sublist(h, (h + mod)));
    }

    final AnimeInfo animeInfo = AnimeInfo(
        related: related,
        idioma: idioma,
        estado: estado,
        estreno: estreno,
        episodios: episodios,
        tipo: tipo,
        title: animeTitle,
        episodes: subList,
        description: description,
        imageUrl: imageUrl,
        genres: genres);

    return animeInfo;
  }

  @override
  Future<XData> getExtraData(Anime anime, String title) async {
    try {
      final title = anime.animeTitle;
      final lastUrl = 'https://api.jikan.moe/v4/anime?q=$title&limit=20';

      final jikRes = await Dio().get(lastUrl);
      final jikan = JikanResponse.fromJson(jikRes.data);

      String? studios;

      final rating = jikan.data.first.rating;
      final popularity = jikan.data.first.popularity;
      final rank = jikan.data.first.rank;
      String? season = jikan.data.first.season;
      if (jikan.data.first.studios.isNotEmpty) {
        studios = jikan.data.first.studios.first.name;
      }
      final trailer = jikan.data.first.trailer?.youtubeId;
      final score = jikan.data.first.score;
      final largeImageUrl = jikan.data.first.images.values.first.largeImageUrl;
      final smallImageUrl = jikan.data.first.images.values.first.smallImageUrl;
      final imageUrl = jikan.data.first.images.values.first.imageUrl;

      final synopsis = jikan.data.first.synopsis;
      final gnrs = jikan.data.first.genres;

      switch (season) {
        case "summer":
          season = 'Verano';
          break;
        case 'winter':
          season = "Invierno";
          break;
        case 'spring':
          season = 'Primavera';
          break;
        case 'fall':
          season = 'Otoño';
        case null:
          season = '';
        default:
      }

      List<String> genres = [];

      for (var gnr in gnrs) {
        genres.add(gnr.name);
      }

      return XData(
          imageUrl: imageUrl,
          smallImageUrl: smallImageUrl,
          largeImageUrl: largeImageUrl,
          malId: jikan.data.first.malId,
          url: jikan.data.first.url,
          trailer: trailer,
          title: title,
          type: jikan.data.first.type,
          source: jikan.data.first.source,
          episodes: jikan.data.first.episodes,
          status: jikan.data.first.status,
          airing: jikan.data.first.airing,
          duration: jikan.data.first.duration,
          rating: rating,
          score: score,
          rank: rank,
          popularity: popularity,
          favorites: jikan.data.first.favorites,
          synopsis: synopsis,
          season: season,
          year: jikan.data.first.year,
          studios: studios ?? '',
          genres: genres);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  // Future<List<Server>> monosServers(String url, int index) async {
  //   List<Server> servers = [];

  //   final episode = url.split('-').last;

  //   String path = url.substringBefore('-$episode');

  //   final lastUrl = 'https://monoschinos2.com$path-episodio-$episode';

  //   final res = await get(Uri.parse(lastUrl));

  //   final document = parse(res.body);

  //   final heroArea = document.querySelector("div.heroarea");
  //   final li = heroArea!.querySelector('ul.dropcaps')?.querySelectorAll('li');

  //   if (li == null) return [];

  //   for (var it in li) {
  //     final serverName = it.querySelector("a")!.text;
  //     final urlBase64 = it.querySelector("a")!.attributes["data-player"]!;
  //     final url = utf8.decode(base64.decode(urlBase64));

  //     index++;

  //     if (serverName != "ok") {
  //       Server server =
  //           Server(index: index, serverName: serverName, serverUrl: url);
  //       servers.add(server);
  //     }
  //   }
  //   return servers;
  // }

  @override
  Future<List<Chapter>> getChapterData(String path) async {
    final response = await dio.get(path);
    final number = path.split('-').last;
    final Document document = parse(response.data);

    final title = document.getElementById('anime_name')!.text;
    final servs =
        document.querySelector('.fuentes-lista')!.querySelectorAll('button');
    final chapterInfo = document
        .querySelector('.titulo-episodio')!
        .querySelectorAll('p')
        .last
        .text;

    List<Chapter> chapterList = [];
    List<String> servers = [];

    for (var serv in servs) {
      String serverUrl = serv.attributes['data-url']!;
      servers.add(serverUrl);
    }

    chapterList.add(Chapter(
        id: '$title/$number/$path',
        chapter: 'Capitulo $number',
        chapterUrl: path,
        chapterInfo: chapterInfo,
        title: title,
        chapterNumber: int.parse(number),
        servers: servers));

    return chapterList;
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
    final response = await dio.get('directorio',
        queryParameters: queryParameter(
          estado: estado,
          p: p,
          tipo: tipo,
          genero: genero,
          estreno: estreno,
          idioma: idioma,
          q: q,
        ));

    List<Anime> animes = [];
    Document document = parse(response.data);

    final result =
        document.querySelector('.animes-container')!.querySelectorAll('li');

    for (var element in result) {
      final animeTitle = element.querySelectorAll('p').last.text;
      final animeUrl = element.querySelector('a')!.attributes['href']!;
      final imageUrl =
          'https://animemac.net${element.querySelectorAll('img').last.attributes['src']}';
      final tipo = element.querySelector('.tipo')!.text;
      final release = element.querySelector('.estreno')!.text;
      final chapterInfo = element.querySelectorAll('p').first.text;
      final tmp = animeUrl.replaceFirst('anime', 'ver');
      final chapterUrl = '$tmp-1';

      final anime = Anime(
          chapterUrl: chapterUrl,
          animeTitle: animeTitle,
          animeUrl: animeUrl,
          imageUrl: imageUrl,
          type: tipo,
          chapterInfo: chapterInfo,
          release: release);
      animes.add(anime);
    }

    return animes;
  }

  @override
  Future<List<Anime>> searchAnime(String query) async {
    final response = await dio.get('directorio', queryParameters: {
      'q': query,
    });

    List<Anime> animes = [];
    Document document = parse(response.data);

    final result =
        document.querySelector('.animes-container')!.querySelectorAll('li');

    for (var element in result) {
      final animeTitle = element.querySelectorAll('p').last.text;
      final animeUrl = element.querySelector('a')!.attributes['href']!;
      final imageUrl =
          'https://animemac.net${element.querySelectorAll('img').last.attributes['src']}';
      final tipo = element.querySelector('.tipo')!.text;
      final release = element.querySelector('.estreno')!.text;
      final chapterInfo = element.querySelectorAll('p').first.text;
      final tmp = animeUrl.replaceFirst('anime', 'ver');
      final chapterUrl = '$tmp-1';

      final anime = Anime(
          chapterUrl: chapterUrl,
          animeTitle: animeTitle,
          animeUrl: animeUrl,
          imageUrl: imageUrl,
          type: tipo,
          chapterInfo: chapterInfo,
          release: release);
      animes.add(anime);
    }

    return animes;
  }
}

extension ListExceptLast<T> on List<T> {
  List<T> get allExceptLast {
    if (isEmpty) {
      return <T>[];
    } else {
      return sublist(0, length - 1);
    }
  }
}

Map<String, dynamic> queryParameter(
    {int? estado,
    int? p,
    String? tipo,
    String? genero,
    int? estreno,
    int? idioma,
    String? q}) {
  Map<String, dynamic> parametros = {};

  if (estado != null && estado != 0) {
    final estadoEntries = <String, int>{'estado': estado};
    parametros.addEntries(estadoEntries.entries);
  }
  if (p != null && p != 0) {
    final pEntries = <String, int>{'p': p};
    parametros.addEntries(pEntries.entries);
  }
  if (tipo != null && tipo != '0') {
    final tipoEntries = <String, String>{'tipo': tipo};
    parametros.addEntries(tipoEntries.entries);
  }
  if (estreno != null && estreno != 0) {
    final estrenoEntries = <String, int>{'estreno': estreno};
    parametros.addEntries(estrenoEntries.entries);
  }
  if (genero != null && genero != '0') {
    final generoEntries = <String, String>{'genero': genero};
    parametros.addEntries(generoEntries.entries);
  }
  if (idioma != null && idioma != 0) {
    final idiomaEntries = <String, int>{'idioma': idioma};
    parametros.addEntries(idiomaEntries.entries);
  }
  return parametros;
}
