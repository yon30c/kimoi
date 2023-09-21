import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kimoi/src/utils/updater/updater.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CsAboutDialog extends StatefulWidget {
  const CsAboutDialog({super.key});

  @override
  State<CsAboutDialog> createState() => _CsAboutDialogState();
}

class _CsAboutDialogState extends State<CsAboutDialog> {
  late UpdaterController controller;
  late Updater updater;

  final version = dotenv.env['versionName'];
  final paypalUrl = dotenv.env['paypal'];
  final github = dotenv.env['github'];
  final discord = dotenv.env['discord'];
  final release = dotenv.env['release'];

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

    final Uri paypal = Uri.parse(paypalUrl!);
    final Uri githubUrl = Uri.parse(github!);
    final Uri newrelease = Uri.parse(release!);
    final Uri discordUrl = Uri.parse(discord!);

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
          ListTile(
            title: const Text('Versión'),
            subtitle: Text('$version'),
          ),
          ListTile(
            title: const Text('Buscar actualizaciones'),
            onTap: () async {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Buscando actualizaciones'),
                duration: Duration(seconds: 2),
              ));
              await checkUpdate().then((value) {
                if (!value) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('No se encontraron actualizaciones'),
                    showCloseIcon: true,
                  ));
                }
              });
            },
          ),
          ListTile(
            title: const Text('Que hay de nuevo'),
            onTap: () => _launchUrl(newrelease),
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
                  onPressed: () => _launchUrl(githubUrl),
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
