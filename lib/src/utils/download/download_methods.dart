

// import 'package:dio/dio.dart';
// import 'package:kimoi/src/utils/download/directory_path.dart';

// class DownloadVideo {
//    startDownload( CancelToken cancelToken, DirectoryPath getPathFile, String fileName ) async {
//     var storePath = await getPathFile.getPath();
//     String filePath = '$storePath/$fileName';
//     // setState(() {
//     //   dowloading = true;
//     //   progress = 0;
//     // });

//     try {
//       await Dio().download(widget.fileUrl, filePath,
//           onReceiveProgress: (count, total) {
//         setState(() {
//           progress = (count / total);
//         });
//       }, cancelToken: cancelToken);
//       setState(() {
//         dowloading = false;
//         fileExists = true;
//       });
//     } catch (e) {
//       print(e);
//       setState(() {
//         dowloading = false;
//       });
//     }
//   }

// }