import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimoi/src/main_app.dart';

import 'src/config/theme/theme.dart';

final themeController = ThemeController(ThemeService());

void changeStatusBarColor(Color color) {
  // Establecemos el color de la barra de navegación del sistema en azul.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService.init();
  await themeController.loadTheme();


  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  runApp(const ProviderScope(child: MainApp()));
}
