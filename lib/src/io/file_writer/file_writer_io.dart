import 'dart:convert';
import 'dart:io';

import 'package:log_manager/src/io/file_writer/file_writer_base.dart';
import 'package:path_provider/path_provider.dart';

class FileWriter extends FileWriterBase {
  String? logFilePath;
  IOSink? _sink;
  bool isInitialized = false;

  @override
  Future<void> init({String? rootPath, String fileName = 'log', String fileExtension = '.txt'}) async {
    if (isInitialized) return;
    final basePath = rootPath ?? (await getDownloadsDirectory())?.path;
    final Directory directory = Directory('$basePath/logs');
    // if (!await directory.exists()) {
    //   await directory.create(recursive: true);
    // }

    final File file = File('${directory.path}/$fileName$fileExtension');

    // if (!await file.exists()) {
    //   await file.create(recursive: true);
    // }

    logFilePath = file.path;
    _sink = file.openWrite(mode: FileMode.writeOnlyAppend, encoding: utf8);
    isInitialized = true;
  }

  @override
  Future<void> writeFile(String data) async {
    if (!isInitialized) {
      throw Exception('FileWriter is not initialized. Call init() before writing to file.');
    }
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '$timestamp | $data \n';
    _sink?.write(logEntry);
    _sink?.writeln();
  }

  @override
  Future<void> close() async {
    if (!isInitialized) return;
    await _sink?.flush();
    await _sink?.close();
    isInitialized = false;
  }
}
