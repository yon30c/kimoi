import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kimoi/main.dart';
import 'package:kimoi/src/config/theme/theme.dart';


import 'config/router/router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
   
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, child) => MaterialApp.router(
        title: 'Material App',
        theme: AppTheme(selectedColor: 2).getTheme(),
        darkTheme: AppTheme(selectedColor: 2).getDarkTheme(),
        themeMode: themeController.themeMode,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class CsBack extends BackButtonDispatcher {}
