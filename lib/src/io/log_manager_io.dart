import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:log_manager/log_manager.dart';
import 'package:log_manager/src/io/network_manager/network_manager.dart';
import 'package:log_manager/src/shared/extensions/level_converter.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

import 'console_manager/console_manager.dart';
import 'file_manager/file_manager.dart';

class LogManagerIO {
  LogManagerIO({
    required this.options,
    required this.fileOptions,
    required this.networkOptions,
  }) {
    init();
  }

  final Options options;
  final FileOptions fileOptions;
  final NetworkOptions networkOptions;
  String? _rootPath;
  late FileManager _fileManager;
  late ConsoleManager _consoleManager;
  late NetworkManager _networkManager;

  int loggingSequenceNumber = 0;

  Future<void> init() async {
    initLogging(options);

    FlutterError.onError = (FlutterErrorDetails details) {
      catchUnhandledExceptions(details.exception, details.stack, options);
    };

    initConsoleLogs();
    initNetworkLogs();
    await initFileBaseLogs();
  }

  Future<void> catchUnhandledExceptions(Object error, StackTrace? stack, Options options) async {
    await createLog(
      error.toString(),
      logLevel: LogLevel.ERROR,
      stacktrace: stack,
      options: options,
    );
  }

  void initConsoleLogs() {
    if (options.logToConsole) {
      _consoleManager = ConsoleManager();
    }
  }

  void initNetworkLogs() {
    if (options.logToNetwork) {
      _networkManager = NetworkManager(networkOptions: networkOptions);
    }
  }

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
      );
    }
  }

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

  Future<void> createLog(
    String logMessage, {
    LogLevel logLevel = LogLevel.INFO,
    Options options = const Options(),
    StackTrace? stacktrace,
  }) async {
    String logContent = createLogContent(
      logMessage,
      logLevel: logLevel,
      stacktrace: stacktrace,
      demangleStackTrace: options.demangleStackTrace,
    );

    if (options.logToConsole) {
      await createConsoleBasedLog(logContent);
    }

    if (options.logToFile) {
      await createFileBasedLog(logContent);
    }

    if (options.logToNetwork) {
      await createNetworkLog(logContent);
    }
  }

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

  Future<void> createNetworkLog(String content) async {
    _networkManager.sendLog(networkUrl: networkOptions.networkUrl, body: {'body': content});
  }

  Future<void> createConsoleBasedLog(String logContent) async {
    _consoleManager.print(logContent, pretty: options.prettyPrint);
  }

  String createLogContent(
    String message, {
    LogLevel logLevel = LogLevel.INFO,
    StackTrace? stacktrace,
    bool demangleStackTrace = true,
  }) {
    final now = DateTime.now();
    final timestamp = '${now.toIso8601String()} | ';

    String combinedMessage = addTimeStampOnEveryNewLine('${logLevel.name} | $message', timestamp);
    if (stacktrace != null) {
      combinedMessage += '\n${addTimeStampOnEveryNewLine(
        formatStackTrace(stacktrace, demangle: demangleStackTrace),
        timestamp,
      )}';
    }
    return '$combinedMessage\n';
  }

  String formatStackTrace(StackTrace stacktrace, {bool demangle = true}) {
    if (demangle) {
      FlutterError.demangleStackTrace(stacktrace).toString();
    }
    return stacktrace.toString();
  }

  String addTimeStampOnEveryNewLine(String content, String timestamp) {
    return content.split('\n').map((line) => '$timestamp$line').join('\n');
  }

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
