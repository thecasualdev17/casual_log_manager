import 'dart:async';
import 'dart:io';

import 'package:log_manager/src/shared/log_level.dart';
import 'package:path_provider/path_provider.dart';

class FileWriterBk {
  final String? rootPath;
  final String fileName;
  final String fileExtension;
  late final IOSink _sink;
  bool _isInitialized = false;

  FileWriterBk({this.rootPath, this.fileName = 'app', this.fileExtension = '.log'}) {
    _init();
  }

  Future<void> _init() async {
    if (_isInitialized) return;
    final basePath = await getApplicationDocumentsDirectory();
    final directory = Directory(rootPath ?? '${basePath.path}/logs');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final file = File('${directory.path}/$fileName$fileExtension');

    if (!await file.exists()) {
      await file.create(recursive: true);
    }

    _sink = file.openWrite(mode: FileMode.append);
    _isInitialized = true;

    _logInternal('FileWriter initialized at ${file.path}', level: LogLevel.INFO, identifier: 'system');
  }

  Future<void> writeToFile(
    String message, {
    LogLevel logLevel = LogLevel.INFO,
    String identifier = 'log_manager',
    StackTrace? stacktrace,
  }) async {
    if (!_isInitialized) {
      throw Exception('FileWriter is not initialized. Call init() before writing to file.');
    }

    final timestamp = DateTime.now().toIso8601String();
    final levelName = logLevel.name.toUpperCase();

    final logEntry = StringBuffer()..write('$timestamp | $levelName | $identifier: $message');
    if (stacktrace != null) {
      logEntry.writeln('\nStackTrace:\n$stacktrace');
    }

    _sink.writeln(logEntry.toString());
  }

  Future<void> dispose() async {
    if (!_isInitialized) return;

    _logInternal('Disposing FileWriter and flushing logs.', level: LogLevel.INFO, identifier: 'system');
    await _sink.flush();
    await _sink.close();
    _isInitialized = false;
  }

  void _logInternal(String message, {LogLevel level = LogLevel.INFO, String identifier = 'system'}) {
    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.toString().split('.').last.toUpperCase();
    _sink.writeln('[$timestamp][$levelStr][$identifier] $message');
  }
}
