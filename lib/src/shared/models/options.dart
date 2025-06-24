import 'package:casual_log_manager/casual_log_manager.dart';

/// Configuration options for the logging system.
class Options {
  /// Creates an [Options] instance with the given configuration.
  ///
  /// [preventCrashes] enables crash prevention using guarded zones.
  /// [logToFile] enables logging to files.
  /// [prettyPrint] enables pretty printing for console logs.
  /// [logToConsole] enables logging to the console.
  /// [logToNetwork] enables logging to a network endpoint.
  /// [demangleStackTrace] enables demangling of stack traces for readability.
  /// [logDelimiter] sets the delimiter used in log formatting.
  const Options({
    this.preventCrashes = false,
    this.logToFile = false,
    this.prettyPrint = true,
    this.logToConsole = true,
    this.logToNetwork = false,
    this.demangleStackTrace = true,
    this.logDelimiter = '|',
    this.logLevelForPrint = LogLevel.NONE,
    this.consoleFilter = const [
      LogLevel.INFO,
      LogLevel.WARNING,
      LogLevel.ERROR,
      LogLevel.ALL,
    ],
  });

  /// Whether to prevent crashes using guarded zones.
  final bool preventCrashes;

  /// Whether to enable pretty printing for console logs.
  final bool prettyPrint;

  /// Whether to enable logging to the console.
  final bool logToConsole;

  /// Whether to enable logging to a network endpoint.
  final bool logToNetwork;

  /// Whether to enable logging to files.
  final bool logToFile;

  /// Whether to demangle stack traces for readability.
  final bool demangleStackTrace;

  /// The delimiter used in log formatting.
  final String logDelimiter;

  /// List of log levels that are filtered for console logging.
  final List<LogLevel> consoleFilter;

  /// The log level set for 'print' operations.
  final LogLevel logLevelForPrint;
}
