// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/main.dart';
import 'package:kimoi/src/config/theme/theme.dart';
import 'package:kimoi/src/utils/updater/updater.dart';
import 'package:url_launcher/url_launcher.dart';

enum Routes { Noticias, Animes, Listas, Explorar }

Routes getIniL() {
  return switch (routerController.initialLocation) {
    "/" => Routes.Noticias,
    "/anime" => Routes.Animes,
    "/favorite" => Routes.Listas,
    "/explorar" => Routes.Explorar,
    String() => Routes.Noticias,
  };
}

class HomeSettings extends StatefulWidget {
  static const String name = 'settings-screen';

  const HomeSettings({super.key});

  @override
  State<HomeSettings> createState() => _HomeSettingsState();
}

class _HomeSettingsState extends State<HomeSettings> {
  late UpdaterController controller;
  late Updater updater;

  final version = dotenv.env['versionName'];
  final paypalUrl = dotenv.env['paypal'];
  final github = dotenv.env['github'];
  final discord = dotenv.env['discord'];
  final release = dotenv.env['release'];
  final politica = dotenv.env['politica'];

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
        allowSkip: true,
        contentText:
            'Actualice su aplicación a la última versión para disfrutar de nuevas funciones.',
        callBack: (UpdateModel model) {},
        confirmText: 'Descargar',
        controller: controller,
        cancelText: 'Más tarde');
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

  String loc = routerController.initialLocation;

  @override
  void initState() {
    super.initState();
    initializeUpdater();
    routerController.addListener(() {
      setState(() {});
    });
    themeController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    routerController.dispose();
    themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Uri paypal = Uri.parse(paypalUrl!);
    final Uri githubUrl = Uri.parse(github!);
    final Uri newrelease = Uri.parse(release!);
    final Uri telegram = Uri.parse(discord!);
    final Uri politicaUrl = Uri.parse(politica!);

    String fLocation = switch (routerController.initialLocation) {
      "/" => "Noticias",
      "/anime" => "Animes",
      "/favorite" => "Mis Listas",
      "/explorar" => "Explorar",
      String() => "Noticias",
    };

    String themeMode = switch (themeController.themeMode) {
      ThemeMode.system => "Sistema",
      ThemeMode.dark => "Activado",
      ThemeMode.light => "Desactivado"
    };

    final textStyle = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Más'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
                child: CircleAvatar(
              backgroundImage: AssetImage(
                'assets/app_icon_rounded.webp',
              ),
              radius: 50,
            )),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () => _launchUrl(telegram),
                    icon: FaIcon(
                      FontAwesomeIcons.telegram,
                      size: 30,
                      color: color.onPrimaryContainer,
                    )),
                IconButton(
                    onPressed: () => _launchUrl(githubUrl),
                    icon: FaIcon(
                      FontAwesomeIcons.github,
                      size: 30,
                      color: color.onPrimaryContainer,
                    )),
                IconButton(
                    onPressed: () => _launchUrl(paypal),
                    icon: FaIcon(
                      FontAwesomeIcons.paypal,
                      size: 30,
                      color: color.onPrimaryContainer,
                    )),
              ],
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                width: double.infinity,
                child: Text('Ajustes',
                    style:
                        textStyle.titleMedium?.copyWith(color: color.primary))),
            ListTile(
              visualDensity: VisualDensity.compact,
              title: const Text('Pantalla inicial'),
              subtitle: Text(fLocation),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => const InitialPageDialog());
              },
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              title: const Text('Tema oscuro'),
              subtitle: Text(themeMode),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => const ThemeModeDialog());
              },
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              title: const Text('Color de tema'),
              subtitle: Row(
                children: [
                  Container(width: 30, height: 10 , decoration: BoxDecoration(
                  color: themeController.selectedColor,
                  borderRadius: BorderRadius.circular(2,))),
                  const SizedBox(width: 8,),
                  Text(switch (themeController.selectedColor) {
                        Colors.blue => "Azul",
                        Colors.redAccent => "Rojo",
                        const Color.fromRGBO(46, 125, 50, 1) => "Verde",
                        Colors.deepPurple => "Purpura",
                        Color() => "", 
                  }, style: textStyle.labelMedium?.copyWith(color: themeController.selectedColor),),
                  const SizedBox(width: 8,),
                  Container(width: 30, height: 10 , 
                   decoration: BoxDecoration(
                  color: themeController.selectedColor,
                  borderRadius: BorderRadius.circular(2)

                  ),),
                ],
              ),
              onTap: () {
                showDialog(context: context, builder: (context) => const ColorThemeDialog(),);
              },
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                width: double.infinity,
                child: Text('Acerca de',
                    style:
                        textStyle.titleMedium?.copyWith(color: color.primary))),
            ListTile(
              visualDensity: VisualDensity.compact,
              title: const Text('¿Que hay de nuevo?'),
              onTap: () => _launchUrl(newrelease),
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              title: const Text('Política de privacidad'),
              onTap: () => _launchUrl(politicaUrl),
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              title: const Text('Buscar actualizaciones'),
              onTap: () async {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Buscando actualizaciones'),
                  duration: Duration(seconds: 2),
                ));
                await checkUpdate().then((value) {
                  if (!value) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Tu app esta actualizada'),
                      showCloseIcon: true,
                    ));
                  }
                });
              },
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              title: const Text('Versión'),
              subtitle: Text('$version'),
            ),
          ],
        ),
      ),
    );
  }
}

