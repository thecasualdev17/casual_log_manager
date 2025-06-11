class Options {
  const Options({
    this.preventCrashes = false,
    this.logToFile = false,
    this.encryptLogs = false,
    this.prettyPrint = true,
  });

  final bool preventCrashes;
  final bool logToFile;
  final bool encryptLogs;
  final bool prettyPrint;
}
