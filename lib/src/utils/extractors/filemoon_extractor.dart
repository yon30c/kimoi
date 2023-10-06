import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:kimoi/src/utils/extensions/extension.dart';
import 'package:kimoi/src/utils/extractors/unpaker.dart';

import '../../infrastructure/infrastructure.dart';

class FilemoonExtractor {
  final client = Client();

  Future<Video?> videosFromUrl(String url,
      {String prefix = "Filemoon - ", Map<String, String>? headears}) async {
    try {
      final res = await client.get(Uri.parse(url), headers: headears);

      final doc = parse(res.body);

      final jsEval = doc
          .querySelector("script:containsData(eval):containsData(m3u8)")
          .toString();
      final unpacked = JsUnpack(jsEval).unpack();

      final masterUrl = unpacked.isNotEmpty
          ? unpacked.substringAfter("{file:\"").substringBefore("\"}")
          : '';

      final res2 = await client.get(Uri.parse(masterUrl));
      final masterPlaylist = res2.body.toString();

      final httpUrl = Uri.parse(url);
      final videoHeaders = headears ?? {};
      videoHeaders.addAll({"Referer": url});
      videoHeaders.addAll({"Origin": "https://${httpUrl.host}"});

      Video? video;

      const separator = "#EXT-X-STREAM-INF:";
      masterPlaylist.substringAfter(separator).split(separator).map((it) {
        final resolution =
            "${it.substringAfter("RESOLUTION=").substringAfter("x").substringBefore(",")}p";
        final videoUrl = it.substringAfter("\n").substringBefore("\n");

        video = Video(
          url: videoUrl,
          quality: prefix + resolution,
          videoUrl: videoUrl,
          headers: videoHeaders,
          // subtitleTracks: subtitleTracks,
          // audioTracks:  audioTracks,
        );
      });

      return video;
    } catch (e) {
      return null;
    }
  }
}
