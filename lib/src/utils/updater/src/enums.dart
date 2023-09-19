enum UpdateStatus {
  ///when checking for an update
  Checking,

  ///when an update is available
  Available,

  ///when update dialog dismissed
  DialogDismissed,

  ///when an update is preparing to download
  Pending,

  ///when an update starts downloading
  Downloading,

  ///when the update is downloaded and ready to install
  Completed,

  ///when an update is downloading and canceled
  Cancelled,

  ///when there is an error that stoped the update to download
  Failed,

  ///Update download paused
  Paused,

  ///Update download resume
  Resume,

  ///none
  none,
}
