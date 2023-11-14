import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:kimoi/src/infrastructure/infrastructure.dart';
import 'package:kimoi/src/utils/extensions/extension.dart';

class OkruExtractor {
  final client = Client();

  final headers = {
    "User-Agent":
        "Mozilla/5.0 (Linux; Android 5.1.1; Android SDK built for x86 Build/LMY48X) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/39.0.0.0 Mobile Safari/537.36"
  };

  String fixQuality(String quality) {
    final qualities = {
      "ultra": "2160p",
      "quad": "1440p",
      "full": "1080p",
      "hd": "720p",
      "sd": "480p",
      "low": "360p",
      "lowest": "240p",
      "mobile": "144p"
    };

    return qualities[quality] ?? 'Okru';
  }

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

      while (isLoading) {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      var doc = parse(html);

      final data =
          doc.querySelector('div[data-options]')?.attributes['data-options'];

      if (data == null) return [];

      // if (data.contains("ondemandHls")) {
      //   print("ondemandHls");
      // } else if (data.contains("ondemandHls")) {
      //   print("ondemandHls");
      // }

      final videos = videosFromJson(data);
      return videos;
    } on Exception catch (e) {
      debugPrint('$e');
      return [];
    }
  }

  List<Video> videosFromJson(String videoString,
      {String prefix = "", bool fixQualities = true}) {
    final arrayData = videoString
        .substringAfter("\\\"videos\\\":[{\\\"name\\\":\\\"")
        .substringBefore("]");

    final data = arrayData.split("{\\\"name\\\":\\\"").reversed.map((it) {
      final videoUrl = it.extractLink("url");
      final resolution = it.substringBefore("\\\"");
      final quality = fixQuality(resolution);

      final videoQuality = "Okru:$quality";

      // if (videoUrl.startsWith("https://")) {
      return Video(
          url: videoUrl,
          quality: videoQuality,
          videoUrl: videoUrl,
          headers: headers);
      // } else {
      //   null;
      // }
    }).toList();

    return data;
  }
}
