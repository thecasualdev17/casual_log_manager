import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:log_manager/log_manager.dart';
import 'package:log_manager/src/io/network_manager/network_manager.dart';
import 'package:log_manager/src/shared/extensions/level_converter.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stack_trace/stack_trace.dart';

import 'console_manager/console_manager.dart';
import 'file_manager/file_manager.dart';

/// LogManagerIO handles logging to console, file, and network destinations.
class LogManagerIO {
  /// Creates a LogManagerIO instance with the given options and initializes logging.
  ///
  /// [options] - General logging options.
  /// [fileOptions] - File logging options.
  /// [networkOptions] - Network logging options.
  /// [logLabel] - Default label for logs.
  LogManagerIO({
    required this.options,
    required this.fileOptions,
    required this.networkOptions,
    required this.logLabel,
  }) {
    init();
  }

  /// General logging options.
  final Options options;

  /// File logging options.
  final FileOptions fileOptions;

  /// Network logging options.
  final NetworkOptions networkOptions;

  /// Default label for logs.
  final String logLabel;
  String? _rootPath;
  late FileManager _fileManager;
  late ConsoleManager _consoleManager;
  late NetworkManager _networkManager;

  /// Sequence number for logs.
  int loggingSequenceNumber = 0;

  /// Initializes logging, error handlers, and log destinations.
  Future<void> init() async {
    initLogging(options);

    FlutterError.onError = (FlutterErrorDetails details) {
      catchUnhandledExceptions(details.exception, details.stack, options);
    };

    initConsoleLogs();
    await initFileBaseLogs();
    await initNetworkLogs();
  }

  /// Handles uncaught exceptions and logs them as errors.
  Future<void> catchUnhandledExceptions(Object error, StackTrace? stack, Options options) async {
    await createLog(
      error.toString(),
      logLevel: LogLevel.ERROR,
      stacktrace: stack,
      options: options,
    );
  }

  /// Initializes console logging if enabled in options.
  void initConsoleLogs() {
    if (options.logToConsole) {
      _consoleManager = ConsoleManager();
    }
  }

  /// Initializes network logging and scheduler if enabled in options.
  Future<void> initNetworkLogs() async {
    if (!options.logToFile) {
      await initFileBaseLogs();
    }
    if (options.logToNetwork) {
      _networkManager = NetworkManager(
        networkOptions: networkOptions,
        dio: dio.Dio(),
      );
      await initScheduler();
    }
  }

  /// Initializes a periodic scheduler for sending network logs.
  Future<void> initScheduler() async {
    Timer.periodic(Duration(seconds: 15), (Timer t) async {
      await sendNetworkLogs();
    });
  }

  /// Initializes file-based logging if enabled in options.
  Future<void> initFileBaseLogs() async {
    if (options.logToFile) {
      _fileManager = FileManager();
      if (fileOptions.exposeLogs) {
        _rootPath = (await getDownloadsDirectory())?.path;
      } else {
        _rootPath = (await getApplicationDocumentsDirectory()).path;
      }

      _fileManager.initialize(
        logDirectory: '$_rootPath/logs',
        archiveDirectory: '$_rootPath/archive',
        extension: fileOptions.fileExtension,
        networkDirectory: '$_rootPath/network',
      );
    }

    cleanOldLogsFromArchive();
  }

  /// Deletes old logs from the archive directory based on the maximum log age.
  void cleanOldLogsFromArchive() async {
    final existingLogs = await _fileManager.listArchivedLogFiles();
    for (var logFile in existingLogs) {
      if (await _fileManager.getFileAge(fileName: logFile) > fileOptions.maxLogAge) {
        await _fileManager.deleteLogFile(fileName: logFile);
      }
    }
  }

  /// Sets up the root logger and listens for log records.
  void initLogging(Options options) {
    Logger.root.level = Level.ALL; // Set the root logger level to ALL
    Logger.root.onRecord.listen((record) async {
      await createLog(
        record.message,
        logLevel: record.level.toLogLevel(),
        stacktrace: record.stackTrace,
        options: options,
      );
    });
  }

  /// Creates a log entry and sends it to the enabled destinations.
  ///
  /// [logMessage] - The message to log.
  /// [label] - Optional label for the log.
  /// [logLevel] - The severity level of the log.
  /// [options] - Logging options for this log.
  /// [stacktrace] - Optional stack trace to include.
  Future<void> createLog(
    String logMessage, {
    String? label,
    LogLevel logLevel = LogLevel.INFO,
    Options options = const Options(),
    StackTrace? stacktrace,
  }) async {
    DateTime logDate = DateTime.now();

    String logContent = createLogContent(
      logMessage,
      label: label,
      logLevel: logLevel,
      stacktrace: stacktrace,
      demangleStackTrace: options.demangleStackTrace,
      logDate: logDate,
    );

    if (options.logToConsole) {
      await createConsoleBasedLog(logContent);
    }

    if (options.logToFile) {
      await createFileBasedLog(logContent);
    }

    if (options.logToNetwork) {
      await createNetworkLog(logContent, logDate);
    }
  }

  /// Creates a file-based log entry, handling file rotation and archiving.
  Future<void> createFileBasedLog(String logContent) async {
    String baseFileName = getBaseFileName();
    if (await _fileManager.logFileExists(fileName: baseFileName)) {
      final fileSize = await _fileManager.getFileSize(fileName: baseFileName);
      if (fileSize >= fileOptions.maxFileSize) {
        await _fileManager.archiveLogFile(fileName: baseFileName);
      } else {
        await _fileManager.appendToLogFile(
          fileName: baseFileName,
          content: logContent,
        );
      }
    } else {
      final existingLogs = await _fileManager.listLogFiles();
      for (var e in existingLogs) {
        await _fileManager.archiveLogFile(fileName: e);
      }
      await _fileManager.createLogFile(fileName: baseFileName);
      await createFileBasedLog(logContent);
    }
  }

