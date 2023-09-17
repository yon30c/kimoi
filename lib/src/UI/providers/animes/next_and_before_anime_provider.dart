import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:kimoi/src/UI/items/servers_dialog.dart';
import 'package:kimoi/src/domain/domain.dart';
import 'package:kimoi/src/utils/extensions/extension.dart';

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
        chapter: 'Episodio $number',
        chapterUrl: path,
        chapterInfo: chapterInfo,
        title: title,
        chapterNumber: int.parse(number),
        servers: servers);
  } on Exception catch (e) {
    debugPrint('$e');
    return null;
  }
}

final nextChapterProvider =
    FutureProvider.family.autoDispose((ref, String path) async {
  try {
    final response = await dio1.get(path);
    final Document doc = parse(response.data);

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
      final urlUtf8 = base64.decode(urlBase64);
      final url = utf8.decode(urlUtf8);
      servers.add(url);
    });

    List<FixedServer> fixedServers = [];
    int youruploadIndex =
        servers.indexWhere((element) => element.contains('yourupload'));
    int mp4uploadIndex =
        servers.indexWhere((element) => element.contains('mp4upload'));
    int okruIndex = servers.indexWhere((element) => element.contains('ok.ru'));
    int voeIndex = servers.indexWhere((element) => element.contains('voe'));
    int mixdroIndex =
        servers.indexWhere((element) => element.contains('mixdro'));

    for (var url in servers) {
      if (url.contains('yourupload')) {
        fixedServers.add(FixedServer(
            name: 'YourUpload',
            url: url,
            optional: okruIndex != -1
                ? servers[okruIndex]
                : voeIndex != -1
                    ? servers[voeIndex]
                    : mixdroIndex != -1
                        ? servers[mixdroIndex]
                        : mp4uploadIndex != -1
                            ? servers[mp4uploadIndex]
                            : null));
      } else if (url.contains('mp4upload')) {
        fixedServers.add(FixedServer(
            name: 'Mp4Upload',
            url: url,
            optional: okruIndex != -1
                ? servers[okruIndex]
                : voeIndex != -1
                    ? servers[voeIndex]
                    : mixdroIndex != -1
                        ? servers[mixdroIndex]
                        : mp4uploadIndex != -1
                            ? servers[mp4uploadIndex]
                            : null));
      } else if (url.contains('ok.ru')) {
        fixedServers.add(FixedServer(
            name: 'Okru',
            url: url,
            optional: youruploadIndex != -1
                ? servers[youruploadIndex]
                : mixdroIndex != -1
                    ? servers[mixdroIndex]
                    : voeIndex != -1
                        ? servers[voeIndex]
                        : mp4uploadIndex != -1
                            ? servers[mp4uploadIndex]
                            : null));
      } else if (url.contains('solid')) {
        fixedServers.add(FixedServer(
            name: 'SolidFiles',
            url: url,
            optional: okruIndex != -1
                ? servers[okruIndex]
                : voeIndex != -1
                    ? servers[voeIndex]
                    : mixdroIndex != -1
                        ? servers[mixdroIndex]
                        : mp4uploadIndex != -1
                            ? servers[mp4uploadIndex]
                            : null));
      } else if (url.contains('mixdro')) {
        fixedServers.add(FixedServer(
            name: 'MixDrop',
            url: url,
            optional: okruIndex != -1
                ? servers[okruIndex]
                : voeIndex != -1
                    ? servers[voeIndex]
                    : youruploadIndex != -1
                        ? servers[youruploadIndex]
                        : mp4uploadIndex != -1
                            ? servers[mp4uploadIndex]
                            : null));
      } else if (url.contains('voe')) {
        fixedServers.add(FixedServer(
            name: 'VoeCDN',
            url: url,
            optional: okruIndex != -1
                ? servers[okruIndex]
                : youruploadIndex != -1
                    ? servers[youruploadIndex]
                    : mixdroIndex != -1
                        ? servers[voeIndex]
                        : mp4uploadIndex != -1
                            ? servers[mp4uploadIndex]
                            : null));
      } else if (url.contains("upload")) {
        if (!url.contains('yourupload') || !url.contains("mp4upload")) {
          fixedServers.add(FixedServer(
              name: 'Upload',
              url: url,
              optional: okruIndex != -1
                  ? servers[okruIndex]
                  : youruploadIndex != -1
                      ? servers[youruploadIndex]
                      : mixdroIndex != -1
                          ? servers[voeIndex]
                          : mp4uploadIndex != -1
                              ? servers[mp4uploadIndex]
                              : null));
        }
      }
    }
    ref
        .read(fixedServerProvider.notifier)
        .update((state) => fixedServers.first);

    return Chapter(
        title: title,
        id: id,
        chapterUrl: path,
        chapterNumber: int.parse(chapterNumber),
        servers: servers,
        chapterInfo: '',
        chapter: 'Episodio $chapterNumber');
  } on Exception catch (e) {
    debugPrint('$e');
    return null;
  }
});

