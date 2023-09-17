import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:kimoi/src/infrastructure/infrastructure.dart';
import 'package:kimoi/src/utils/extensions/extension.dart';

class VoeExtractor {
  final client = Client();
  final headers = {
    "User-Agent":
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
  };

  Future<List<Video>> videoFromUrl(String url) async {
    final response = await client.get(Uri.parse(url), headers: headers);

    List<Video> videos = [];
    if (response.body.isNotEmpty && response.statusCode == 200) {
      final doc = parse(response.body);

      final script = doc
          .querySelectorAll('script')
          .firstWhere((element) =>
              element.text.contains('const sources') ||
              element.text.contains('var sources'))
          .text;

      final videoUrl = script.substringAfter("hls': '").substringBefore("'");
      final resolution =
          script.substringAfter("video_height': ").substringBefore(",");
      final quality = "VoeCDN(${resolution}p)";

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
