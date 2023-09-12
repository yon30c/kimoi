
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'Home-screen';

  const HomeScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        icon: Icon(Icons.video_collection_rounded), label: "Animes"),
    NavigationDestination(
      icon: Icon(Icons.bookmarks_rounded),
      label: "Mis listas",
    ),
    NavigationDestination(icon: Icon(Icons.explore), label: "Explorar"),
  ];


  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;



    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('LatAnime'),
        //   actions: [_colorized(context)],
        // ),
        body: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: widget.navigationShell),
        // IndexedStack(
        //   index: index,
        //   children: pages.map((e) => e.page).toList(),
        // ),,
        bottomNavigationBar: NavigationBar(
          indicatorColor: color.primaryContainer,
          destinations: items,
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: (value) => onTap(context, value),
          // labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ));
  }
}
