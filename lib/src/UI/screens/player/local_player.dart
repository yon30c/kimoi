import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:better_player_v3/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/items/forward_and_rewind.dart';
import 'package:kimoi/src/UI/items/transitions.dart';
import 'package:kimoi/src/UI/providers/storage/watching_provider.dart';
import 'package:kimoi/src/UI/screens/player/center_play_button.dart';
import 'package:kimoi/src/infrastructure/models/video.dart' as v;
import 'package:kimoi/src/utils/helpers/responsive.dart';

import '../../../domain/domain.dart';

class LocalPlayer extends ConsumerStatefulWidget {
  const LocalPlayer({super.key, required this.videos});

  final Chapter videos;

  @override
  LocalPlayerState createState() => LocalPlayerState();
}

class LocalPlayerState extends ConsumerState<LocalPlayer> {
  late BetterPlayerController _betterPlayerController;
  var channel = const MethodChannel("extractors");
  List<v.Video> videoList = [];

  bool isInitialize = false;
  bool showRewind = false;
  bool showForward = false;
  bool isVisible = false;
  bool isSkipOpActive = true;
  bool isChanging = false;
  bool isPause = false;
  bool isClose = false;
  bool isCompleted = false;
  bool flag = false;

  String chapterInfo = '';
  String title = '';

  ValueNotifier<String> serverName = ValueNotifier('');

  void addOnWatching(int position, int duration) async {
    final chapter = widget.videos;
    if (isClose) return;
    chapter.position = position;

    await ref
        .read(isWatchingAnimeProvider.notifier)
        .addOnWatching(widget.videos);

    ref.refresh(watchingHistoryProvider.notifier).loadNextPage();

    if (isCompleted) return;

    if (position < 240) return;

    if ((position) > (duration - 240)) {
      chapter.isCompleted = true;
      chapter.isWatching = false;
      ref.read(isWatchingAnimeProvider.notifier).addOnWatching(widget.videos);
    }
    isCompleted = true;
    setState(() {});
  }

  void skipOp(BetterPlayerController controller) async {
    setState(() {});
    final latestValue = controller.videoPlayerController?.value;

    if (latestValue != null) {
      // cancelAndRestartTimer();
      final end = latestValue.duration!.inSeconds;
      final skip =
          (latestValue.position + const Duration(seconds: 85)).inSeconds;
      controller.seekTo(Duration(seconds: min(skip, end)));
    }
    await Future.delayed(const Duration(milliseconds: 300));
    isSkipOpActive = false;
    setState(() {});
  }

  onChangeStart() {
    isChanging = true;
    isVisible = true;
    setState(() {});
  }

  onChangeEnd() async {
    isChanging = false;
    await Future.delayed(const Duration(milliseconds: 300));
    if (isPause) return;
    isVisible = false;
    setState(() {});
  }

  showControls() async {
    isVisible = true;
    setState(() {});
    await Future.delayed(const Duration(seconds: 2));
    if (isChanging) return;
    if (isPause) return;
    if (isClose) return;
    isVisible = false;
    setState(() {});
  }

  void onRewind(BetterPlayerController controller) async {
    showRewind = true;
    setState(() {});
    final latestValue = controller.videoPlayerController?.value;
    if (latestValue != null) {
      // cancelAndRestartTimer();

      final beginning = const Duration().inMilliseconds;
      final skip = (latestValue.position -
              Duration(
                  milliseconds: controller.betterPlayerConfiguration
                      .controlsConfiguration.backwardSkipTimeInMilliseconds))
          .inMilliseconds;
      controller.seekTo(Duration(milliseconds: max(skip, beginning)));
    }
    await Future.delayed(const Duration(milliseconds: 300));
    showRewind = false;
    setState(() {});
  }

  void onForward(BetterPlayerController controller) async {
    showForward = true;
    setState(() {});
    final latestValue = controller.videoPlayerController?.value;

    if (latestValue != null) {
      // cancelAndRestartTimer();
      final end = latestValue.duration!.inMilliseconds;
      final skip = (latestValue.position +
              Duration(
                  milliseconds: controller.betterPlayerConfiguration
                      .controlsConfiguration.forwardSkipTimeInMilliseconds))
          .inMilliseconds;
      controller.seekTo(Duration(milliseconds: min(skip, end)));
    }
    await Future.delayed(const Duration(milliseconds: 300));
    showForward = false;
    setState(() {});
  }

