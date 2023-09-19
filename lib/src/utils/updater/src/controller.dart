import 'package:flutter/material.dart';
import 'package:kimoi/src/utils/updater/src/enums.dart';

class UpdaterController extends ChangeNotifier {
  UpdaterController({
    this.listener,
    this.onChecked,
    this.progress,
    this.onError,
  });

  ///controller is disposed
  bool _isDisposed = false;

  ///Return [UpdateStatus] whenever new event trigger
  ///
  ///[UpdateStatus.Checking] when checking for an update
  ///
  ///[UpdateStatus.Available] when an update is available
  ///
  ///[UpdateStatus.Pending] when an update is preparing to download
  ///
  ///[UpdateStatus.Dowloading] when an update starts downloading
  ///
  ///[UpdateStatus.Completed] when the update is downloaded and ready to install
  ///
  ///[UpdateStatus.DialogDismissed] when update dialog dismissed
  ///
  ///[UpdateStatus.Cancelled] when an update is downloading and canceled
  ///
  ///[UpdateStatus.Failed] when there is an error that stoped the update to download
  void Function(UpdateStatus status)? listener;

  ///Return true/false based on update available or not
  void Function(bool isAvailable)? onChecked;

  ///Return download progress
  ///
  ///
  ///```
  /// progress: (int current, int total) {
  ///   debugPrint('Progress: $current -- $total');
  /// },
  ///
  ///```
  void Function(int current, int total)? progress;

  ///Return error
  void Function(Object status)? onError;

  UpdateStatus status = UpdateStatus.none;

  void cancel() {
    status = UpdateStatus.Cancelled;
    if (!_isDisposed) notifyListeners();
  }

  void pause() {
    status = UpdateStatus.Paused;
    if (!_isDisposed) notifyListeners();
  }

  void resume() {
    status = UpdateStatus.Resume;
    if (!_isDisposed) notifyListeners();
  }

  void setValue(UpdateStatus status) {
    this.status = status;
    if (listener != null) listener!(status);
    if (!_isDisposed) notifyListeners();
  }

  void setAvailability(bool isAvailable) {
    if (onChecked != null) {
      onChecked!(isAvailable);
      if (!_isDisposed) notifyListeners();
    }
  }

  void setProgress(current, total) {
    if (progress != null) progress!(current, total);
    if (!_isDisposed) notifyListeners();
  }

  void setError(error) {
    if (onError != null) onError!(error);
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    listener = null;
    progress = null;
    onError = null;

    super.dispose();
  }
}
