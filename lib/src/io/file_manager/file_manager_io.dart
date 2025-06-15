import 'dart:convert';
import 'dart:io';

import 'file_manager_base.dart';

class FileManager extends FileManagerBase {
  late String logDirectory;
  late String archiveDirectory;
  late String extension;

  Future<List<String>> listFilesInDirectory(String directory) async {
    final dir = Directory(directory);
    if (await dir.exists()) {
      final files = await dir.list().where((entity) => entity is File).toList();
      return files.map((file) => file.uri.pathSegments.last).toList();
    }
    return [];
  }

  Future<bool> createDirectory(String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      try {
        await dir.create(recursive: true);
        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
    }
    return Future.value(true);
  }

  Future<bool> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      try {
        file.delete();
        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
    }
    return Future.value(true);
  }

  Future<bool> clearDirectory(String directoryPath, Function onClear) async {
    final dir = Directory(directoryPath);
    if (await dir.exists()) {
      try {
        dir.delete(recursive: true);
        onClear();
        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
    }
    onClear();
    return Future.value(true);
  }

  @override
  void initialize({required String logDirectory, required String archiveDirectory, required String extension}) {
    this.logDirectory = logDirectory;
    this.archiveDirectory = archiveDirectory;
    this.extension = extension;

    createLogDirectory();
    createLogArchiveDirectory();
  }

  @override
  Future<bool> logArchiveDirectoryExists() {
    return Directory(logDirectory).exists();
  }

  @override
  Future<bool> logDirectoryExists() {
    return Directory(archiveDirectory).exists();
  }

  @override
  Future<bool> createLogDirectory() {
    return createDirectory(logDirectory);
  }

  @override
  Future<bool> createLogArchiveDirectory() {
    return createDirectory(archiveDirectory);
  }

  @override
  Future<bool> createLogFile({required String fileName}) async {
    if (await logDirectoryExists()) {
      final file = File('$logDirectory/$fileName.$extension');
      if (!await file.exists()) {
        try {
          await file.create(recursive: true);
          return Future.value(true);
        } catch (e) {
          return Future.value(false);
        }
      } else {
        return Future.value(true);
      }
    } else {
      await createLogDirectory();
      return await createLogFile(fileName: fileName);
    }
  }

  @override
  Future<bool> archiveLogFile({required String fileName}) async {
    final sourceFile = File('$logDirectory/$fileName');
    String archivePath = '$archiveDirectory/$fileName';
    File archiveFile = File(archivePath);

    if (await sourceFile.exists()) {
      try {
        if (!await logArchiveDirectoryExists()) {
          await createLogArchiveDirectory();
        }
        int counter = 1;
        while (await archiveFile.exists()) {
          archivePath = '$counter.$archiveDirectory/$fileName';
          archiveFile = File(archivePath);
          counter++;
        }
        await sourceFile.rename(archiveFile.path);
        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
    }
    return Future.value(true);
  }

  @override
  Future<List<String>> listLogFiles() async {
    return listFilesInDirectory(logDirectory);
  }

  @override
  Future<List<String>> listArchivedLogFiles() async {
    return listFilesInDirectory(archiveDirectory);
  }

  @override
  Future<bool> deleteLogFile({required String fileName}) {
    return deleteFile('$logDirectory/$fileName.$extension');
  }

  @override
  Future<bool> deleteLogArchiveFile({required String fileName}) {
    return deleteFile('$archiveDirectory/$fileName.$extension');
  }

  @override
  Future<bool> clearArchiveDirectory() async {
    return clearDirectory(archiveDirectory, () async {
      await createLogArchiveDirectory();
    });
  }

  @override
  Future<bool> clearLogDirectory() async {
    return clearDirectory(logDirectory, () async {
      await createLogDirectory();
    });
  }

  @override
  Future<List<String>> readLogFile({required String fileName}) async {
    final file = File('$logDirectory/$fileName.$extension');
    if (await file.exists()) {
      return file.readAsLines(encoding: utf8);
    }
    return Future.value([]);
  }

  @override
  Future<bool> appendToLogFile({required String fileName, required String content}) async {
    final file = File('$logDirectory/$fileName.$extension');
    if (await file.exists()) {
      try {
        await file.writeAsString(content, mode: FileMode.append);
        return true;
      } catch (e) {
        return false;
      }
    } else {
      await createLogFile(fileName: fileName);
      return await appendToLogFile(fileName: fileName, content: content);
    }
  }

  @override
  Future<bool> markLogEntry({required String fileName, required String timestamp, required String mark}) async {
    final file = File('$logDirectory/$fileName.$extension');
    if (await file.exists()) {
      try {
        final lines = await file.readAsLines();
        final updatedLines = lines.map((line) {
          if (line.startsWith(timestamp)) {
            return '$mark:$line';
          }
          return line;
        }).toList();
        await file.writeAsString(updatedLines.join('\n'));
        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
    }
    return Future.value(true);
  }

  @override
  Future<bool> logFileExists({required String fileName}) {
    final file = File('$logDirectory/$fileName.$extension');
    return file.exists().then((exists) => Future.value(exists));
  }

  @override
  Future<int> getFileSize({required String fileName}) {
    final file = File('$logDirectory/$fileName.$extension');
    return file.exists().then((exists) {
      if (exists) {
        return file.length();
      }
      return Future.value(0);
    });
  }
}