  Future<List<v.Video>> getVideos() async {
    final List<v.Video> vidList = [];
    for (var serv in widget.videos.servers.reversed) {
      final success =
          await channel.invokeMethod('extractVideoUrl', serv) as Map;
      v.Video video = v.Video();
      for (var element in success.values) {
        video = v.Video.fromRawJson(element);

        video.headers = {
          "User-Agent":
              "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
        };

        if (serv.contains('yourupload')) {
          video.headers = {
            "referer": "https://www.yourupload.com/",
            "User-Agent":
                "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
          };
        }
        // if (video != null) {
        return [video];

        // setState(() {});
      }
    }
    return vidList;
  }

  void initPlayer() async {
    videoList = await getVideos();

    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
            startAt: Duration(seconds: widget.videos.position),
            allowedScreenSleep: false,
            aspectRatio: 16 / 9,
            fit: BoxFit.contain,
            autoDetectFullscreenDeviceOrientation: true,
            autoPlay: true,
            controlsConfiguration: BetterPlayerControlsConfiguration(
              playerTheme: BetterPlayerTheme.custom,
              customControlsBuilder: (controller, onPlayerVisibilityChanged) {
                return const SizedBox();
              },
            ));

    Map<String, String> resolutions = {};

    for (var element in videoList) {
      resolutions.addAll({element.quality: element.videoUrl!});
    }

