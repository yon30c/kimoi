import 'package:dio/dio.dart';


typedef HeadersGen = Headers Function({Headers baseHeaders, String referer});

class PlaylistUtils {

  // List<Video> extractFromHls(
  //       String playlistUrl,
  //       {String referer = "",
  //       Headers? masterHeaders,
  //       Headers? videoHeaders,
  //       String Function(String)? videoNameGen,
  //       List<Track> subtitleList = const [],
  //       List<Track> audioList = const [],}
  //   )  {
  //       return _extractFromHls(
  //           playlistUrl,
  //           referer: referer,
  //           masterHeadersGen:  (_, __) => masterHeaders,
  //           videoHeadersGen: ( _, __, ___) => videoHeaders,
  //           videoNameGen: videoNameGen ,
  //           subtitleList: subtitleList,
  //           audioList: audioList
  //       );
  //   }

  //   List<Video> _extractFromHls(
  //       String playlistUrl,
  //       String referer = "",
        
       
  //   ) {
  //     return [];
  //   }
 



   String? getAbsoluteUrl( String url,  String playlistUrl,  String masterBase) {
        return   
            url.isEmpty ? null:
            url.startsWith("http") ? url :
            url.startsWith("//") ? "https:$url" :
            url.startsWith("/") ? "https://${Uri.parse(playlistUrl).host}$url" :
            masterBase + url;
        }
  

  Headers generateMasterHeaders(Headers baseHeaders, String referer) {
    baseHeaders.add("Accept", "*/*");

    if (referer.isNotEmpty) {
      baseHeaders.add("Origin", "https://${Uri.parse(referer).host}");
      baseHeaders.add("Referer", referer);
    }

    return baseHeaders;
  }
}
