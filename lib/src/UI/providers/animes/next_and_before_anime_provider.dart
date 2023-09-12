import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:kimoi/src/domain/domain.dart';

final dio1 = Dio(BaseOptions(
  baseUrl: 'https://animemac.net/',
))
  ..httpClientAdapter;

final nextChPro = StateProvider.family((ref, String path) async {
  return await getNextChap(path);
});

getNextChap(String path) async {
  try {
    final response = await dio1.get(path);

    if (response.statusCode! > 400) return null;

    final number = path.split('-').last;
    final Document document = parse(response.data);

    final title = document.getElementById('anime_name')?.text;

    if (title == null) return null;

    final servs =
        document.querySelector('.fuentes-lista')!.querySelectorAll('button');
    final chapterInfo = document
        .querySelector('.titulo-episodio')!
        .querySelectorAll('p')
        .last
        .text;

    List<String> servers = [];

    for (var serv in servs) {
      String serverUrl = serv.attributes['data-url']!;
      servers.add(serverUrl);
    }

    return Chapter(
        id: '$title/$number/$path',
        chapter: 'Capitulo $number',
        chapterUrl: path,
        chapterInfo: chapterInfo,
        title: title,
        chapterNumber: int.parse(number),
        servers: servers);
  } on Exception catch (e) {
    print(e);
    return null;
  }
}

final nextChapterProvider =
    FutureProvider.family.autoDispose((ref, String path) async {
  try {
    final response = await dio1.get(path);

    if (response.statusCode! > 400) return null;

    final number = path.split('-').last;
    final Document document = parse(response.data);

    final title = document.getElementById('anime_name')?.text;

    if (title == null) return null;

    final servs =
        document.querySelector('.fuentes-lista')!.querySelectorAll('button');
    final chapterInfo = document
        .querySelector('.titulo-episodio')!
        .querySelectorAll('p')
        .last
        .text;

    List<String> servers = [];

    for (var serv in servs) {
      String serverUrl = serv.attributes['data-url']!;
      servers.add(serverUrl);
    }

    return Chapter(
        id: '$title/$number/$path',
        chapter: 'Capitulo $number',
        chapterUrl: path,
        chapterInfo: chapterInfo,
        title: title,
        chapterNumber: int.parse(number),
        servers: servers);
  } on Exception catch (e) {
    print(e);
    return null;
  }
});

final previousChapterProvider =
    FutureProvider.family.autoDispose((ref, String path) async {
  try {
    final response = await dio1.get(path);
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

    List<String> servers = [];

    for (var serv in servs) {
      String serverUrl = serv.attributes['data-url']!;
      servers.add(serverUrl);
    }

    return Chapter(
        id: '$title/$number/$path',
        chapter: 'Capitulo $number',
        chapterUrl: path,
        chapterInfo: chapterInfo,
        title: title,
        chapterNumber: int.parse(number),
        servers: servers);
  } on Exception catch (e) {
    print(e);
    return null;
  }
});