  /// Appends a log entry to the network log file for later upload.
  Future<void> createNetworkLog(String content, DateTime dateTime) async {
    await _fileManager.appendToNetworkLogFile(
      fileName: networkOptions.networkLogsFileName,
      content: formatContentForNetwork(content),
    );
  }

  /// Sends all pending network logs in batches and clears the log file if successful.
  Future<void> sendNetworkLogs() async {
    List<String> contents = await _fileManager.readNetworkLogFile(fileName: networkOptions.networkLogsFileName);
    if (contents.isEmpty) {
      return;
    }
    List<List<Map<String, String>>> requests = [];
    while (contents.isNotEmpty) {
      if (contents.length > networkOptions.maxLogsPerBatch) {
        List<Map<String, String>> body =
            contents.getRange(0, networkOptions.maxLogsPerBatch).map((String e) => {'body': e}).toList();
        requests.add(body);
        contents = contents.sublist(networkOptions.maxLogsPerBatch, contents.length);
      } else {
        List<Map<String, String>> body = contents.map((String e) => {'body': e}).toList();
        contents.clear();
        requests.add(body);
      }
    }

    final res = await Future.wait(requests.map((e) async {
      return await _networkManager.sendMultipleLogs(
        networkUrl: networkOptions.networkUrl,
        logs: e,
      );
    }));

    if (res.every((element) => element == true)) {
      await _fileManager.deleteNetworkLogFile(fileName: networkOptions.networkLogsFileName);
      return;
    }
  }

  /// Formats log content for network transmission.
  String formatContentForNetwork(String content) {
    List<String> lines = content.split('\n');
    String firstLine = lines[0];
    List<String> firstLineContent = firstLine.split(options.logDelimiter);
    String timeStamp = firstLineContent[0].trim();
    String logLevel = firstLineContent[1].trim();
    String logLabel = firstLineContent[2].trim();
    String logMessage = firstLineContent[3].trim();
    String stack = '';
    if (lines.length > 1) {
      StringBuffer buffer = StringBuffer();
      int counter = 0;
      for (var line in lines..removeAt(0)) {
        if (counter > networkOptions.maxFrames) break;
        buffer.write('$counter${line.split(options.logDelimiter).last.replaceAll(RegExp(r"\s+"), ' ')}|');
        counter++;
      }
      stack = buffer.toString();
    }
    String timeStampMsg = networkOptions.logFormatter.call(timeStamp, 'timestamp');
    String logLevelMsg = networkOptions.logFormatter.call(logLevel, 'level');
    String logLabelMsg = networkOptions.logFormatter.call(logLabel, 'label');
    String logMessageMsg = networkOptions.logFormatter.call(logMessage, 'message');
    String networkContent = '$timeStampMsg $logLevelMsg $logLabelMsg $logMessageMsg';
    if (stack.isNotEmpty) {
      networkContent += ' ${networkOptions.logFormatter(stack.toString(), 'trace')}';
    }
    return '$networkContent\n';
  }

  /// Creates a console-based log entry.
  Future<void> createConsoleBasedLog(String logContent) async {
    _consoleManager.print(logContent, pretty: options.prettyPrint);
  }

  /// Formats the log message and stack trace into a single log content string.
  String createLogContent(
    String message, {
    String? label,
    LogLevel logLevel = LogLevel.INFO,
    StackTrace? stacktrace,
    bool demangleStackTrace = true,
    DateTime? logDate,
  }) {
    final now = logDate ?? DateTime.now();
    final timestamp = '${now.toIso8601String()} ${options.logDelimiter} ';

    String combinedMessage = addTimeStampOnEveryNewLine(
      '${logLevel.name} ${options.logDelimiter} ${label ?? logLabel} ${options.logDelimiter} $message',
      timestamp,
    );
    if (stacktrace != null) {
      combinedMessage += '\n${addTimeStampOnEveryNewLine(
        formatStackTrace(stacktrace, demangle: demangleStackTrace),
        timestamp,
      )}';
    }
    return '$combinedMessage\n';
  }

  /// Formats a stack trace for logging, optionally demangling it.
  String formatStackTrace(StackTrace stacktrace, {bool demangle = true}) {
    if (demangle) {
      stacktrace = FlutterError.demangleStackTrace(stacktrace);
    }
    Chain chain = Chain.parse(stacktrace.toString()).terse;
    return chain.toString();
  }

  /// Adds a timestamp to every new line in the log content.
  String addTimeStampOnEveryNewLine(String content, String timestamp) {
    return content.split('\n').map((line) => '$timestamp$line').join('\n');
  }

  /// Returns the base file name for the current log group.
  String getBaseFileName() {
    final now = DateTime.now();
    String baseFileName = '${now.year}${now.month}';
    switch (fileOptions.logGroup) {
      case LogGroups.daily:
        baseFileName += '${now.day}';
        break;
      case LogGroups.everyTwoDays:
        baseFileName += '${(now.day ~/ 2) + 1}';
        break;
      case LogGroups.everyThreeDays:
        baseFileName += '${(now.day ~/ 3) + 1}';
        break;
      case LogGroups.weekly:
        baseFileName += '${(now.day ~/ 8) + 1}';
      case LogGroups.biWeekly:
        baseFileName += '${(now.day ~/ 16) + 1}';
        break;
      case LogGroups.monthly:
        break;
    }
    return baseFileName;
  }
}
