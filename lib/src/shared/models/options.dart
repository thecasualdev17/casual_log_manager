class Options {
  const Options({
    this.preventCrashes = false,
    this.logToFile = false,
    this.prettyPrint = true,
    this.logToConsole = true,
    this.logToNetwork = false,
  });

  // Log Utilities
  final bool preventCrashes;
  final bool prettyPrint;

  // Log Outputs
  final bool logToConsole;
  final bool logToNetwork;
  final bool logToFile;

  // Demangle stack trace
  final bool demangleStackTrace = true;
}
