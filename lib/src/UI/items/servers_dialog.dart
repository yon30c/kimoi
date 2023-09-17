


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/providers/animes/anime_info_provider.dart';
import 'package:kimoi/src/domain/domain.dart';
import 'package:kimoi/src/infrastructure/infrastructure.dart';
import 'package:kimoi/src/utils/extractors/extractors.dart';
import 'package:kimoi/src/utils/extractors/voe_extractor.dart';

class ServerDialog extends ConsumerStatefulWidget {
  const ServerDialog(this.anime, {super.key});

  final Anime anime;

  @override
  ServerDialogState createState() => ServerDialogState();
}

class ServerDialogState extends ConsumerState<ServerDialog> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    ref.read(getVideoDataProvider).clear();
    await ref
        .read(getVideoDataProvider.notifier)
        .getVideos(widget.anime.chapterUrl!);
  }

  @override
  Widget build(BuildContext context) {
    final chapter = ref.watch(getVideoDataProvider);

    if (chapter.isEmpty) {
      return const AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: CircularProgressIndicator(),
            )
          ],
        ),
      );
    }
    final servers = ref.watch(getVideoDataProvider).first.servers;

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
            optional: voeIndex != -1
                ? servers[voeIndex]
                : mixdroIndex != -1
                    ? servers[mixdroIndex]
                    : okruIndex != -1
                        ? servers[okruIndex]
                        : youruploadIndex != -1
                            ? servers[youruploadIndex]
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

    return SimpleDialog(
        title: const Text('Servidores'),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        children: [
          const Divider(
            height: 2,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: fixedServers
                .map((e) => ListTile(
                    leading: const Icon(Icons.play_circle),
                    title: Text(e.name),
                    onTap: () {
                      final chapt = chapter.first;
                      chapt.isWatching = true;
                      chapt.imageUrl = widget.anime.imageUrl;
                      chapt.animeUrl = widget.anime.animeUrl;
                      ref
                          .read(fixedServerProvider.notifier)
                          .update((state) => e);
                      context.pop();
                      context.push('/local-player', extra: chapt);
                    }))
                .toList(),
          )
        ]);
  }
}

final fixedServerProvider = StateProvider<FixedServer?>((ref) => null);

final videoServers = StateProvider((ref) async {
  final servers = ref.watch(fixedServerProvider);
  List<Video> videos = [];
  final url = servers!.url;

  if (url.contains('yourupload')) {
    final video = await YourUploadExtractor().videoFromUrl(url);
    if (video != null) {
      videos.add(video);
    } else {
      videos.addAll(await extract(servers.optional!));
    }
  } else if (url.contains('mp4upload')) {
    final video = await Mp4UploadExtractor().videosFromUrl(url);
    if (video.isNotEmpty) {
      videos.addAll(video);
    } else {
      videos.addAll(await extract(servers.optional!));
    }
  } else if (url.contains('ok.ru')) {
    final vid = await OkruExtractor().videosFromUrl(url);
    if (vid.isEmpty) {
      videos.addAll(await extract(servers.optional!));
    } else {
      videos.addAll(vid);
    }
  } else if (url.contains('solid')) {
    final videos = await SolidFilesExtractor().videoFromUrl(url);
    if (videos.isNotEmpty) {
      videos.addAll(videos);
    } else {
      videos.addAll(await extract(servers.optional!));
    }
  } else if (url.contains('mixdro')) {
    final video = await MixDropExtractor().videoFromUrl(url);
    if (video.isNotEmpty) {
      videos.addAll(video);
    } else {
      videos.addAll(await extract(servers.optional!));
    }
  } else if (url.contains('voe')) {
    final video = await VoeExtractor().videoFromUrl(url);
    if (video.isNotEmpty) {
      videos.addAll(video);
    } else {
      videos.addAll(await extract(servers.optional!));
    }
  } else if (url.contains("upload")) {
    if (!url.contains('yourupload') || !url.contains("mp4upload")) {
      final video = await UploadExtractor().videoFromUrl(url);
      if (video != null) {
        videos.add(video);
      } else {
        videos.addAll(await extract(servers.optional!));
      }
    }
  }
  return videos;
});

class FixedServer {
  final String name;
  final String url;
  final String? optional;

  FixedServer({required this.name, required this.url, this.optional});
}

Future<List<Video>> extract(String url) async {
  List<Video> videos = [];
  if (url.contains('yourupload')) {
    final video = await YourUploadExtractor().videoFromUrl(url);
    if (video != null) videos.add(video);
  } else if (url.contains('mp4upload')) {
    final video = await Mp4UploadExtractor().videosFromUrl(url);
    if (video.isNotEmpty) videos.addAll(video);
  } else if (url.contains('ok.ru')) {
    videos.addAll(await OkruExtractor().videosFromUrl(url));
  } else if (url.contains('solid')) {
    final videos = await SolidFilesExtractor().videoFromUrl(url);
    if (videos.isNotEmpty) videos.addAll(videos);
  } else if (url.contains('mixdro')) {
    final video = await MixDropExtractor().videoFromUrl(url);
    if (video.isNotEmpty) videos.addAll(video);
  } else if (url.contains('voe')) {
    final video = await MixDropExtractor().videoFromUrl(url);
    if (video.isNotEmpty) videos.addAll(video);
  } else if (url.contains("upload")) {
    if (!url.contains('yourupload') || !url.contains("mp4upload")) {
      final video = await UploadExtractor().videoFromUrl(url);
      if (video != null) videos.add(video);
    }
  }

  return videos;
}
