import 'package:log_manager/src/core/log_manager_core.dart';
import 'package:log_manager/src/shared/extensions/level_converter.dart';
import 'package:log_manager/src/shared/models/file_options.dart';
import 'package:log_manager/src/shared/models/log_level.dart';
import 'package:log_manager/src/shared/models/network_options.dart';
import 'package:log_manager/src/shared/models/options.dart';
import 'package:logging/logging.dart';

import '../io/log_manager_io.dart';

/// Singleton class for managing application logging and error handling.
///
/// Use [LogManager.init] to initialize the logging system before logging.
/// Example usage:
/// ```dart
/// LogManager().init(
///   onAppStart: () {
///     LogManager.log('Application started');
///     runApp();
///   },
///   label: 'MyApp',
///   options: Options(preventCrashes: true),
///   fileOptions: FileOptions(),
///   networkOptions: NetworkOptions(networkUrl: 'https://example.com/logs'),
/// );
/// LogManager.log('This is a log message');
/// LogManager.logWithStack('This is an error message with stack trace', logLevel: LogLevel.ERROR);
/// LogManager.getLogManagerIO() can be used to access the underlying LogManagerIO instance.
///
class LogManager {
  /// Private constructor for singleton pattern.
  LogManager._internal();

  /// Singleton instance of [LogManager].
  static final LogManager _instance = LogManager._internal();

  /// Static instance of [LogManagerIO] for handling logging operations.
  static LogManagerIO? logManagerIO;

  /// Core instance for managing the log manager lifecycle.
  late LogManagerCore logManagerCore;

  /// Factory constructor to return the singleton instance.
  factory LogManager() {
    return _instance;
  }

  /// Initializes the log manager with the provided options.
  /// This method should be called before any logging operations.
  /// @param onAppStart Callback function to be executed when the app starts.
  /// @param label A label for the log manager, used to identify logs.
  /// @param options Configuration options for the log manager.
  /// @param fileOptions Configuration options for file logging.
  /// @param networkOptions Configuration options for network logging.
  /// @return void
  void init({
    required Function onAppStart,
    required String label,
    Options options = const Options(),
    FileOptions fileOptions = const FileOptions(),
    NetworkOptions networkOptions = const NetworkOptions(networkUrl: ''),
  }) {
    logManagerCore = LogManagerCore();
    logManagerCore.initLogManagerCore(
      onAppStart: onAppStart,
      options: options,
      fileOptions: fileOptions,
      networkOptions: networkOptions,
      logLabel: label,
    );
  }

  /// Logs a message with the specified log level and label.
  /// This method can be used to log messages at different levels (INFO, WARNING, ERROR, etc.).
  /// @param message The message to log.
  /// @param logLevel The level of the log (default is INFO).
  /// @param label An optional label for the log entry (default is 'log_manager').
  /// @return void
  /// Example usage:
  /// ```dart
  /// LogManager.log('This is an info message');
  /// LogManager.log('This is a warning message', logLevel: LogLevel.WARNING);
  /// LogManager.log('This is an error message', logLevel: LogLevel.ERROR, label: 'error_logger');
  /// Note: Ensure that LogManager is initialized before calling this method.
  static void log(
    String message, {
    LogLevel logLevel = LogLevel.INFO,
    String label = 'log_manager',
  }) {
    Level level = logLevel.toLevel();
    final log = Logger(label);
    log.log(level, message);
  }

  /// Logs a message with a stack trace.
  /// This method is useful for logging errors or exceptions along with their stack trace.
  /// @param message The message to log.
  /// @param logLevel The level of the log (default is ERROR).
  /// @param label An optional label for the log entry (default is 'log_manager').
  /// @param stacktrace An optional stack trace to include in the log entry (default is the current stack trace).
  /// @param demangleStackTrace A flag to indicate whether to demangle the stack trace (default is true).
  /// @return void
  /// Example usage:
  /// ```dart
  /// LogManager.logWithStack(
  ///   'An error occurred',
  ///   logLevel: LogLevel.ERROR,
  ///   stacktrace: StackTrace.current,
  ///   demangleStackTrace: true,
  ///   label: 'error_logger',
  ///   );
  /// Note: Ensure that LogManager is initialized before calling this method.

  static void logWithStack(
    String message, {
    LogLevel logLevel = LogLevel.ERROR,
    String label = 'log_manager',
    StackTrace? stacktrace,
    bool demangleStackTrace = true,
  }) {
    final log = Logger(label);
    stacktrace ??= StackTrace.current;
    assert(
      logManagerIO != null,
      'LogManagerIO is not initialized. Please call LogManager.init() before logging.',
    );
    String formattedMessage = logManagerIO!
        .formatStackTrace(stacktrace, demangle: demangleStackTrace);
    log.log(logLevel.toLevel(), '$message\n$formattedMessage');
  }

  /// Returns the current instance of [LogManagerIO].
  /// This method can be used to access the underlying logging operations.
  /// @return LogManagerIO? The current instance of LogManagerIO, or null if not initialized.
  /// Example usage:
  /// ```dart
  /// LogManagerIO? logManagerIOInstance = LogManager.getLogManagerIO();
  ///   if (logManagerIOInstance != null) {
  ///     logManagerIOInstance.createConsoleBasedLog('This is a console log message');
  ///   }
  ///   Note: Ensure that LogManager is initialized before calling this method.
  static LogManagerIO? getLogManagerIO() {
    return logManagerIO;
  }
}
