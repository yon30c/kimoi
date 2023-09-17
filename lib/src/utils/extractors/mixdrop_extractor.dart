import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:kimoi/src/infrastructure/infrastructure.dart';
import 'package:kimoi/src/utils/extensions/extension.dart';
import 'package:kimoi/src/utils/extractors/unpaker.dart';

class MixDropExtractor {
  final client = Client();
  final headers = {
    "Referer": "https://mixdrop.co/",
    "User-Agent":
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
  };

  Future<List<Video>> videoFromUrl(String url) async {
    final response = await client.get(Uri.parse(url), headers: headers);

    List<Video> videos = [];
    if (response.body.isNotEmpty && response.statusCode == 200) {
      final doc = parse(response.body);

      final index = doc.querySelectorAll('script').indexWhere((element) =>
          element.text.contains('eval') || element.text.contains('MDCore'));

      if (index == -1) return [];

      final script = doc
          .querySelectorAll('script')
          .firstWhere((element) =>
              element.text.contains('eval') || element.text.contains('MDCore'))
          .text;

      final unpacked = JsUnpack(script).unpack();

      final videoUrl =
          "https:${unpacked.substringAfter("Core.wurl=\"").substringBefore("\"")}";

      const quality = "MixDrop";

      final video = Video(
          url: videoUrl,
          quality: quality,
          videoUrl: videoUrl,
          headers: headers);

      videos.add(video);
      return videos;
    }

    return [];
  }
}
