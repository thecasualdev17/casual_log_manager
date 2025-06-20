import 'dart:convert';
import 'dart:io';

import 'file_manager_base.dart';

/// A class to manage file operations such as creating, deleting, and listing files.
class FileManager extends FileManagerBase {
  /// logDirectory is the directory where log files are stored.
  late String logDirectory;

  /// archiveDirectory is the directory where archived log files are stored.
  late String archiveDirectory;

  /// networkDirectory is the directory where network log files are stored.
  late String networkDirectory;

  /// extension is the file extension used for log files.
  late String extension;

  /// Lists all files in the given [directory].
  Future<List<String>> listFilesInDirectory(String directory) async {
    final dir = Directory(directory);
    if (await dir.exists()) {
      final files = await dir.list().where((entity) => entity is File).toList();
      return files.map((file) => file.uri.pathSegments.last).toList();
    }
    return [];
  }

  /// Creates a directory at the given [path] if it does not exist.
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

  /// Creates a file with [fileName] in the specified [directory].
  Future<bool> createFile(String directory, String fileName) async {
    if (await createDirectory(directory)) {
      final file = File('$directory/$fileName.$extension');
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
      return Future.value(false);
    }
  }

  /// Deletes the file at [filePath].
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

  /// Clears all files in [directoryPath] and calls [onClear] after clearing.
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

  /// Initializes the file manager with required directories and file extension.
  Future<void> initialize({
    required String logDirectory,
    required String archiveDirectory,
    required String networkDirectory,
    required String extension,
  }) async {
    this.logDirectory = logDirectory;
    this.archiveDirectory = archiveDirectory;
    this.networkDirectory = networkDirectory;
    this.extension = extension;

    await createLogDirectory();
    await createLogArchiveDirectory();
    await createNetworkDirectory();
  }

  @override

  /// Checks if the log archive directory exists.
  Future<bool> logArchiveDirectoryExists() {
    return Directory(logDirectory).exists();
  }

  @override

  /// Checks if the log directory exists.
  Future<bool> logDirectoryExists() {
    return Directory(archiveDirectory).exists();
  }

  @override

  /// Creates the log directory.
  Future<bool> createLogDirectory() {
    return createDirectory(logDirectory);
  }

  @override

  /// Creates the log archive directory.
  Future<bool> createLogArchiveDirectory() {
    return createDirectory(archiveDirectory);
  }

  @override

  /// Creates a log file with the given [fileName].
  Future<bool> createLogFile({required String fileName}) async {
    return createFile(logDirectory, fileName);
  }

  @override

  /// Archives a log file with the given [fileName].
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

  /// Lists all log files in the log directory.
  Future<List<String>> listLogFiles() async {
    return listFilesInDirectory(logDirectory);
  }

  @override

  /// Lists all archived log files in the archive directory.
  Future<List<String>> listArchivedLogFiles() async {
    return listFilesInDirectory(archiveDirectory);
  }

  @override

  /// Deletes a log file with the given [fileName].
  Future<bool> deleteLogFile({required String fileName}) {
    return deleteFile('$logDirectory/$fileName.$extension');
  }

  @override

  /// Deletes an archived log file with the given [fileName].
  Future<bool> deleteLogArchiveFile({required String fileName}) {
    return deleteFile('$archiveDirectory/$fileName.$extension');
  }

  @override

  /// Clears all files in the archive directory and recreates it.
  Future<bool> clearArchiveDirectory() async {
    return clearDirectory(archiveDirectory, () async {
      await createLogArchiveDirectory();
    });
  }

  @override

  /// Clears all files in the log directory and recreates it.
  Future<bool> clearLogDirectory() async {
    return clearDirectory(logDirectory, () async {
      await createLogDirectory();
    });
  }

  @override

  /// Reads the contents of a log file with the given [fileName].
  Future<List<String>> readLogFile({required String fileName}) async {
    final file = File('$logDirectory/$fileName.$extension');
    if (await file.exists()) {
      return file.readAsLines(encoding: utf8);
    }
    return Future.value([]);
  }

  @override

  /// Appends [content] to a log file with the given [fileName].
  Future<bool> appendToLogFile(
      {required String fileName, required String content}) async {
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

  /// Marks a log entry in a file with the given [fileName], [timestamp], and [mark].
  Future<bool> markLogEntry({
    required String fileName,
    required String timestamp,
    required String mark,
  }) async {
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

  /// Checks if a log file exists with the given [fileName].
  Future<bool> logFileExists({required String fileName}) {
    final file = File('$logDirectory/$fileName.$extension');
    return file.exists().then((exists) => Future.value(exists));
  }

  @override

  /// Gets the size of a file with the given [fileName].
  Future<int> getFileSize({required String fileName}) {
    final file = File('$logDirectory/$fileName.$extension');
    return file.exists().then((exists) {
      if (exists) {
        return file.length();
      }
      return Future.value(0);
    });
  }

  @override

  /// Appends [content] to a network log file with the given [fileName].
  Future<bool> appendToNetworkLogFile(
      {required String fileName, required String content}) async {
    final file = File('$networkDirectory/$fileName.$extension');
    if (await file.exists()) {
      try {
        await file.writeAsString(content, mode: FileMode.append);
        return true;
      } catch (e) {
        return false;
      }
    } else {
      await createNetworkLogFile(fileName: fileName);
      return await appendToNetworkLogFile(fileName: fileName, content: content);
    }
  }

  @override

  /// Creates a network log file with the given [fileName].
  Future<bool> createNetworkLogFile({required String fileName}) async {
    return createFile(networkDirectory, fileName);
  }

  @override

  /// Deletes a network log file with the given [fileName].
  Future<bool> deleteNetworkLogFile({required String fileName}) {
    return deleteFile('$networkDirectory/$fileName.$extension');
  }

  @override

  /// Reads the contents of a network log file with the given [fileName].
  Future<List<String>> readNetworkLogFile({required String fileName}) async {
    final file = File('$networkDirectory/$fileName.$extension');
    if (await file.exists()) {
      return file.readAsLines(encoding: utf8);
    }
    return Future.value([]);
  }

  @override

  /// Checks if the network log directory exists.
  Future<bool> networkLogDirectoryExists() {
    return Directory(networkDirectory).exists();
  }

  @override

  /// Checks if a network log file exists with the given [fileName].
  Future<bool> networkLogFileExists({required String fileName}) {
    final file = File('$networkDirectory/$fileName.$extension');
    return file.exists().then((exists) => Future.value(exists));
  }

  @override

  /// Creates the network log directory.
  Future<bool> createNetworkDirectory() {
    return createDirectory(networkDirectory);
  }

  @override
  Future<int> getFileAge({required String fileName}) {
    final file = File('$logDirectory/$fileName.$extension');
    return file.exists().then((exists) async {
      if (exists) {
        final age =
            DateTime.now().difference(await file.lastModified()).inSeconds;
        return Future.value(age);
      }
      return Future.value(0);
    });
  }
}
