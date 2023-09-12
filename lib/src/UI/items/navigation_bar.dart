import 'package:flutter/material.dart';

class CsNavigationBar extends StatelessWidget {
  const CsNavigationBar({super.key, required this.items, required this.currentIndex, this.onTap});

  final List<Widget> items;
  final int currentIndex;
  final Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return NavigationBar(
      indicatorColor: color.primaryContainer,
      destinations: items,
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      // labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );
  }
}
