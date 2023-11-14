import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kimoi/src/infrastructure/infrastructure.dart';
import 'package:kimoi/src/utils/extensions/extension.dart';

class UqloadExtractor extends HeadlessInAppWebView {
  final client = http.Client();

  final headers = {
    "referer": "https://uqload.com/",
    "User-Agent":
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
  };

  Future<Video?> videoFromUrl(String url) async {
    String? html;

    bool isLoading = true;

    try {
      HeadlessInAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url), headers: headers),
        onLoadStop: (controller, url) async {
          html = await controller.getHtml();
          isLoading = false;
        },
      )
        ..run()
        ..dispose();

      while (isLoading) {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final doc = parse(html);

      final basicUrl = doc
          .querySelectorAll('script')
          .firstWhere((element) => element.text.contains('var player ='))
          .text
          .substringAfter('sources: ["')
          .substringBefore('"],');

      return Video(
          url: basicUrl,
          quality: 'Uqload',
          videoUrl: basicUrl,
          headers: headers);
    } on Exception catch (e) {
      debugPrint('$e');
      return null;
    }
  }
}
