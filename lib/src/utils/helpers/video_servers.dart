// import 'dart:convert';
// import 'package:html/parser.dart';
// import 'package:http/http.dart';
// import 'package:latanime/src/domain/domain.dart';
// import 'package:latanime/src/utils/extensions/extension.dart';

// import '../../infrastructure/models/video.dart';
// import '../extractors/extractors.dart';
// import '../extractors/jk_anime_extractor.dart';

// class VideoServers {
//   final String url;

//   Client client = Client();

//   VideoServers(this.url);

//   final Map<String, String> headersWithReferer = {
//     "referer": "https://uqload.com/"
//   };

//   List<Video> videoList = [];

//   Future<List<Video>> monosChinosServers() async {
//     String path = url.split('/').last;
//     final res =
//         await client.get(Uri.parse('https://monoschinos2.com/ver/$path'));

//     final document = parse(res.body);
//     // ;

//     final heroArea = document.querySelector("div.heroarea");
//     final li = heroArea!.querySelector('ul.dropcaps')!.querySelectorAll('li');

//     for (var it in li) {
//       final urlBase64 = it.querySelector("a")!.attributes["data-player"]!;
//       final url = utf8.decode(base64.decode(urlBase64));
  
//       if (url.contains("ok.ru")) {
//         if (!url.contains("streamcherry")) {
//           final videos = await OkruExtractor().videosFromUrl(url);
//           videoList.addAll(videos);
//         }
//       }
//       if (url.contains("solidfiles")) {
//         final videos = await SolidFilesExtractor(client).videosFromUrl(url);
//         videoList.addAll(videos);
//       }
//       if (url.contains("uqload")) {
//         final video =
//             UploadExtractor(client).videoFromUrl(url, headersWithReferer);
//         if (video != null) {
//           videoList.add(video);
//         }
//       }
//       if (url.contains("mp4upload")) {
//         final videos =
//             await Mp4uploadExtractor().videosFromUrl(url, headersWithReferer);
//         videoList.addAll(videos);
//       }
//       if (url.contains('doodstream')) {
//         final videos = await DoodExtractor().videoFromUrl(url);
//         if (videos != null) videoList.add(videos);
//       }
//       if (url.contains('mixdrop')) {
//         final videos = await MixDropExtractor().videoFromUrl(url);
//         videoList.addAll(videos);
//       }
//     }

//     for (var element in videoList) {
//       print('${element.quality} ${element.videoUrl}');
//     }
//     return videoList;
//   }

//   Future<List<Video>> jkAnimeServers() async {
//     const baseUrl = "https://jkanime.net";

//     String tmpPath = url.split('/').last;
//     String episode = tmpPath.split('-').last;

//     String path = tmpPath.substringBefore('-$episode');

//     final res =
//         await client.get(Uri.parse('https://jkanime.net/$path/$episode/'));

//     final document = parse(res.body);

//     document
//         .querySelector("div.col-lg-12")
//         ?.querySelectorAll('a')
//         .forEach((element) async {
//       String serverId = element.attributes["data-id"]!;
//       String lang =
//           element.attributes["class"]!.contains("lg_3") ? "[LAT]" : "";
//       final scriptServers = document
//           .querySelectorAll("script")
//           .firstWhere((element) => element.text.contains('var video = []'));
//       String scriptData = scriptServers.text;
//       String url = scriptData
//           .substringAfter(
//               "video[$serverId] = '<iframe class=\"player_conte\" src=\"")
//           .substringBefore("\"")
//           .replaceAll("/jkokru.php?u=", "http://ok.ru/videoembed/")
//           .replaceAll("/jkvmixdrop.php?u=", "https://mixdrop.co/e/")
//           .replaceAll("/jk.php?u=", "$baseUrl/");

//       if (url.contains("ok")) {
//         final videos = await OkruExtractor().videosFromUrl(url);
//         for (var video in videos) {
//           videoList.add(video);
//         }
//       } else if (url.contains("stream/jkmedia")) {
//         videoList
//             .add(Video(url: url, quality: "${lang}Xtreme S", videoUrl: url));
//       } else if (url.contains("um2.php")) {
//         var extractedVideo = await JkanimeExtractor(client)
//             .getNozomiFromUrl("$baseUrl$url", lang);
//         if (extractedVideo != null) {
//           videoList.add(extractedVideo);
//         }
//       } else if (url.contains("um.php")) {
//         var extractedVideo = await JkanimeExtractor(client)
//             .getDesuFromUrl("$baseUrl$url", lang);
//         if (extractedVideo != null) {
//           videoList.add(extractedVideo);
//         }
//       }
//     });

//     for (var element in videoList) {
//       print('video ${element.videoUrl}');
//     }

//     return videoList;
//   }
// }
