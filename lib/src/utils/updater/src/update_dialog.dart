import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kimoi/src/utils/updater/src/controller.dart';
import 'package:kimoi/src/utils/updater/src/download_core.dart';
import 'package:kimoi/src/utils/updater/src/enums.dart';

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({
    super.key,
    required this.context,
    required this.controller,
    required this.titleText,
    required this.contentText,
    required this.rootNavigator,
    required this.allowSkip,
    required this.downloadUrl,
    required this.backgroundDownload,
    this.confirmText,
    this.cancelText,
    required this.elevation,
    required this.token,
    this.status = UpdateStatus.Downloading,
    required this.id,
    required this.enableResume,
  });

  final BuildContext context;

  ///title of the dialog
  final String titleText;

  ///content/body of the dialog
  final String contentText;

  ///confirm button text
  final String? confirmText;

  ///cancel button text
  final String? cancelText;

  ///download url of the app
  final String downloadUrl;
  final bool rootNavigator;
  final bool allowSkip;
  final bool backgroundDownload;
  final bool enableResume;
  final double elevation;
  final UpdaterController? controller;
  final CancelToken token;
  final UpdateStatus status;
  final String id;

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  ///Current progress
  ValueNotifier<double> progressNotifier = ValueNotifier(0.0);

  ///Current progress in percentage
  ValueNotifier<String> progressPercentNotifier = ValueNotifier('');

  ///Current progress size
  ValueNotifier<String> progressSizeNotifier = ValueNotifier('');

  ///Dialog state changed or not
  bool _changeDialog = false;
  late DownloadCore core;
  late UpdateStatus status;

  @override
  void initState() {
    super.initState();

    status = widget.status;

    core = DownloadCore(
      id: widget.id,
      url: widget.downloadUrl,
      token: widget.token,
      progressNotifier: progressNotifier,
      progressPercentNotifier: progressPercentNotifier,
      progressSizeNotifier: progressSizeNotifier,
      controller: widget.controller,
      dismiss: _dismiss,
    );
    if (widget.status == UpdateStatus.Paused) {
      core.lastDownloadProgress();
    }
    listenUpdate();
  }

  @override
  void dispose() {
    core.dispose();
    progressNotifier.dispose();
    progressPercentNotifier.dispose();
    progressSizeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: widget.elevation,
      backgroundColor: Colors.white,
      child: _changeDialog || status == UpdateStatus.Paused
          ? _downloadContentWidget()
          : _updateContentWidget(),
    );
  }

  ///Update dialog UI
  Widget _updateContentWidget() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.allowSkip)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  _dismiss();
                },
                icon: const Icon(Icons.clear_rounded),
              ),
            ),
          Container(
            alignment: Alignment.center,
            child: Text(
              widget.titleText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          // widget.content,
          Container(
            alignment: Alignment.center,
            child: Text(
              widget.contentText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _changeDialog = true;
                  });
                  status = UpdateStatus.Downloading;

                  core.startDownload();
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(
                      14,
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    left: 18,
                    right: 18,
                    top: 12,
                    bottom: 12,
                  ),
                  child: Text(
                    '${widget.confirmText}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (widget.allowSkip)
                InkWell(
                  onTap: () {
                    _dismiss();
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        14,
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      left: 18,
                      right: 18,
                      top: 12,
                      bottom: 12,
                    ),
                    child: Text(
                      '${widget.cancelText}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  ///download dialog UI
  Widget _downloadContentWidget() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Downloading...',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueListenableBuilder<String>(
                valueListenable: progressSizeNotifier,
                builder: (context, index, _) {
                  return Text(
                    index,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  );
                },
              ),
              ValueListenableBuilder<String>(
                valueListenable: progressPercentNotifier,
                builder: (context, index, _) {
                  return Text(
                    index,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder<double>(
                  valueListenable: progressNotifier,
                  builder: (context, index, _) {
                    return LinearProgressIndicator(
                      value: index == 0.0 ? null : index,
                      backgroundColor: Colors.grey,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.black),
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  if (!widget.enableResume) {
                    core.cancel();
                    return;
                  }
                  if (status == UpdateStatus.Downloading ||
                      status == UpdateStatus.Resume) {
                    core.pause();
                    _updateStatus(UpdateStatus.Paused);
                  } else if (status == UpdateStatus.Paused ||
                      status == UpdateStatus.Cancelled) {
                    core.resume();
                    _updateStatus(UpdateStatus.Resume);
                  }

                  // _dismiss();
                },
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
                icon: Icon(
                  !widget.enableResume
                      ? Icons.clear_rounded
                      : (status == UpdateStatus.Downloading
                          ? Icons.clear_rounded
                          : status == UpdateStatus.Resume
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          if (widget.backgroundDownload)
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () {
                  _dismiss();
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(
                      14,
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 12,
                    bottom: 12,
                  ),
                  child: const Text(
                    'Hide',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  ///dismiss the dialog
  _dismiss() {
    Navigator.of(context, rootNavigator: widget.rootNavigator).pop();
  }

  ///listen of value events
  listenUpdate() {
    widget.controller?.addListener(() {
      if (widget.controller?.status == UpdateStatus.Resume) {
        widget.controller?.setValue(UpdateStatus.none);
        core.resume();
      }

      if (widget.controller?.status == UpdateStatus.Paused) {
        widget.controller?.setValue(UpdateStatus.none);

        core.pause();
      }

      if (widget.controller?.status == UpdateStatus.Cancelled) {
        widget.controller?.setValue(UpdateStatus.none);
        core.cancel();
      }
    });
  }

  ///update the current status and controller value
  void _updateStatus(UpdateStatus newStatus) {
    setState(() {
      status = newStatus;
      if (!_changeDialog) _changeDialog = true;
    });

    if (widget.controller != null) {
      widget.controller!.setValue(newStatus);
    }
  }
}
