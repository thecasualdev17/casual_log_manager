import 'dart:io';

import 'package:casual_log_manager/src/io/file_manager/file_manager_io.dart';
import 'package:test/test.dart';

void main() {
  late FileManager fileManager;
  const logDir = 'test_logs';
  const archiveDir = 'test_logs_archive';
  const networkDir = 'test_logs_network';
  const ext = 'log';

  setUp(() async {
    fileManager = FileManager();
    fileManager.initialize(
      logDirectory: logDir,
      archiveDirectory: archiveDir,
      networkDirectory: networkDir,
      extension: ext,
    );
    await fileManager.clearLogDirectory();
    await fileManager.clearArchiveDirectory();
    await fileManager.createNetworkDirectory();
  });

  tearDown(() async {
    await Directory(logDir).delete(recursive: true);
    await Directory(archiveDir).delete(recursive: true);
    await Directory(networkDir).delete(recursive: true);
  });

  test('creates log directory', () async {
    await fileManager.createLogDirectory();
    expect(await Directory(logDir).exists(), isTrue);
  });

  test('creates log file', () async {
    final result = await fileManager.createLogFile(fileName: 'test1');
    expect(result, isTrue);
    expect(await File('$logDir/test1.$ext').exists(), isTrue);
  });

  test('lists log files', () async {
    await fileManager.createLogFile(fileName: 'test2');
    final files = await fileManager.listLogFiles();
    expect(files, contains('test2.log'));
  });

  test('appends and reads log file', () async {
    await fileManager.createLogFile(fileName: 'test3');
    await fileManager.appendToLogFile(fileName: 'test3', content: 'line1\n');
    final lines = await fileManager.readLogFile(fileName: 'test3');
    expect(lines, contains('line1'));
  });

  test('deletes log file', () async {
    await fileManager.createLogFile(fileName: 'test4');
    final deleted = await fileManager.deleteLogFile(fileName: 'test4');
    expect(deleted, isTrue);
    expect(await File('$logDir/test4.$ext').exists(), isFalse);
  });

  test('archives log file', () async {
    await fileManager.createLogFile(fileName: 'test5');
    await fileManager.appendToLogFile(fileName: 'test5', content: 'archive');
    final archived = await fileManager.archiveLogFile(fileName: 'test5.log');
    expect(archived, isTrue);
    final archivedFiles = await fileManager.listArchivedLogFiles();
    expect(archivedFiles.any((f) => f.contains('test5.log')), isTrue);
  });
}
