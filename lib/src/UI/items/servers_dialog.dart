import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain.dart';

class ServersDialog extends ConsumerStatefulWidget {
  const ServersDialog(this.anime, {super.key});

  final Anime anime;

  @override
  ServersDialogState createState() => ServersDialogState();
}

class ServersDialogState extends ConsumerState<ServersDialog> {
 
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  // DataSource? _dataSource;
  StreamSubscription? _subscription;
  // final ValueNotifier<Video?> _quality = ValueNotifier(null);
  // StreamSubscription? _currentPositionSubs;

  Duration currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();

    // _subscription = _meeduPlayerController.onFullscreenChanged.listen(
    //   (bool isFullscreen) {
    //     if (!isFullscreen) {
    //       // if the fullscreen page was closed
    //       _dataSource = null;
    //     }
    //   },
    // );

    // _currentPositionSubs = _meeduPlayerController.onPositionChanged.listen(
    //   (Duration position) {
    //     currentPosition = position;
    //   },
    // );
    // clearAndGet();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    // _meeduPlayerController.dispose();
    super.dispose();
  }

  // clearAndGet() async {
  //   if (ref.read(getChapterInfoProvider).isNotEmpty) {
  //     ref.read(getChapterInfoProvider).clear();
  //   }

  //   await Future.delayed(const Duration(seconds: 1));
  //   await ref
  //       .read(getChapterInfoProvider.notifier)
  //       .getAnimes(widget.anime.chapterUrl!)
  //       .then((value) async {
  //     final servers =
  //         ref.read(getChapterInfoProvider).first.servers.reversed.toList();

  //     for (var i = 0; i < servers.length; i++) {
  //       if (servers[i].serverUrl.contains("yourupload") ||
  //           servers[i].serverUrl.contains("mp4upload")) {
  //         i++;
  //       }
  //       final video = await getVideo(servers[i].serverUrl);
  //       if (video.isNotEmpty) {
          
  //         final datasource = DataSource(
  //             type: DataSourceType.network,
  //             source: video.first.videoUrl,
  //             httpHeaders: {
  //               "User-Agent":
  //                   "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
  //             });

  //         await Future.delayed(const Duration(milliseconds: 100));

  //         _quality.value = video.first;
  //         _set(datasource);
  //         return;
  //       }
  //     }
  //   });
  // }

  // var channel = const MethodChannel("extractors");
  // Map test = {};
  // List<Video> videoList = [];

  // Future<List<Video>> getVideo(String url) async {
  //   final success = await channel.invokeMethod('extractVideoUrl', url) as Map;
  //   test.addAll(success);
  //   Video video = Video();
  //   for (var element in test.values) {
  //     video = Video.fromRawJson(element);
  //     videoList.add(video);
  //     setState(() {});
  //   }
  //   return videoList;
  // }

  // Widget get header {
  //   return Container(
  //     padding: const EdgeInsets.all(5),
  //     child: Row(
  //       children: [
  //         CupertinoButton(
  //           child: const Icon(
  //             Icons.arrow_back,
  //             color: Colors.white,
  //           ),
  //           onPressed: () async {
  //             // close the fullscreen
  //             context.pop();
  //           },
  //         ),
  //         const Spacer(),
  //         CupertinoButton(
  //           padding: const EdgeInsets.all(5),
  //           minSize: 25,
  //           onPressed: _onChangeVideoQuality,
  //           child: ValueListenableBuilder<Video?>(
  //             valueListenable: _quality,
  //             builder: (context, Video? quality, child) {
  //               return Text(
  //                 quality!.quality,
  //                 style: const TextStyle(
  //                   fontSize: 18,
  //                   color: Colors.white,
  //                 ),
  //               );
  //             },
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
  // BuildContext, MeeduPlayerController, Responsive

  // Widget get bottomRight {
  //   return CupertinoButton(
  //     padding: const EdgeInsets.all(5),
  //     minSize: 25,
  //     onPressed: _skipOpenning,
  //     child: ValueListenableBuilder<Video?>(
  //       valueListenable: _quality,
  //       builder: (context, Video? quality, child) {
  //         return const Text(
  //           "Skip Op",
  //           style: TextStyle(
  //             fontSize: 18,
  //             color: Colors.white,
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // void _onChangeVideoQuality() {
  //   showCupertinoModalPopup(
  //     context: context,
  //     builder: (_) => CupertinoActionSheet(
  //       actions: List.generate(
  //         videoList.length,
  //         (index) {
  //           final quality = videoList[index];
  //           return CupertinoActionSheetAction(
  //             child: Text(quality.quality),
  //             onPressed: () {
  //               _quality.value = quality; // change the video quality
  //               final datasource =
  //                   _dataSource!.copyWith(source: _quality.value!.videoUrl);
  //               _set(datasource); // update the datasource
  //               Navigator.maybePop(_);
  //             },
  //           );
  //         },
  //       ),
  //       cancelButton: CupertinoActionSheetAction(
  //         onPressed: () => Navigator.maybePop(_),
  //         isDestructiveAction: true,
  //         child: const Text("Cancel"),
  //       ),
  //     ),
  //   );
  // }

  // void _skipOpenning() {
  //   final position = _meeduPlayerController.position.value;
  //   _meeduPlayerController.seekTo(Duration(seconds: position.inSeconds + 85));
  // }

  // Future<void> _set(DataSource dataSource) async {
  //   if (_dataSource == null) {
  //     _dataSource = dataSource;
  //     // launch the player in fullscreen mode
  //     await _meeduPlayerController.launchAsFullscreen(context,
  //         dataSource: _dataSource!,
  //         autoplay: true,
  //         header: header,
  //         bottomRight: bottomRight);
  //   } else {
  //     // update the player with new datasource and it doesn't re-launch the player
  //     await _meeduPlayerController.setDataSource(dataSource,
  //         seekTo: currentPosition);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
//
    // if (chapter.isEmpty) {
    return const SizedBox(
        height: 150, child: Center(child: CircularProgressIndicator()));
    // }

    // final servers = chapter.first.servers;

    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    //   children: servers
    //       .map((e) => CupertinoListTile(
    //             title: Text(e.serverName,
    //                 style: TextStyle(color: color.onBackground)),
    //             onTap: () async {
    //               await getVideo(e.serverUrl).then((value) {
    //                 if (value.isEmpty) {
    //                   const snackBar = SnackBar(
    //                     content: Text("Error"),
    //                     duration: Duration(seconds: 1),
    //                   );
    //                   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //                   return;
    //                 }

    //                 final datasource = DataSource(
    //                     type: DataSourceType.network,
    //                     source: value.first.videoUrl,
    //                     httpHeaders: {
    //                       "User-Agent":
    //                           "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
    //                     });

    //                 _quality.value = value.first;
    //                 // context.push("/video-player", extra: value);
    //                 _set(datasource);
    //               });
    //             },
    //           ))
    //       .toList(),
    // );
  }
}
