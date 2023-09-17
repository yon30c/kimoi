import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kimoi/src/infrastructure/infrastructure.dart';
import 'package:kimoi/src/utils/extensions/extension.dart';

class YourUploadExtractor extends HeadlessInAppWebView {
  final client = http.Client();

  final headers = {
    "Accept": "application/json",
    "referer": "https://yourupload.com/",
    "User-Agent":
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
  };

  Future<Video?> videoFromUrl(String url) async {
    final res = await client.get(Uri.parse(url), headers: headers);

    if (res.body.isNotEmpty && res.statusCode == 200) {
      final doc = parse(res.body);

      final baseData = doc
          .querySelectorAll('script')
          .firstWhere((element) => element.text.contains('jwplayerOptions'))
          .text;

      final basicUrl = baseData.substringAfter("file: '").substringBefore("',");

      return Video(
          url: basicUrl,
          quality: 'YourUpload',
          videoUrl: basicUrl,
          headers: headers);
    }

    return null;
  }
}
