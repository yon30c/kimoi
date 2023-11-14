import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kimoi/src/config/router/router_controller.dart';
import 'package:kimoi/src/config/router/router_service.dart';
import 'package:kimoi/src/config/source/source_controller.dart';
import 'package:kimoi/src/config/source/source_service.dart';
import 'firebase_options.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kimoi/src/main_app.dart';

import 'src/config/theme/theme.dart';

final themeController = ThemeController(ThemeService());
final routerController = RouterController(RouterService());
final sourceController = SourceController(SourceService());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!Platform.isLinux) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAnalytics.instance.logAppOpen();
  }
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  await ThemeService.init();
  await RouterService.init();
  await SourceService.init();

  await themeController.loadTheme();
  await sourceController.loadInitialDatasource();
  await routerController.loadInitialLocation();
  await dotenv.load(fileName: ".env");

  runApp(const ProviderScope(child: MainApp()));
}
