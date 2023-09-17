import 'dart:convert' as decode;

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:kimoi/src/domain/domain.dart';
import 'package:kimoi/src/infrastructure/infrastructure.dart';
import 'package:kimoi/src/utils/extensions/extension.dart';

class MonoschinosDatasource extends AnimeDatasource {
  final client = Client();

  @override
  Future<AnimeInfo> getAnimeInfo(String path) async {
    final res = await client.get(Uri.parse(path));
    final doc = parse(res.body);

    final contain = doc.querySelector('.acontain');
    if (contain == null) {
      return AnimeInfo(
          title: 'null',
          related: [],
          estado: 'estado',
          idioma: 'idioma',
          episodios: 'episodios',
          estreno: 'estreno',
          tipo: 'tipo',
          episodes: [],
          description: 'description',
          imageUrl: 'imageUrl',
          genres: []);
    }

    List<String> genres = [];

    final title = contain.querySelector('h1')!.text;
    final imageUrl = contain.querySelector('img')!.attributes['src']!;
    final estado = contain.querySelector('.btn1')!.text;
    const idioma = 'sub español';
    const episodios = '';
    final animeDetails = contain.querySelectorAll('.breadcrumb');

    final estreno = animeDetails.last.querySelector('.breadcrumb-item')!.text;

    for (var element
        in animeDetails.first.querySelectorAll('.breadcrumb-item')) {
      genres.add(element.querySelector('a')!.text);
    }

    final description = contain.querySelector('.textComplete')!.text;

    final episodeList = doc.querySelector('.allanimes')!.querySelectorAll('a');

    List<Chapter> episodes = [];

    for (var element in episodeList) {
      final chapterUrl = element.attributes['href']!;
      final tmpUrl =
          chapterUrl.substringBefore('episodio').replaceAll('ver', 'anime');
      final url = '${tmpUrl}sub-espanol';
      final imageUrl = element
          .querySelector('.animeimgdiv')!
          .querySelector('img')!
          .attributes['data-src']!;
      final animeTitle = element.querySelector('.animetitles')!.text;
      final chapterInfo = element.querySelector('.animetitles')!.text;

      final id = chapterUrl.substringAfterLast('/');
      final chaptNumber = chapterUrl.split('-').last.trim();

      final chapter = Chapter(
        servers: [],
        id: id,
        chapterNumber: int.parse(chaptNumber),
        animeUrl: url,
        imageUrl: imageUrl,
        title: animeTitle,
        chapterUrl: chapterUrl,
        chapterInfo: chapterInfo,
        chapter: chapterInfo,
      );

      episodes.add(chapter);
    }

    List<List<Chapter>> subList = [];

    if (episodes.length < 500) {
      final mod = episodes.length % 50;
      int h = 0;
      int j = 50;
      for (var i = 0; j <= episodes.length; i++) {
        final list = episodes.toList().sublist(h, j);
        subList.add(list);
        h = h + 50;
        j = j + 50;
      }
      subList.add(episodes.toList().sublist(h, (h + mod)));
    } else if (episodes.length >= 500) {
      final mod = episodes.length % 100;
      int h = 0;
      int j = 100;
      for (var i = 0; j <= episodes.length; i++) {
        final list = episodes.toList().sublist(h, j);
        subList.add(list);
        h = h + 100;
        j = j + 100;
      }
      subList.add(episodes.toList().sublist(h, (h + mod)));
    }

    return AnimeInfo(
        title: title,
        related: [],
        estado: estado,
        idioma: idioma,
        episodios: episodios,
        estreno: estreno,
        tipo: 'Anime',
        episodes: subList,
        description: description.substringBeforeLast('Ver menos'),
        imageUrl: imageUrl,
        genres: genres);
  }

  final channel = const MethodChannel("extractors");

  @override
  Future<List<Chapter>> getChapterData(String path) async {
    final res = await Dio().get(path);
    final doc = parse(res.data);

    List<Chapter> chapterList = [];
    final title = doc
        .querySelector('.heromain_h1')!
        .text
        .substringAfter('Ver ')
        .substringBeforeLast(' -');
    final chapterNumber =
        doc.querySelector('.heromain_h1')!.text.substringAfterLast('-').trim();

    final id = path.substringAfterLast('/');
    List<String> servers = [];

    doc.querySelector('.dropcaps')!.querySelectorAll('li').forEach((element) {
      final urlBase64 = element.querySelector('a')!.attributes['data-player']!;
      final urlUtf8 = decode.base64.decode(urlBase64);
      final url = decode.utf8.decode(urlUtf8);
      servers.add(url);
    });

    chapterList.add(Chapter(
        title: title,
        id: id,
        chapterUrl: path,
        chapterNumber: int.parse(chapterNumber),
        servers: servers,
        chapterInfo: '',
        chapter: 'Episodio $chapterNumber'));

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
    final dio = Dio()..httpClientAdapter;
    final res = await dio.get('https://monoschinos2.com/animes',
        options: Options(
          headers: {
            "Accept": "application/json",
            "User-Agent":
                "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
          },
        ),
        queryParameters:
            parameter(tipo: tipo, genero: genero, p: p, estreno: estreno));

    List<Anime> animes = [];

    final doc = parse(res.data);
    final main = doc.querySelector('.heromain')!;

    final data = main.querySelector('.row')!.querySelectorAll('a');

    for (var element in data) {
      final title = element.querySelector('h3')?.text ?? 'no title';
      final animeUrl = element.attributes['href']!;
      final imageUrl = element.querySelector('img')!.attributes['data-src']!;
      final seriesInfo = element.querySelector('.seriesinfo')!.text;

      final type = seriesInfo.substringBefore(' ');
      final release = seriesInfo.substringAfterLast(' ');

      animes.add(Anime(
          animeUrl: animeUrl,
          imageUrl: imageUrl,
          animeTitle: title,
          release: release,
          type: type));
    }

    return animes;
  }

