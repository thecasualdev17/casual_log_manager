import 'package:casual_log_manager/src/io/file_manager/file_manager_base.dart';

/// A web implementation of [FileManagerBase] for platforms where file operations are not supported.
class FileManager extends FileManagerBase {
  @override
  Future<bool> appendToLogFile({
    required String fileName,
    required String content,
  }) {
    throw UnimplementedError(
      'appendToLogFile is not implemented for this platform.',
    );
  }

  @override
  Future<bool> archiveLogFile({required String fileName}) {
    throw UnimplementedError(
      'archiveLogFile is not implemented for this platform.',
    );
  }

  @override
  Future<bool> clearArchiveDirectory() {
    throw UnimplementedError(
      'clearArchiveDirectory is not implemented for this platform.',
    );
  }

  @override
  Future<bool> clearLogDirectory() {
    throw UnimplementedError(
      'clearLogDirectory is not implemented for this platform.',
    );
  }

  @override
  Future<bool> createLogArchiveDirectory() {
    throw UnimplementedError(
      'createLogArchiveDirectory is not implemented for this platform.',
    );
  }

  @override
  Future<bool> createLogDirectory() {
    throw UnimplementedError(
      'createLogDirectory is not implemented for this platform.',
    );
  }

  @override
  Future<bool> createLogFile({required String fileName}) {
    throw UnimplementedError(
      'createLogFile is not implemented for this platform.',
    );
  }

  @override
  Future<bool> deleteLogArchiveFile({required String fileName}) {
    throw UnimplementedError(
      'deleteLogArchiveFile is not implemented for this platform.',
    );
  }

  @override
  Future<bool> deleteLogFile({required String fileName}) {
    throw UnimplementedError(
      'deleteLogFile is not implemented for this platform.',
    );
  }

  @override
  Future<void> initialize({
    required String logDirectory,
    required String archiveDirectory,
    required String extension,
    required String networkDirectory,
    required bool exposeLogs,
  }) {
    throw UnimplementedError(
      'initialize is not implemented for this platform.',
    );
  }

  @override
  Future<List<String>> listArchivedLogFiles() {
    throw UnimplementedError(
      'listArchivedLogFiles is not implemented for this platform.',
    );
  }

  @override
  Future<List<String>> listLogFiles() {
    throw UnimplementedError(
      'listLogFiles is not implemented for this platform.',
    );
  }

  @override
  Future<bool> logArchiveDirectoryExists() {
    throw UnimplementedError(
      'logArchiveDirectoryExists is not implemented for this platform.',
    );
  }

  @override
  Future<bool> logDirectoryExists() {
    throw UnimplementedError(
      'logDirectoryExists is not implemented for this platform.',
    );
  }

  @override
  Future<bool> markLogEntry({
    required String fileName,
    required String timestamp,
    required String mark,
  }) {
    throw UnimplementedError(
      'markLogEntry is not implemented for this platform.',
    );
  }

  @override
  Future<List<String>> readLogFile({required String fileName}) {
    throw UnimplementedError(
      'readLogFile is not implemented for this platform.',
    );
  }

  @override
  Future<bool> logFileExists({required String fileName}) {
    throw UnimplementedError(
      'logFileExists is not implemented for this platform.',
    );
  }

  @override
  Future<int> getFileSize({required String fileName}) {
    throw UnimplementedError(
      'getFileSize is not implemented for this platform.',
    );
  }

  @override
  Future<bool> appendToNetworkLogFile({
    required String fileName,
    required String content,
  }) {
    throw UnimplementedError(
      'appendToNetworkLogFile is not implemented for this platform',
    );
  }

  @override
  Future<bool> createNetworkLogFile({required String fileName}) {
    throw UnimplementedError(
      'createNetworkLogFile is not implemented for this platform',
    );
  }

  @override
  Future<bool> deleteNetworkLogFile({required String fileName}) {
    throw UnimplementedError(
      'deleteNetworkLogFile is not implemented for this platform',
    );
  }

  @override
  Future<bool> networkLogDirectoryExists() {
    throw UnimplementedError(
      'networkLogDirectoryExists is not implemented for this platform',
    );
  }

  @override
  Future<bool> networkLogFileExists({required String fileName}) {
    throw UnimplementedError(
      'networkLogFileExists is not implemented for this platform',
    );
  }

  @override
  Future<List<String>> readNetworkLogFile({required String fileName}) {
    throw UnimplementedError(
      'readNetworkLogFile is not implemented for this platform',
    );
  }

  @override
  Future<bool> createNetworkDirectory() {
    throw UnimplementedError(
      'createNetworkDirectory is not implemented for this platform',
    );
  }

  @override
  Future<int> getFileAge({required String fileName}) {
    throw UnimplementedError(
      'getFileAge is not implemented for this platform.',
    );
  }
}
