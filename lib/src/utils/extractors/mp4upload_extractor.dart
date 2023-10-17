import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart';
import 'package:kimoi/src/infrastructure/infrastructure.dart';
import 'package:kimoi/src/utils/extensions/extension.dart';

class Mp4UploadExtractor {
  final client = Client();

  final headers = {
    "referer": "https://mp4upload.com/",
    "User-Agent":
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
  };

  RegExp qualityRegex = RegExp(r"""\WHEIGHT=(\d+)""");

  Future<List<Video>> videosFromUrl(String url) async {
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

      // Future.delayed(const Duration(seconds: 7), () {
      //   isLoading = false;
      // });

      while (isLoading) {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final script = html!.substringAfter('player.src(');

      final videoUrl = script
          .substringBefore(")")
          .substringAfter("src:")
          .substringAfter('"')
          .substringBefore('"');


      final resolution = qualityRegex.firstMatch(script)?.group(1);

      print(resolution);

      final quality = 'Mp4Upload - ${resolution}p';

      print(resolution);

      if (resolution == null || videoUrl.isEmpty) return [];

      return [
        Video(
            url: videoUrl,
            quality: quality,
            videoUrl: videoUrl,
            headers: headers)
      ];
    } on Exception catch (e) {
      debugPrint('$e');
      return [];
    }
  }
}