class InitialPageDialog extends StatefulWidget {
  const InitialPageDialog({
    super.key,
  });

  @override
  State<InitialPageDialog> createState() => _InitialPageDialogState();
}

class _InitialPageDialogState extends State<InitialPageDialog> {
  Routes? initialRoute;

  @override
  void initState() {
    super.initState();
    initialRoute = getIniL();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.only(left: 15, top: 5),
      title: const Text("Pantalla inicial"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: Routes.values
            .map((e) => RadioListTile<Routes>(
                visualDensity: VisualDensity.compact,
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                title: Text(e.name),
                groupValue: initialRoute,
                value: e,
                onChanged: (value) async {
                  await routerController
                      .updateInitialLocation(e.name)
                      .then((value) {
                    initialRoute = e;
                    setState(() {});
                    context.pop();
                  });
                }))
            .toList(),
      ),
      actions: [
        TextButton(
            onPressed: () => context.pop(), child: const Text("Cancelar"))
      ],
    );
  }
}

class ThemeModeDialog extends StatefulWidget {
  const ThemeModeDialog({
    super.key,
  });

  @override
  State<ThemeModeDialog> createState() => _ThemeModeDialogState();
}

class _ThemeModeDialogState extends State<ThemeModeDialog> {
  ThemeMode themeMode = themeController.themeMode;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.only(left: 15, top: 5),
      title: const Text("Tema oscuro"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        RadioListTile<ThemeMode>(
            visualDensity: VisualDensity.compact,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            title: const Text("Activado"),
            groupValue: themeMode,
            value: ThemeMode.dark,
            onChanged: (value) async {
              themeMode = value!;
              setState(() {});
              await themeController.updateThemeMode(value).then((value) {
                context.pop();
              });
            }),
        RadioListTile<ThemeMode>(
            visualDensity: VisualDensity.compact,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            title: const Text("Sistema"),
            groupValue: themeMode,
            value: ThemeMode.system,
            onChanged: (value) async {
              themeMode = value!;
              setState(() {});
              await themeController.updateThemeMode(value).then((value) {
                context.pop();
              });
            }),
        RadioListTile<ThemeMode>(
            visualDensity: VisualDensity.compact,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            title: const Text("Desactivado"),
            groupValue: themeMode,
            value: ThemeMode.light,
            onChanged: (value) async {
              themeMode = value!;
              setState(() {});
              await themeController.updateThemeMode(value).then((value) {
                context.pop();
              });
            }),
      ]),
      actions: [
        TextButton(
            onPressed: () => context.pop(), child: const Text("Cancelar"))
      ],
    );
  }
}



class ColorThemeDialog extends StatefulWidget {
  const ColorThemeDialog({
    super.key,
  });

  @override
  State<ColorThemeDialog> createState() => _ColorThemeDialogState();
}

class _ColorThemeDialogState extends State<ColorThemeDialog> {
  Color themeMode = themeController.selectedColor;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.only(left: 15, top: 5),
      title: const Text("Color de tema"),
      content: Column(mainAxisSize: MainAxisSize.min, children: 
      colors
            .map((e) => RadioListTile<Color>(
                visualDensity: VisualDensity.compact,
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                activeColor: e,
                title:  Row(
                children: [
                  Text(switch (e) {
                        Colors.blue => "Azul",
                        Colors.redAccent => "Rojo",
                        Colors.deepPurple => "Purpura",
                        const Color.fromRGBO(46, 125, 50, 1) => "Verde",
                        Color() => "", 
                  }),
                  const Spacer(),
                  Icon( Icons.circle, color: e),

                  const SizedBox(width: 20,)
                  
                ],
              ),
                groupValue: themeMode,
                value: e,
                onChanged: (value) async {
                  await themeController.updateSelectedColor(e)
                      .then((value) {
                    themeMode = e;
                    setState(() {});
                    context.pop();
                  });
                }))
            .toList(),
      
      ),
      actions: [
        TextButton(
            onPressed: () => context.pop(), child: const Text("Cancelar"))
      ],
    );
  }
}