final previousChapterProvider =
    FutureProvider.family.autoDispose((ref, String path) async {
  try {
    final response = await dio1.get(path);
    final Document doc = parse(response.data);

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
      final urlUtf8 = base64.decode(urlBase64);
      final url = utf8.decode(urlUtf8);
      servers.add(url);
    });

    List<FixedServer> fixedServers = [];
    int youruploadIndex =
        servers.indexWhere((element) => element.contains('yourupload'));
    int mp4uploadIndex =
        servers.indexWhere((element) => element.contains('mp4upload'));
    int okruIndex = servers.indexWhere((element) => element.contains('ok.ru'));
    int voeIndex = servers.indexWhere((element) => element.contains('voe'));
    int mixdroIndex =
        servers.indexWhere((element) => element.contains('mixdro'));

    for (var url in servers) {
      if (url.contains('yourupload')) {
        fixedServers.add(FixedServer(
            name: 'YourUpload',
            url: url,
            optional: okruIndex != -1
                ? servers[okruIndex]
                : voeIndex != -1
                    ? servers[voeIndex]
                    : mixdroIndex != -1
                        ? servers[mixdroIndex]
                        : mp4uploadIndex != -1
                            ? servers[mp4uploadIndex]
                            : null));
      } else if (url.contains('mp4upload')) {
        fixedServers.add(FixedServer(
            name: 'Mp4Upload',
            url: url,
            optional: okruIndex != -1
                ? servers[okruIndex]
                : voeIndex != -1
                    ? servers[voeIndex]
                    : mixdroIndex != -1
                        ? servers[mixdroIndex]
                        : mp4uploadIndex != -1
                            ? servers[mp4uploadIndex]
                            : null));
      } else if (url.contains('ok.ru')) {
        fixedServers.add(FixedServer(
            name: 'Okru',
            url: url,
            optional: youruploadIndex != -1
                ? servers[youruploadIndex]
                : mixdroIndex != -1
                    ? servers[mixdroIndex]
                    : voeIndex != -1
                        ? servers[voeIndex]
                        : mp4uploadIndex != -1
                            ? servers[mp4uploadIndex]
                            : null));
      } else if (url.contains('solid')) {
        fixedServers.add(FixedServer(
            name: 'SolidFiles',
            url: url,
            optional: okruIndex != -1
                ? servers[okruIndex]
                : voeIndex != -1
                    ? servers[voeIndex]
                    : mixdroIndex != -1
                        ? servers[mixdroIndex]
                        : mp4uploadIndex != -1
                            ? servers[mp4uploadIndex]
                            : null));
      } else if (url.contains('mixdro')) {
        fixedServers.add(FixedServer(
            name: 'MixDrop',
            url: url,
            optional: okruIndex != -1
                ? servers[okruIndex]
                : voeIndex != -1
                    ? servers[voeIndex]
                    : youruploadIndex != -1
                        ? servers[youruploadIndex]
                        : mp4uploadIndex != -1
                            ? servers[mp4uploadIndex]
                            : null));
      } else if (url.contains('voe')) {
        fixedServers.add(FixedServer(
            name: 'VoeCDN',
            url: url,
            optional: okruIndex != -1
                ? servers[okruIndex]
                : youruploadIndex != -1
                    ? servers[youruploadIndex]
                    : mixdroIndex != -1
                        ? servers[voeIndex]
                        : mp4uploadIndex != -1
                            ? servers[mp4uploadIndex]
                            : null));
      } else if (url.contains("upload")) {
        if (!url.contains('yourupload') || !url.contains("mp4upload")) {
          fixedServers.add(FixedServer(
              name: 'Upload',
              url: url,
              optional: okruIndex != -1
                  ? servers[okruIndex]
                  : youruploadIndex != -1
                      ? servers[youruploadIndex]
                      : mixdroIndex != -1
                          ? servers[voeIndex]
                          : mp4uploadIndex != -1
                              ? servers[mp4uploadIndex]
                              : null));
        }
      }
    }
    ref
        .read(fixedServerProvider.notifier)
        .update((state) => fixedServers.first);
    return Chapter(
        title: title,
        id: id,
        chapterUrl: path,
        chapterNumber: int.parse(chapterNumber),
        servers: servers,
        chapterInfo: '',
        chapter: 'Episodio $chapterNumber');
  } on Exception catch (e) {
    debugPrint('$e');
    return null;
  }
});


final chapterProvider = StateProvider<Chapter?>((ref) => null);