  @override
  Future<XData> getExtraData(Anime anime) async {
    try {
      final title = anime.animeTitle;
      final lastUrl = 'https://api.jikan.moe/v4/anime?q=$title&limit=20';

      final jikRes = await Dio().get(lastUrl);
      final jikan = JikanResponse.fromJson(jikRes.data);

      final rating = jikan.data.first.rating;
      final popularity = jikan.data.first.popularity;
      final rank = jikan.data.first.rank;
      String? season = jikan.data.first.season;
      final studios = jikan.data.first.studios.first.name;
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
          studios: studios,
          genres: genres);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Anime>> getLastAnimeAdded({int? year, int? page}) async {
    final dio = Dio()..httpClientAdapter;
    final res = await dio.get('https://monoschinos2.com/animes',
        options: Options(headers: {
          "Accept": "application/json",
          "User-Agent":
              "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
        }),
        queryParameters: {'fecha': 2023});

    List<Anime> animes = [];

    final doc = parse(res.data);
    final main = doc.querySelector('.heromain')!;

    final data = main.querySelector('.row')!.querySelectorAll('a');

    for (var element in data) {
      final title = element.querySelector('h3')?.text ?? 'no title';
      final animeUrl = element.attributes['href']!;
      final imageUrl = element.querySelector('img')!.attributes['data-src']!;
      final seriesInfo = element.querySelector('.seriesinfo')!.text;

      final chapterUrl = animeUrl
          .replaceFirst('anime', 'ver')
          .replaceFirst('sub-espanol', 'episodio-1');

      final type = seriesInfo.substringBefore(' ');
      final release = seriesInfo.substringAfterLast(' ');

      animes.add(Anime(
          animeUrl: animeUrl,
          imageUrl: imageUrl,
          animeTitle: title,
          release: release,
          type: type,
          chapterUrl: chapterUrl));
    }

    return animes;
  }

  @override
  Future<List<Anime>> getRecentAnime({int? year, int? page}) async {
    final res = await Dio().get('https://monoschinos2.com/');
    final doc = parse(res.data);
    List<Anime> animes = [];
    final animeData = doc.querySelector('.heroarea1')?.querySelectorAll('a');
    if (animeData == null) return [];

    for (var element in animeData) {
      final chapterUrl = element.attributes['href']!;
      final tmpUrl =
          chapterUrl.substringBefore('episodio').replaceAll('ver', 'anime');
      final url = '${tmpUrl}sub-espanol';
      final imageUrl = element
          .querySelector('.animeimgdiv')!
          .querySelector('img')!
          .attributes['data-src']!;
      final animeTitle = element.querySelector('.animetitles')!.text;
      final hoverDiv = element.querySelector('.hoverdiv')!;

      final chapterInfo = hoverDiv.querySelector('p')!.text;
      final type = hoverDiv.querySelector('button')!.text;

      final anime = Anime(
          animeUrl: url,
          imageUrl: imageUrl,
          animeTitle: animeTitle,
          chapterUrl: chapterUrl,
          chapterInfo: 'Episodio $chapterInfo',
          type: type);
      animes.add(anime);
    }
    return animes;
  }

  @override
  Future<List<Anime>> searchAnime(String query) async {
    List<Anime> animes = [];

    final res = await Dio().get('https://monoschinos2.com/buscar?q=$query');
    final doc = parse(res.data);

    final main = doc.querySelector('.heromain')!;

    final data = main.querySelector('.row')!.querySelectorAll('.col-md-4');

    for (var element in data) {
      final title = element.querySelector('h3')?.text ?? 'no title';
      final animeUrl = element.querySelector('a')!.attributes['href']!;
      final imageUrl = element.querySelector('img')!.attributes['src']!;
      final seriesInfo = element.querySelector('.seriesinfo')!.text;

      final type = seriesInfo.substringBefore(' ');
      final release = seriesInfo.substringAfterLast(' ');

      animes.add(Anime(
          chapterInfo: '',
          animeUrl: animeUrl,
          imageUrl: imageUrl,
          animeTitle: title,
          release: release,
          type: type));
    }

    return animes;
  }
}

Map<String, dynamic> parameter(
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
  if (tipo != null) {
    final tipoEntries = <String, String>{'tipo': tipo};
    parametros.addEntries(tipoEntries.entries);
  }
  if (estreno != null && estreno != 0) {
    final estrenoEntries = <String, int>{'fecha': estreno};
    parametros.addEntries(estrenoEntries.entries);
  }
  if (genero != null) {
    final generoEntries = <String, String>{'genero': genero};
    parametros.addEntries(generoEntries.entries);
  }
  if (idioma != null && idioma != 0) {
    final idiomaEntries = <String, int>{'idioma': idioma};
    parametros.addEntries(idiomaEntries.entries);
  }
  return parametros;
}
