// import 'package:dio/dio.dart';
// import 'package:http/http.dart';
// import 'package:kimoi/src/infrastructure/infrastructure.dart';
// import 'package:kimoi/src/utils/extensions/extension.dart';

// typedef HeadersGen = Headers Function({Headers baseHeaders, String referer});

// class MasterHeaderGen {
//   final Headers headers;
//   final String referer;

//   MasterHeaderGen({required this.headers, required this.referer});

//   Map<String, String>? generateMasterHeaders() {
//     headers.add("Accept", "*/*");

//     if (referer.isNotEmpty) {
//       headers.add("Origin", "https://${Uri.parse(referer).host}");
//       headers.add("Referer", referer);
//     }

//     Map<String, String>? lastHead = {};

//     headers.forEach((name, values) {
//       lastHead.addAll({name: values.first});
//     });

//     return lastHead;
//   }
// }

// class PlaylistUtils {
//   final client = Client();
//   final Headers headers = Headers();

//   final String PLAYLIST_SEPARATOR = "#EXT-X-STREAM-INF:";

//   final SUBTITLE_REGEX =
//       RegExp('''#EXT-X-MEDIA:TYPE=SUBTITLES.*?NAME="(.*?)".*?URI="(.*?)"''');
//   final AUDIO_REGEX =
//       RegExp('''#EXT-X-MEDIA:TYPE=AUDIO.*?NAME="(.*?)".*?URI="(.*?)"''');

//   Future<List<Video>> extractFromHls(
//     String playlistUrl, {
//     String referer = "",
//     Headers? masterHeaders,
//     Headers? videoHeaders,
//     String Function(String)? videoNameGen,
//     List<Track> subtitleList = const [],
//     List<Track> audioList = const [],
//   }) {
//     return _extractFromHls(playlistUrl,
//         referer: referer,
//         masterHeadersGen:
//             MasterHeaderGen(headers: masterHeaders!, referer: referer),
//         videoHeadersGen:
//             MasterHeaderGen(headers: videoHeaders!, referer: referer),
//         videoNameGen: videoNameGen!(''),
//         subtitleList: subtitleList,
//         audioList: audioList);
//   }

//   Future<List<Video>> _extractFromHls(String playlistUrl,
//       {String referer = '',
//       required MasterHeaderGen masterHeadersGen,
//       required MasterHeaderGen videoHeadersGen,
//       required String videoNameGen,
//       List<Track>? subtitleList,
//       List<Track>? audioList}) async {
//     final masterHeaders = MasterHeaderGen(headers: headers, referer: referer);

//     final masterPlaylistRes = await client.get(Uri.parse(playlistUrl),
//         headers: masterHeaders.generateMasterHeaders());
//     final masterPlaylist = masterPlaylistRes.body.toString();
//     // .use { it.body.string() }

//     final p = masterPlaylist.allMatches(PLAYLIST_SEPARATOR);

//     print(p);

//     // Check if there isn't multiple streams available
//     // if (PLAYLIST_SEPARATOR !in masterPlaylist) {
//     //     return listOf(
//     //         Video(
//     //             playlistUrl, videoNameGen("Video"), playlistUrl, headers = masterHeaders, subtitleTracks = subtitleList, audioTracks = audioList
//     //         )
//     //     )
//     // }

//     final playlistHttpUrl = Uri.parse(playlistUrl);

//     final masterBase =
//         "${"https://${playlistHttpUrl.host}${playlistHttpUrl.path}".substringBeforeLast("/")}/";

//     return [];

//     // Get subtitles
//     // final subtitleTracks = subtitleList + SUBTITLE_REGEX.findAll(masterPlaylist).mapNotNull {
//     //     Track(
//     //         getAbsoluteUrl(it.groupValues[2], playlistUrl, masterBase) ?: return@mapNotNull null,
//     //         it.groupValues[1]
//     //     )
//     // }.toList()

//     // // Get audio tracks
//     // final audioTracks = audioList + AUDIO_REGEX.findAll(masterPlaylist).mapNotNull {
//     //     Track(
//     //         getAbsoluteUrl(it.groupValues[2], playlistUrl, masterBase) ?: return@mapNotNull null,
//     //         it.groupValues[1]
//     //     )
//     // }.toList()

//     // return masterPlaylist.substringAfter(PLAYLIST_SEPARATOR).split(PLAYLIST_SEPARATOR).mapNotNull {
//     //     val resolution = it.substringAfter("RESOLUTION=")
//     //         .substringBefore("\n")
//     //         .substringAfter("x")
//     //         .substringBefore(",") + "p"

//     //     val videoUrl = it.substringAfter("\n").substringBefore("\n").let { url ->
//     //         getAbsoluteUrl(url, playlistUrl, masterBase)
//     //     } ?: return@mapNotNull null

//     //     Video(
//     //         videoUrl, videoNameGen(resolution), videoUrl,
//     //         headers = videoHeadersGen(headers, referer, videoUrl),
//     //         subtitleTracks = subtitleTracks, audioTracks = audioTracks
//     //     )
//     // }
//   }

//   String? getAbsoluteUrl(String url, String playlistUrl, String masterBase) {
//     return url.isEmpty
//         ? null
//         : url.startsWith("http")
//             ? url
//             : url.startsWith("//")
//                 ? "https:$url"
//                 : url.startsWith("/")
//                     ? "https://${Uri.parse(playlistUrl).host}$url"
//                     : masterBase + url;
//   }
// }