    serverName.value = videoList.first.quality;

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoList.first.videoUrl!,
      headers: videoList.first.headers,
      resolutions: resolutions,
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);

    isInitialize = true;
    setState(() {});

    _betterPlayerController.addEventsListener((p0) {
      if (isClose) return;
      if (_betterPlayerController.isPlaying()!) {
        addOnWatching(
            _betterPlayerController
                .videoPlayerController!.value.position.inSeconds,
            _betterPlayerController
                .videoPlayerController!.value.duration!.inMinutes);

        setState(() {});

        // Agregar duracion.
        if (isInitialize && _betterPlayerController.isPlaying()!) {
          if (flag) return;
          flag = true;
          setState(() {});
          final chapter = widget.videos;
          chapter.duration = _betterPlayerController
              .videoPlayerController!.value.duration!.inSeconds;
          ref
              .read(isWatchingAnimeProvider.notifier)
              .addOnWatching(widget.videos);
        }
      }
    });

    showControls();
  }

  final responsive = Responsive();

  @override
  void initState() {
    super.initState();

    chapterInfo = widget.videos.chapter;
    title = widget.videos.title;

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    responsive.setDimensions(size.width, size.height);

    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      child: WillPopScope(
        onWillPop: () async {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: () {
              showControls();
            },
            child: Center(
              child: !isInitialize
                  ? Container(
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Stack(
                      children: [
                        BetterPlayer(controller: _betterPlayerController),
                        Center(
                          child: _betterPlayerController.isBuffering()!
                              ? const CircularProgressIndicator()
                              : null,
                        ),
                        _playAndPauseButtom(),
                        VideoCoreForwardAndRewind(
                          onRightTap: () => onForward(_betterPlayerController),
                          onLeftTap: () => onRewind(_betterPlayerController),
                          forwardSeconds: 10,
                          rewindSeconds: 10,
                          showForward: showForward,
                          showRewind: showRewind,
                          responsive: responsive,
                        ),
                        _customVideoTopBar(size, context, textStyle),
                        if (_betterPlayerController
                            .videoPlayerController!.value.initialized)
                          Positioned(
                            bottom: 0,
                            child: _bottomVideoBar(size, textStyle),
                          )
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  CustomOpacityTransition _customVideoTopBar(
      Size size, BuildContext context, TextTheme textStyle) {
    return CustomOpacityTransition(
      visible: isVisible,
      child: Container(
          color: Colors.black45,
          width: size.width,
          child: ListTile(
            title: Text(
              title,
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              chapterInfo,
              style: const TextStyle(color: Colors.white),
            ),
            leading: IconButton(
                onPressed: () {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

                  isClose = true;
                  setState(() {});
                  context.pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            trailing: TextButton(
                onPressed: () {
                  _showQualitiesSelectionWidget();
                },
                child: Text(
                  serverName.value,
                  style: textStyle.labelMedium?.copyWith(
                    color: Colors.white,
                  ),
                )),
          )),
    );
  }

  Center _playAndPauseButtom() {
    return Center(
      child: isVisible
          ? CenterPlayButton(
              backgroundColor: Colors.black45,
              iconColor: Colors.white,
              isFinished: false,
              isPlaying: _betterPlayerController.isPlaying()!,
              show: isVisible,
              onPressed: _betterPlayerController.isPlaying()!
                  ? () {
                      _betterPlayerController.pause();
                      isPause = true;
                      setState(() {});
                    }
                  : () {
                      _betterPlayerController.play();
                      isPause = false;
                      showControls();
                      setState(() {});
                    },
            )
          : null,
    );
  }

  CustomOpacityTransition _bottomVideoBar(Size size, TextTheme textStyle) {
    return CustomOpacityTransition(
      visible: isVisible,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: size.width,
        height: 90,
        color: Colors.black45,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      // TODO: Set video fit
                    },
                    icon: const Icon(
                      Icons.fit_screen,
                      color: Colors.white,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () => skipOp(_betterPlayerController),
                    icon: const Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () => skipOp(_betterPlayerController),
                    icon: const Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: 30,
                    )),
                TextButton(
                    onPressed: () => skipOp(_betterPlayerController),
                    child: const Text(
                      '+85',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomSlider(
                    secondaryTrackValue: _betterPlayerController
                        .videoPlayerController!
                        .value
                        .buffered
                        .last
                        .end
                        .inSeconds
                        .toDouble(),
                    value: _betterPlayerController
                        .videoPlayerController!.value.position.inSeconds
                        .toDouble(),
                    max: _betterPlayerController
                        .videoPlayerController!.value.duration!.inSeconds
                        .toDouble(),
                    onChanged: (value) {
                      setState(() {
                        _betterPlayerController
                            .seekTo(Duration(seconds: value.toInt()));
                      });
                    },
                    onChangeEnd: (value) => onChangeEnd(),
                    onChangeStart: (value) => onChangeStart(),
                    duration: _betterPlayerController
                        .videoPlayerController!.value.position,
                  ),
                ),
                CustomOpacityTransition(
                  visible: isVisible,
                  child: Text(
                    '${formatDuration(_betterPlayerController.videoPlayerController!.value.position.inSeconds)} - ${formatDuration(_betterPlayerController.videoPlayerController!.value.duration!.inSeconds)}',
                    style: textStyle.labelMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showQualitiesSelectionWidget() {
    // HLS / DASH
    final List<String> asmsTrackNames =
        _betterPlayerController.betterPlayerDataSource!.asmsTrackNames ?? [];
    final List<BetterPlayerAsmsTrack> asmsTracks =
        _betterPlayerController.betterPlayerAsmsTracks;
    final List<Widget> children = [];
    for (var index = 0; index < asmsTracks.length; index++) {
      final track = asmsTracks[index];

      String? preferredName;
      if (track.height == 0 && track.width == 0 && track.bitrate == 0) {
        preferredName = _betterPlayerController.translations.qualityAuto;
      } else {
        preferredName =
            asmsTrackNames.length > index ? asmsTrackNames[index] : null;
      }
      children.add(_buildTrackRow(asmsTracks[index], preferredName));
    }

    // normal videos
    final resolutions =
        _betterPlayerController.betterPlayerDataSource!.resolutions;
    resolutions?.forEach((key, value) {
      children.add(_buildResolutionSelectionRow(key, value));
    });

    if (children.isEmpty) {
      children.add(
        _buildTrackRow(BetterPlayerAsmsTrack.defaultTrack(),
            _betterPlayerController.translations.qualityAuto),
      );
    }

    _showModalBottomSheet(children);
  }

  Widget _buildTrackRow(BetterPlayerAsmsTrack track, String? preferredName) {
    final int width = track.width ?? 0;
    final int height = track.height ?? 0;
    final String mimeType = (track.mimeType ?? '').replaceAll('video/', '');
    final String trackName = preferredName ?? "${width}x$height $mimeType";

    final BetterPlayerAsmsTrack? selectedTrack =
        _betterPlayerController.betterPlayerAsmsTrack;
    final bool isSelected = selectedTrack != null && selectedTrack == track;

    return BetterPlayerMaterialClickableWidget(
      onTap: () {
        Navigator.of(context).pop();
        _betterPlayerController.setTrack(track);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            SizedBox(width: isSelected ? 8 : 16),
            Visibility(
                visible: isSelected,
                child: Icon(
                  Icons.check_outlined,
                  color: _betterPlayerController
                      .betterPlayerControlsConfiguration.overflowModalTextColor,
                )),
            const SizedBox(width: 16),
            Text(
              trackName,
              style: _getOverflowMenuElementTextStyle(isSelected),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _getOverflowMenuElementTextStyle(bool isSelected) {
    return TextStyle(
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      color: isSelected
          ? _betterPlayerController
              .betterPlayerControlsConfiguration.overflowModalTextColor
          : _betterPlayerController
              .betterPlayerControlsConfiguration.overflowModalTextColor
              .withOpacity(0.7),
    );
  }

  Widget _buildResolutionSelectionRow(String name, String url) {
    final bool isSelected =
        url == _betterPlayerController.betterPlayerDataSource!.url;
    return BetterPlayerMaterialClickableWidget(
      onTap: () {
        Navigator.of(context).pop();
        _betterPlayerController.setResolution(url);
        serverName.value = name;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            SizedBox(width: isSelected ? 8 : 16),
            Visibility(
                visible: isSelected,
                child: Icon(
                  Icons.check_outlined,
                  color: _betterPlayerController
                      .betterPlayerControlsConfiguration.overflowModalTextColor,
                )),
            const SizedBox(width: 16),
            Text(
              name,
              style: _getOverflowMenuElementTextStyle(isSelected),
            ),
          ],
        ),
      ),
    );
  }

  void _showModalBottomSheet(List<Widget> children) {
    Platform.isAndroid
        ? _showMaterialBottomSheet(children)
        : _showCupertinoModalBottomSheet(children);
  }

  void _showCupertinoModalBottomSheet(List<Widget> children) {
    showCupertinoModalPopup<void>(
      barrierColor: Colors.transparent,
      context: context,
      useRootNavigator:
          _betterPlayerController.betterPlayerConfiguration.useRootNavigator,
      builder: (context) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: _betterPlayerController
                    .betterPlayerControlsConfiguration.overflowModalColor,
                /*shape: RoundedRectangleBorder(side: Bor,borderRadius: 24,)*/
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0)),
              ),
              child: Column(
                children: children,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showMaterialBottomSheet(List<Widget> children) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      useRootNavigator:
          _betterPlayerController.betterPlayerConfiguration.useRootNavigator,
      builder: (context) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: _betterPlayerController
                    .betterPlayerControlsConfiguration.overflowModalColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0)),
              ),
              child: Column(
                children: children,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }
}

class CustomSlider extends StatelessWidget {
  const CustomSlider(
      {super.key,
      required this.value,
      required this.max,
      required this.secondaryTrackValue,
      this.onChanged,
      this.onChangeStart,
      this.onChangeEnd,
      required this.duration});

  final double value;
  final double secondaryTrackValue;
  final double max;
  final void Function(double)? onChanged;
  final void Function(double)? onChangeStart;
  final void Function(double)? onChangeEnd;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return SizedBox(
      // alignment: Alignment.center,
      // width: size.width,
      height: 25,
      child: Slider(
        secondaryTrackValue: secondaryTrackValue,
        onChangeEnd: onChangeEnd,
        onChangeStart: onChangeStart,
        activeColor: color.primary,
        value: value,
        onChanged: onChanged,
        max: max,
        label: formatDuration(duration.inSeconds),
      ),
    );
  }
}

String formatDuration(int seconds) {
  Duration duration = Duration(seconds: seconds);

  int hours = duration.inHours;
  int minutes = (duration.inMinutes % 60);
  int remainingSeconds = (duration.inSeconds % 60);

  String hoursStr = (hours < 10) ? '0$hours' : '$hours';
  String minutesStr = (minutes < 10) ? '0$minutes' : '$minutes';
  String secondsStr =
      (remainingSeconds < 10) ? '0$remainingSeconds' : '$remainingSeconds';

  if (hoursStr != '00') return '$hoursStr:$minutesStr:$secondsStr';

  return '$minutesStr:$secondsStr';
}

class BetterPlayerMaterialClickableWidget extends StatelessWidget {
  final Widget child;
  final void Function() onTap;

  const BetterPlayerMaterialClickableWidget({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
      ),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
