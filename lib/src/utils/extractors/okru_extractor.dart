import 'package:html_character_entities/html_character_entities.dart';
import 'package:http/http.dart';
import 'package:kimoi/src/infrastructure/infrastructure.dart';
import 'package:kimoi/src/utils/extensions/extension.dart';

class OkruExtractor {
  final client = Client();

  final headers = {
    "Accept": "application/json",
    "User-Agent":
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
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
    final response = await client.get(Uri.parse(url), headers: headers);

    List<Video> videos = [];

    if (response.body.isNotEmpty && response.statusCode == 200) {
      final htmlDecoded = HtmlCharacterEntities.decode(response.body)
          .replaceAll(' ', '')
          .replaceAll(r'\\\', '')
          .replaceAll(r'\\u0026amp;', '&')
          .replaceAll(r'\\u0026', '&');

      final data = htmlDecoded
          .substringAfter('data-options')
          .substringAfter("\\\"videos\\\":[{\\\"name\\\":\\\"")
          .substringBefore(']');

      final dataSplitted = data.split("{\\\"name\\\":\\\"").reversed.toList();

      for (var it in dataSplitted) {
        
        final videoUrl =
            it.substringAfter("url\\\":\\\"").substringBefore("\\\"");

        final quality = fixQuality(it.substringBefore("\\\""));

        final videoQuality = ("Okru:$quality");

        if (videoUrl.startsWith("https://")) {
          final video =
              Video(url: videoUrl, quality: videoQuality, videoUrl: videoUrl, headers: headers);
          videos.add(video);
        } else {
          null;
        }
      }
      
      return videos;
    }

    return [];
  }
}
