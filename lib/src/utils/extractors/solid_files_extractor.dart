// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:html/parser.dart';
// import 'package:http/http.dart';
// import 'package:kimoi/src/infrastructure/infrastructure.dart';
// import 'package:kimoi/src/utils/extensions/extension.dart';

// class SolidFilesExtractor {
//   final client = Client();
//   final headers = {
//     "User-Agent":
//         "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36"
//   };

//   Future<List<Video>> videoFromUrl(String url1) async {

//     String? html;

//     bool isLoading = true;

//     List<Video> videos = [];

//     try {
//       HeadlessInAppWebView(
//         initialUrlRequest: URLRequest(url: Uri.parse(url1), headers: headers),
//         onLoadStop: (controller, url) async {
//           html = await controller.getHtml();
//           isLoading = false;
//         },
//       )
//         ..run()
//         ..dispose();

//       while (isLoading) {
//         await Future.delayed(const Duration(milliseconds: 500));
//       }

//       final doc = parse(html);

//       final script = doc
//           .querySelectorAll('script')
//           .firstWhere((element) => element.text.contains("\"downloadUrl\":"))
//           .text;

//       final data =
//           script.substringAfter("\"downloadUrl\":").substringBefore(",");
//       final url = data.replaceAll("\"", "");
//       final videoUrl = url;
//       const quality = "SolidFiles";

//       final video = Video(
//           url: url, quality: quality, videoUrl: videoUrl, headers: headers);

//       videos.add(video);
//       return videos;
//     } catch (e) {
//       return [];
//     }
//   }
// }
