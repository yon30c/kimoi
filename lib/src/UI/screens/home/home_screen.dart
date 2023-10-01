import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimoi/src/utils/updater/updater.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'Home-screen';

  const HomeScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UpdaterController controller;
  late Updater updater;
  bool isAvailable = true;

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

  checkUpdate() async {
    isAvailable = await updater.check();
  }

  void onTap(BuildContext context, int value) {
    widget.navigationShell.goBranch(value,
        initialLocation: value == widget.navigationShell.currentIndex);
  }

  List<NavigationDestination> items = const [
    NavigationDestination(
      icon: Icon(Icons.newspaper),
      label: "Noticias",
    ),
    NavigationDestination(
        selectedIcon: Icon(Icons.video_collection_rounded),
        icon: Icon(Icons.video_collection_rounded),
        label: "Animes"),
    NavigationDestination(
      icon: Icon(Icons.bookmarks_rounded),
      label: "Mis listas",
    ),
    NavigationDestination(icon: Icon(Icons.explore), label: "Explorar"),
  ];

  @override
  void initState() {
    super.initState();
    
    initializeUpdater();
    checkUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
        body: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: widget.navigationShell),
        bottomNavigationBar: NavigationBar(
          indicatorColor: color.primaryContainer,
          destinations: items,
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: (value) => onTap(context, value),
          // labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ));
  }
}
