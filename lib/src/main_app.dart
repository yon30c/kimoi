import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation, SystemUiOverlayStyle;
import 'package:kimoi/main.dart';
import 'package:kimoi/src/config/theme/theme.dart';

import 'config/router/router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: color.background.withAlpha(10)));
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, child) => MaterialApp.router(
        title: 'Material App',
        theme: AppTheme(selectedColor: 2).getDarkTheme(),
        darkTheme: AppTheme(selectedColor: 2).getDarkTheme(),
        themeMode: themeController.themeMode,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class CsBack extends BackButtonDispatcher {}
