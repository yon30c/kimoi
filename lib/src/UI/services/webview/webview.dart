
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

final MyInAppBrowser browser = MyInAppBrowser();

final options = InAppBrowserClassOptions(
  
    crossPlatform: InAppBrowserOptions(
      hideUrlBar: false,
    ),
    inAppWebViewGroupOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
      javaScriptEnabled: true,
    )));



class MyInAppBrowser extends InAppBrowser {


  @override
  Future onBrowserCreated() async {
    debugPrint("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    debugPrint("Started $url");
  }

  @override
  Future onLoadStop(url) async {
    
    debugPrint("Stopped $url");
  }

  @override
  void onLoadError(url, code, message) {
    debugPrint("Can't load $url.. Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    debugPrint("Progress: $progress");
  }

  @override
  void onExit() {
    debugPrint("Browser closed!");
  }
}
