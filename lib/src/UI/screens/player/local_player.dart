import 'dart:async';
import 'dart:math';

import 'package:better_player_v3/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/items/forward_and_rewind.dart';
import 'package:kimoi/src/UI/items/servers_dialog.dart';
import 'package:kimoi/src/UI/items/transitions.dart';
import 'package:kimoi/src/UI/providers/animes/next_and_before_anime_provider.dart';
import 'package:kimoi/src/UI/providers/storage/watching_provider.dart';
import 'package:kimoi/src/UI/screens/player/center_play_button.dart';
import 'package:kimoi/src/infrastructure/models/video.dart' as v;
import 'package:kimoi/src/utils/extensions/extension.dart';
import 'package:kimoi/src/utils/helpers/responsive.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../domain/domain.dart';

class LocalPlayer extends ConsumerStatefulWidget {
  const LocalPlayer({super.key, required this.videos});

  final Chapter videos;

  @override
  LocalPlayerState createState() => LocalPlayerState();
}

class LocalPlayerState extends ConsumerState<LocalPlayer> {
  // ********************************************************** //
  // *------------------ VARIABLES ---------------------------* //
  // ********************************************************** //

  late BetterPlayerController _betterPlayerController;
  var channel = const MethodChannel("extractors");

  List<v.Video> videoList = [];

  bool flag = false;
  bool isChanging = false;
  bool isClose = false;
  bool isCompleted = false;
  bool isInitialize = false;
  bool isPause = false;
  bool isVisible = false;
  bool showForward = false;
  bool showRewind = false;

  String chapterInfo = '';
  String title = '';

  ValueNotifier<String> serverName = ValueNotifier('');
  ValueNotifier<String> chapterName = ValueNotifier('');

  final responsive = Responsive();

  // ********************************************************** //

  // ********************************************************** //
  // *--- INICIALIZAR Y CONTROLAR EL REPRODUCTOR DE VIDEO ----* //
  // ********************************************************** //

  //* inicializar el reproductor del video *//
  void initPlayer(Chapter chapter) async {
    final videoList = await ref.read(videoServers);
    final url = ref.read(fixedServerProvider)!.optional!;
    final optional = await extract(url);

    print(videoList.first.headers);

    isClose = false;
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
            startAt: Duration(seconds: widget.videos.position),
            allowedScreenSleep: false,
            aspectRatio: 16 / 9,
            fit: BoxFit.contain,
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
    chapterName.value = widget.videos.chapter;

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

    _betterPlayerController.addEventsListener((BetterPlayerEvent event) {
      setState(() {
        if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
          serverName.value = optional.last.quality;

          _betterPlayerController =
              BetterPlayerController(betterPlayerConfiguration);

          _betterPlayerController.setupDataSource(BetterPlayerDataSource(
              BetterPlayerDataSourceType.network, optional.first.videoUrl!,
              headers: optional.first.headers, resolutions: resolutions));
        }
      });

      if (isClose) return;
      if (_betterPlayerController.isPlaying()!) {
        addOnWatching(
            _betterPlayerController
                .videoPlayerController!.value.position.inSeconds,
            _betterPlayerController
                .videoPlayerController!.value.duration!.inSeconds);

        //* Agregar duracion.
        if (isInitialize && _betterPlayerController.isPlaying()!) {
          if (flag) return;
          flag = true;
          setState(() {});
          final chapter = widget.videos;
          chapter.date = DateTime.now();
          chapter.duration = _betterPlayerController
              .videoPlayerController!.value.duration!.inSeconds;
          ref
              .read(isWatchingAnimeProvider.notifier)
              .addOnWatching(widget.videos);
        }
      }
    });

    WakelockPlus.enable();

