class Options {
  const Options({this.preventCrashes = false, this.logToFile = false, this.encryptLogs = false});

  final bool preventCrashes;
  final bool logToFile;
  final bool encryptLogs;
}
