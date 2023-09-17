import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerScreen extends StatefulWidget {
  const YoutubePlayerScreen({super.key, required this.id});

  final String id;

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    controller = YoutubePlayerController(
        initialVideoId: widget.id,
        flags: const YoutubePlayerFlags(autoPlay: true));
  }

  Future<bool> onWillPop() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: YoutubePlayer(
              aspectRatio: 16 / 9,
              controller: controller,
              onReady: () {
                controller.addListener(() {});
              },
              topActions: [
                IconButton(
                    onPressed: () {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                      ]);
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                          overlays: [
                            SystemUiOverlay.bottom,
                            SystemUiOverlay.top
                          ]);
                      context.pop();
                    },
                    icon: const Icon(Icons.arrow_back))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