    autoHide();
  }

  //* Guardar videos reproducidos en el historial
  void addOnWatching(int position, int duration) async {
    final chapter = widget.videos;
    chapter.position = position;
    if (position % 5 == 0) {
      await ref.read(isWatchingAnimeProvider.notifier).addOnWatching(chapter);
    }

    if (isCompleted) return;
    if ((position) >= (duration - 240)) {
      chapter.isCompleted = true;
      chapter.isWatching = false;
      await ref.read(isWatchingAnimeProvider.notifier).addOnWatching(chapter);
      isCompleted = true;
      setState(() {});
    }
  }

  //* Para adelantar el video 85 segundos ("01:25")
  //* El adecuado para adelantar opening.
  void skipOp(BetterPlayerController controller) async {
    final latestValue = controller.videoPlayerController?.value;
    if (latestValue != null) {
      final end = latestValue.duration!.inSeconds;
      final skip =
          (latestValue.position + const Duration(seconds: 85)).inSeconds;
      controller.seekTo(Duration(seconds: min(skip, end)));
    }
    setState(() {});
  }

  //* Se activa cuando el slider del video esta cambiando
  //* para evitar que los controles se oculten mientrase se este cambiando
  onChangeStart() {
    if (!isChanging) {
      setState(() {
        isChanging = true;
        isVisible = true;
      });
    }
  }

  //* Cuando el slider deja de cambiar, desactiva los botones despues de el tiempo establecido
  onChangeEnd() async {
    isChanging = false;
    await Future.delayed(const Duration(milliseconds: 300));
    if (!isPause) setState(() => isVisible = false);
  }

  //* Para ocultar los botones automaticamente
  void autoHide() async {
    showControls();
    await Future.delayed(const Duration(seconds: 2));
    if (!isChanging && !isPause && !isClose) hideControls();
  }

  //* Para mostrar controles
  void showControls() {
    if (!isVisible) setState(() => isVisible = true);
  }

  //* Para ocultar controles
  void hideControls() {
    if (isVisible) setState(() => isVisible = false);
  }

  //* Para regresar 10 segundos
  void onRewind(BetterPlayerController controller) async {
    showRewind = true;
    setState(() {});
    final latestValue = controller.videoPlayerController?.value;
    if (latestValue != null) {
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

  //* Para adelantar 10 segundos
  void onForward(BetterPlayerController controller) async {
    showForward = true;
    setState(() {});
    final latestValue = controller.videoPlayerController?.value;
    if (latestValue != null) {
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

  //* Para obtener los videos
  Future<List<v.Video>> getVideos(Chapter chapter) async {
    final List<v.Video> vidList = [];
    for (var serv in chapter.servers.reversed) {
      final video = v.Video.fromRawJson(serv);

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

    return vidList;
  }

  // ********************************************************** //

  // ********************************************************** //
  // *----- COMPORTAMIENTO AL REGRESAR MEDIANTE GESTOS -------* //
  // ********************************************************** //

  //* Administrar el comportamiento al salir de la pantalla
  //* usando gestos o botones del hardware
  Future<bool> onWillPop() async {
    ref.refresh(watchingHistoryProvider.notifier).loadNextPage();
    setState(() {});
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    WakelockPlus.disable();
    return true;
  }

  // ********************************************************** //

  // ********************************************************** //
  // *-----------  ESTADO INICIAR Y METODO BUILD  ------------* //
  // ********************************************************** //

  @override
  void initState() {
    super.initState();

    chapterInfo = widget.videos.chapter;
    title = widget.videos.title;
    //* Bloquea la pantalla para que no se apague automaticamente

    // Preferencias de pantalla
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Inicializar el reproductor de video
    initPlayer(widget.videos);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    responsive.setDimensions(size.width, size.height);


    // ********************************************************** //
    // *-----  OBTENER EL SIGUIENTE Y EL ANTERIOR VIDEO  -------* //
    // ********************************************************** //
    String actualChapterUrl = widget.videos.chapterUrl;

    int chap = widget.videos.chapterNumber + 1;
    int chap2 = widget.videos.chapterNumber - 1;
    final url = actualChapterUrl.substringBeforeLast('-');

    String backChapterUrl = '$url-$chap2';
    String nextChapterUrl = '$url-$chap';

    AsyncValue<Chapter?> previusChapter =
        ref.watch(previousChapterProvider(backChapterUrl));
    AsyncValue<Chapter?> nextChapter =
        ref.watch(nextChapterProvider(nextChapterUrl));

    // ********************************************************** //
    // ********************************************************** //

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: !isVisible ? autoHide : hideControls,
          child: Center(
            child: !isInitialize
                //* Mostrar carga de pantalla si el reproductor no esta inicializado
                ? Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                // Reproductor de video
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
                            child: CustomOpacityTransition(
                              visible: isVisible,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: size.width,
                                height: 90,
                                color: Colors.black45,
                                child: !isVisible
                                    ? null
                                    : Column(
                                        children: [
                                          _videoButtomBarControls(
                                              previusChapter,
                                              context,
                                              nextChapter),
                                          _videoSliderBar(textStyle),
                                        ],
                                      ),
                              ),
                            ))
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Row _videoSliderBar(TextTheme textStyle) {
    return Row(
      children: [
        Expanded(
          child: CustomSlider(
            secondaryTrackValue: _betterPlayerController
                .videoPlayerController!.value.buffered.last.end.inSeconds
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
            duration:
                _betterPlayerController.videoPlayerController!.value.position,
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
    );
  }

  // ********************************************************** //
  // *--------------- WIDGETS DEL REPRODUCTOR  --------------- *//
  // ********************************************************** //

  // Barra de controles inferior
  Row _videoButtomBarControls(AsyncValue<Chapter?> previusChapter,
      BuildContext context, AsyncValue<Chapter?> nextChapter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              final fit = _betterPlayerController.getFit();
              switch (fit) {
                case BoxFit.contain:
                  _betterPlayerController.setOverriddenFit(BoxFit.fill);
                  setState(() {});
                  break;
                case BoxFit.fill:
                  _betterPlayerController.setOverriddenFit(BoxFit.contain);
                  setState(() {});
                  break;

                default:
              }
            },
            icon: _betterPlayerController.getFit() == BoxFit.fill
                ? const Icon(
                    Icons.fit_screen_rounded,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.fit_screen_outlined,
                    color: Colors.white,
                  )),
        IconButton(
            onPressed: previusChapter.when(
              data: (data) {
                if (data == null) return null;
                return () {
                  isClose = true;
                  _betterPlayerController.dispose();
                  data.imageUrl = widget.videos.imageUrl;
                  data.animeUrl = widget.videos.animeUrl;
                  data.isWatching = true;
                  ref.read(chapterProvider.notifier).update((state) => data);
                  // ref.read(videoProvider.notifier).getVideos();
                  context.pushReplacement('/local-player', extra: data);
                };
              },
              error: (error, stackTrace) {
                return null;
              },
              loading: () => null,
            ),
            icon: previusChapter.when(
              data: (data) {
                if (data == null) {
                  return const Icon(
                    Icons.skip_previous_rounded,
                    color: Colors.grey,
                    size: 30,
                  );
                }
                return const Icon(
                  Icons.skip_previous_rounded,
                  color: Colors.white,
                  size: 30,
                );
              },
              error: (error, stackTrace) => const Icon(Icons.error),
              loading: () => const SizedBox(
                  height: 30, width: 30, child: CircularProgressIndicator()),
            )),
        IconButton(
            onPressed: nextChapter.when(
              data: (data) {
                if (data == null) return null;
                return () {
                  isClose = true;
                  _betterPlayerController.dispose();
                  data.imageUrl = widget.videos.imageUrl;
                  data.animeUrl = widget.videos.animeUrl;
                  data.isWatching = true;
                  ref.read(chapterProvider.notifier).update((state) => data);
                  // ref.read(videoProvider.notifier).getVideos();
                  context.pushReplacement('/local-player', extra: data);
                };
              },
              error: (error, stackTrace) {
                return null;
              },
              loading: () => null,
            ),
            icon: nextChapter.when(
              data: (data) {
                if (data == null) {
                  return const Icon(Icons.skip_next_rounded,
                      color: Colors.grey, size: 30);
                }
                return const Icon(
                  Icons.skip_next_rounded,
                  color: Colors.white,
                  size: 30,
                );
              },
              error: (error, stackTrace) => const Icon(Icons.error),
              loading: () => const SizedBox(
                  height: 30, width: 30, child: CircularProgressIndicator()),
            )),
        TextButton(
            onPressed: () => skipOp(_betterPlayerController),
            child: const Text(
              '+85',
              style: TextStyle(color: Colors.white, fontSize: 18),
            )),
      ],
    );
  }

  // Barra superior
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
              chapterName.value,
              style: const TextStyle(color: Colors.white),
            ),
            leading: IconButton(
                onPressed: () {
                  ref.refresh(watchingHistoryProvider.notifier).loadNextPage();
                  setState(() {});
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
                  WakelockPlus.disable();

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

  // Controles de reproducir y pausar
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
                      autoHide();
                      setState(() {});
                    },
            )
          : null,
    );
  }

  // ********************************************************** //
  // ********************************************************** //

  // ********************************************************* //
  // * --- FUNCIONES DE LAS BARRA DE CONTROLES SUPERIOR  --- * //
  // ********************************************************* //

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

    _showMaterialBottomSheet(children);
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

  // ********************************************************** //
  // ********************************************************** //

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }
}

// Slider personalizado
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

// Para convertir los segundos del reporductor
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
