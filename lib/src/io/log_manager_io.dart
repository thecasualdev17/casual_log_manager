import 'package:log_manager/src/io/file_writer/file_writer.dart';

import '../../log_manager.dart';

class LogManagerIO {
  LogManagerIO({this.rootPath, this.fileName = 'app', this.fileExtension = '.log'});

  final String? rootPath;
  final String fileName;
  final String fileExtension;
  bool _isInitialized = false;
  late FileWriter _fileWriter;

  void init() {
    if (_isInitialized) return;

    // Initialize the file writer
    _fileWriter = FileWriter();
    _fileWriter.init(rootPath: rootPath, fileName: fileName, fileExtension: fileExtension);
    _isInitialized = true;
  }

  bool isInitialized() {
    return _isInitialized;
  }

  Future<void> writeToFile(
    String message, {
    LogLevel logLevel = LogLevel.INFO,
    String identifier = 'log_manager',
    StackTrace? stacktrace,
  }) async {
    if (!_isInitialized) {
      throw Exception('LogManagerIO is not initialized. Call init() before writing to file.');
    }
    String combinedMessage = '${logLevel.name} | $identifier | $message';
    if (stacktrace != null) {
      combinedMessage += '\nStackTrace: ${stacktrace.toString()}';
    }
    await _fileWriter.writeFile(combinedMessage);

    if (LogManager.getOnLogCreated() != null) {
      LogManager.getOnLogCreated()?.call(combinedMessage);
    }
  }

  Future<void> dispose() async {
    if (!_isInitialized) return;
    await _fileWriter.close();
    _isInitialized = false;
  }
}
