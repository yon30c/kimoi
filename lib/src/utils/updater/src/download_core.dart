import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kimoi/src/utils/updater/src/controller.dart';
import 'package:kimoi/src/utils/updater/src/enums.dart';
import 'package:kimoi/src/utils/updater/utils/constants.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import 'api_task.dart';

class DownloadCore {
  final String id;
  final String url;
  CancelToken token;
  final ValueNotifier<double> progressNotifier;
  final ValueNotifier<String> progressPercentNotifier, progressSizeNotifier;

  final UpdaterController? controller;
  final Function dismiss;

  DownloadCore({
    required this.id,
    required this.url,
    required this.token,
    required this.progressNotifier,
    required this.progressPercentNotifier,
    required this.progressSizeNotifier,
    this.controller,
    required this.dismiss,
  });

  bool _isDisposed = false;

  Future<void> startDownload({bool isResumed = false}) async {
    Directory tempDirectory = await directory();

    List<FileSystemEntity> listEntity = tempDirectory.listSync();

    int downloadedLength = 0;

    String totalLength = await checkFileSize();

    if (totalLength.isNotEmpty) {
      totalLength = '${int.parse(totalLength) - 1}';
    }

    if (isResumed) {
      for (FileSystemEntity entity in listEntity) {
        File file = File(entity.path);
        downloadedLength += file.lengthSync();
      }
    } else {
      for (FileSystemEntity entity in listEntity) {
        File file = File(entity.path);
        file.deleteSync();
      }
    }

    int index = listEntity.isNotEmpty
        ? int.tryParse(listEntity.last.path.split('-').last.split('.').first) ??
            0
        : 0;

    String fileName = '${tempDirectory.path}/app$id-${index + 1}.apk';

    try {
      await APITask().download(
        url,
        fileName,
        cancelToken: token,
        onReceiveProgress: (currentProgress, totalProgress) {
          if (controller?.status == UpdateStatus.none) {
            controller?.setValue(UpdateStatus.Downloading);
          }

          final int cp = currentProgress + downloadedLength;
          final int tp = totalProgress + downloadedLength;

          controller?.setProgress(cp, tp);

          if (!_isDisposed) {
            double progress = cp / tp;

            double percent = progress * 100;

            progressNotifier.value = progress;
            progressPercentNotifier.value = '${percent.toStringAsFixed(2)} %';

            progressSizeNotifier.value =
                '${formatBytes(cp, 1)} / ${formatBytes(tp, 1)}';
          }

          if (currentProgress == totalProgress) {
            //if the download was resumed then merge all the files
            // otherwise open the downloaded file
            if (isResumed) {
              _mergeFiles(tempDirectory);
            } else {
              OpenFilex.open(fileName);
            }

            if (!_isDisposed) {
              dismiss.call();
              controller?.setValue(UpdateStatus.Completed);
            }
          }

          if (currentProgress > totalProgress) {
            token.cancel();

            throw Exception(
                'progress > totalProgress. Please start download instead of resume.');
          }
        },
        options: isResumed
            ? Options(
                headers: {
                  'range': 'bytes=$downloadedLength-',
                  // 'range': 'bytes=$downloadedLength-$totalLength',
                },
                responseType: ResponseType.stream,
              )
            : Options(),
        deleteOnError: false,
      );
    } catch (e) {
      printError(e);
    }
  }

  Future<void> lastDownloadProgress() async {
    Directory tempDirectory = await directory();
    List<FileSystemEntity> listEntity = tempDirectory.listSync();

    int length = 0;

    for (FileSystemEntity entity in listEntity) {
      length += File(entity.path).lengthSync();
    }

    String totalLength = await checkFileSize();
    if (totalLength.isEmpty) totalLength = '0';

    var percent = length * 100 / int.parse(totalLength);
    progressNotifier.value = length / int.parse(totalLength);
    progressPercentNotifier.value = '${percent.toStringAsFixed(2)} %';

    progressSizeNotifier.value =
        '${formatBytes(length, 1)} / ${formatBytes(int.parse(totalLength), 1)}';
  }

  void dispose() {
    _isDisposed = true;
  }

  Future<void> _mergeFiles(Directory tempDir) async {
    List<FileSystemEntity> listEntity = tempDir.listSync();

    File file = File('${tempDir.path}/app_complete_update.apk');
    if (await file.exists()) {
      await file.delete();
    }

    IOSink outputFile = file.openWrite(mode: FileMode.write);

    for (FileSystemEntity entity in listEntity) {
      List<int> bytes = await File(entity.path).readAsBytes();
      outputFile.add(bytes);
    }

    await outputFile.close();

    OpenFilex.open(file.path);
  }

  void cancel() {
    token.cancel();
    dispose();
    dismiss.call();
  }

  void pause() {
    token.cancel();
    // token = CancelToken();
  }

  void resume() {
    if (_isDisposed) {
      throw Exception(
          'Download is canceled. Start the download again and pause instead of cancel to resume.');
    }
    token = CancelToken();
    startDownload(isResumed: true);
  }

  Future<Directory> directory() async {
    Directory tempDir = await getTemporaryDirectory();
    Directory updateDirctory = Directory('${tempDir.path}/Updater/');

    if (!await updateDirctory.exists()) {
      await updateDirctory.create();
    }

    return updateDirctory;
  }

  Future<String> checkFileSize() async {
    try {
      Response response = await APITask().head(url);
      return (response.headers.value(Headers.contentLengthHeader)) ?? '';
    } catch (e) {
      return '';
    }
  }
}
