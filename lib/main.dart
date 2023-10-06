import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kimoi/src/config/router/router_controller.dart';
import 'package:kimoi/src/config/router/router_service.dart';
import 'firebase_options.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimoi/src/main_app.dart';

import 'src/config/theme/theme.dart';

final themeController = ThemeController(ThemeService());
final routerController = RouterController(RouterService());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAnalytics.instance.logAppOpen();
  await ThemeService.init();
  await RouterService.init();

  await routerController.loadInitialLocation();
  await themeController.loadTheme();

  await dotenv.load(fileName: ".env");

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  runApp(const ProviderScope(child: MainApp()));
}
