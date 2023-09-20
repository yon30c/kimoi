import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/UI/screens/loading/full_loading_screen.dart';
import 'package:kimoi/src/UI/services/delegates/search_delegate.dart';
import 'package:kimoi/src/utils/updater/updater.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/domain.dart';
import '../../providers/providers.dart';
import '../../views/views.dart';

class HomeAnime extends ConsumerStatefulWidget {
  static const String name = 'Home-screen';

  const HomeAnime({super.key});

  @override
  HomeAnimeState createState() => HomeAnimeState();
}

class HomeAnimeState extends ConsumerState<HomeAnime> {
  List<Anime> shounenAnime = [];
  List<Anime> accionAnime = [];

  @override
  void initState() {
    super.initState();
    ref.read(lastAnimesAddedProvider.notifier).getAnimes();
    ref.read(recentAnimesProvider.notifier).getAnimes();
  }

  void onPressed() async {
    await showSearch(
            context: context,
            delegate: SearchAnimeDelegate(
                searchAnimes:
                    ref.watch(searchedMoviesProvider.notifier).searchAnimes))
        .then((value) {
      if (value == null) return;
      ref.read(animeProvider.notifier).update((state) => value);
      context.push('/anime-screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    final lastAnimes = ref.watch(lastAnimesAddedProvider);
    final lastEpisodes = ref.watch(recentAnimesProvider);

    // final popularNews = ref.watch(popularNewsProvider);

    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth > 600) {
        return FadeIn(
            child: const Scaffold(
                body: Center(child: CircularProgressIndicator())));
      }

      if (lastAnimes.isEmpty || lastEpisodes.isEmpty) {
        return const Scaffold(body: FullScreenLoader());
      }

      return FadeIn(
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async =>
                await ref.read(recentAnimesProvider.notifier).getAnimes(),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  title: const Text('Animes'),
                  actions: [
                    IconButton(
                        onPressed: () => showGeneralDialog(
                              context: context,
                              pageBuilder: (context, __, ___) =>
                                  const _AboutDialog(),
                            ),
                        icon: const Icon(Icons.info)),
                    IconButton(
                        onPressed: onPressed,
                        icon: const Icon(Icons.search, size: 30))
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(
                        height: 10,
                      ),
                      RandomListView(
                        animes: lastAnimes,
                      ),
                      AnimesView(
                        animes: lastEpisodes,
                        title: 'Últimos episodios',
                      ),
                      AnimesListview(
                        height: 180,
                        width: 130,
                        animes: lastAnimes,
                        title: 'Últimos animes',
                        subtitle: '2023',
                      ),
                      // AnimesListview(
                      //     genre: GenresTab(
                      //       iconPath: null,
                      //       name: 'Acción',
                      //       id: 'accion',
                      //       title: 'ACCIÓN',
                      //       imagePath: 'assets/images/acc-ani.jpeg',
                      //       icon: FontAwesomeIcons.fire,
                      //     ),
                      //     subtitle: 'Ver más',
                      //     height: 180,
                      //     width: 130,
                      //     animes: accionAnime,
                      //     title: 'Accion',
                      //     loadNextPage: ref
                      //         .read(lastAnimesAddedProvider.notifier)
                      //         .getAnimes),
                      // AnimesListview(
                      //     genre: GenresTab(
                      //         iconPath: null,
                      //         name: 'Shounen',
                      //         id: 'shonen',
                      //         title: 'SHOUNEN',
                      //         imagePath: 'assets/images/shoune-ani2.jpeg',
                      //         icon: FontAwesomeIcons.gamepad),
                      //     subtitle: 'Ver más',
                      //     height: 180,
                      //     width: 130,
                      //     animes: shounenAnime,
                      //     title: 'Shounen',
                      //     loadNextPage: ref
                      //         .read(lastAnimesAddedProvider.notifier)
                      //         .getAnimes),
                      const SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _AboutDialog extends StatefulWidget {
  const _AboutDialog({super.key});

  @override
  State<_AboutDialog> createState() => __AboutDialogState();
}

class __AboutDialogState extends State<_AboutDialog> {
  late UpdaterController controller;
  late Updater updater;

  final Uri newFeatures =
      Uri.parse('https://github.com/yon30c/kimoi_updater/releases/tag/v1.2.1');

  final Uri discordUrl = Uri.parse('https://discord.gg/FZjCttmF');

  final Uri paypal = Uri.parse('https://www.paypal.me/Yon30c');

  void initializeUpdater() {
    controller = UpdaterController(
      listener: (UpdateStatus status) {
        debugPrint('Listener: $status');
      },
      onChecked: (bool isAvailable) {
        debugPrint('$isAvailable');
      },
      progress: (current, total) {
        // debugPrint('Progress: $current -- $total');
      },
      onError: (status) {
        debugPrint('Error: $status');
      },
    );

    updater = Updater(
      context: context,

      delay: const Duration(milliseconds: 300),

      url:
          'https://raw.githubusercontent.com/yon30c/kimoi_updater/main/updater.json',
      titleText: 'Actualización disponible',
      // backgroundDownload: false,
      allowSkip: false,
      contentText:
          'Actualice su aplicación a la última versión para disfrutar de nuevas funciones.',
      callBack: (UpdateModel model) {
        debugPrint(model.versionName);
        debugPrint(model.versionCode.toString());
        debugPrint(model.contentText);
      },
      confirmText: 'Descargar',
      enableResume: true,
      controller: controller,
    );
  }

  Future<bool> checkUpdate() async {
    bool isAvailable = await updater.check();

    debugPrint('$isAvailable');

    return isAvailable;
    // controller.pause();
    // controller.resume();
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    super.initState();
    initializeUpdater();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(15)),
          const Center(
              child: CircleAvatar(
            backgroundImage: AssetImage(
              'assets/app_icon_rounded.webp',
            ),
            radius: 50,
          )),
          const ListTile(
            title: Text('Versión'),
            subtitle: Text('stable: 1.2.1'),
          ),
          ListTile(
            title: const Text('Buscar actualizaciones'),
            onTap: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Buscando actualizaciones')));
              await checkUpdate().then((value) {
                if (!value) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('No se encontraron actualizaciones')));
                }
              });
            },
          ),
          ListTile(
            title: const Text('Que hay de nuevo'),
            onTap: () => _launchUrl(newFeatures),
          ),
          const ListTile(
            title: Text('Política de privacidad'),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () => _launchUrl(discordUrl),
                  icon: Icon(
                    Icons.discord,
                    size: 30,
                    color: color.primary,
                  )),
              IconButton(
                  onPressed: () => _launchUrl(newFeatures),
                  icon: FaIcon(
                    FontAwesomeIcons.github,
                    size: 30,
                    color: color.primary,
                  )),
              IconButton(
                  onPressed: () => _launchUrl(paypal),
                  icon: FaIcon(
                    FontAwesomeIcons.paypal,
                    size: 30,
                    color: color.primary,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
