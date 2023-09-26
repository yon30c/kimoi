import 'dart:math';

import 'package:http/http.dart';
import 'package:kimoi/src/infrastructure/infrastructure.dart';
import 'package:kimoi/src/utils/extensions/extension.dart';

class DoodExtractor {
  final client = Client();

  Future<Video?> videoFromUrl(
    String url,
    String? quality, {
    bool redirect = true,
    List<Track> externalSubs = const [],
  }) async {
    final newQuality = quality ?? "Doodstream${redirect ? " mirror" : ""}";

    try {
      final response = await client.get(Uri.parse(url));

      // if (response.body.isNotEmpty && response.statusCode == 200)

      final newUrl = (redirect) ? response.request!.url.toString() : url;

      final doodHost = RegExp("https://(.*?)/").firstMatch(newUrl)!.group(1);
      final content = response.body.toString();
      if (!content.contains("'/pass_md5/")) return null;
      final md5 = content.substringAfter("'/pass_md5/").substringBefore("',");
      final token = md5.substringAfterLast("/");
      final randomString = getRandomString();
      final expiry = DateTime.now().millisecond;
      final videoUrlStart = await client.get(
        Uri.parse("https://$doodHost/pass_md5/$md5"),
        headers: {"referer": newUrl},
      );
      final videoUrl =
          "${videoUrlStart.body.toString()}$randomString?token=$token&expiry=$expiry";
      return Video(
          url: newUrl,
          quality: newQuality,
          videoUrl: videoUrl,
          headers: doodHeaders(doodHost!),
          subtitleTracks: externalSubs);
    } catch (e) {
      return null;
    }
  }

  Map<String, String> doodHeaders(String host) {
    Map<String, String> headers = {};
    headers
      ..addAll({"User-Agent": "Aniyomi"})
      ..addAll({"Referer": "https://$host/"});

    return headers;
  }

  String getRandomString({int length = 10}) {
    final random = Random();

    final allowedChars = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z',
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9'
    ];

    final l = length <= 1 ? 1 : length;
    List<String> result = [];
    for (var i = 0; i < l; i++) {
      result.add(allowedChars[random.nextInt(allowedChars.length)]);
    }
    return result.join();
    // .joinToString("")
  }
}
