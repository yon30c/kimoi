import 'package:html/parser.dart';
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
    final respose = await client.get(Uri.parse(url), headers: headers);

    if (respose.body.isNotEmpty && respose.statusCode == 200) {
      final doc = parse(respose.body);

      final script = doc
          .querySelectorAll('script')
          .firstWhere((element) => element.text.contains('player.src'))
          .text;

      final videoUrl = script
          .substringAfter(".src(")
          .substringBefore(")")
          .substringAfter("src:")
          .substringAfter('"')
          .substringBefore('"');

      final resolution = qualityRegex.firstMatch(script)?.group(1);

      final quality = 'Mp4Upload - $resolution';

      return [
        Video(
            url: videoUrl,
            quality: quality,
            videoUrl: videoUrl,
            headers: headers)
      ];
    }

    return [];
  }
}
