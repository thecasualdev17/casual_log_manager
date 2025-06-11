import 'package:log_manager/src/io/file_writer/file_writer.dart';

import '../../log_manager.dart';

class LogManagerIO {
  LogManagerIO({this.rootPath, this.fileName = 'app', this.fileExtension = '.log'}) {
    _init();
  }

  final String? rootPath;
  final String fileName;
  final String fileExtension;
  bool _isInitialized = false;
  late FileWriter _fileWriter;

  void _init() {
    if (_isInitialized) return;

    // Initialize the file writer
    _fileWriter = FileWriter();
    _fileWriter.init(rootPath: rootPath, fileName: fileName, fileExtension: fileExtension);
    _isInitialized = true;
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

    await _fileWriter.writeFile(
      '$message | ${logLevel.name} | $identifier \n StackTrace: ${stacktrace?.toString() ?? 'null'}',
    );
  }
}
