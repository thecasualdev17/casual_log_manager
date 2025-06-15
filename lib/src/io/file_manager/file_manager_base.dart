abstract class FileManagerBase {
  FileManagerBase();

  void initialize({
    required String logDirectory,
    required String archiveDirectory,
    required String extension,
  });

  Future<bool> logDirectoryExists();

  Future<bool> logArchiveDirectoryExists();

  Future<bool> createLogDirectory();

  Future<bool> createLogArchiveDirectory();

  Future<bool> createLogFile({required String fileName});

  Future<bool> archiveLogFile({required String fileName});

  Future<bool> logFileExists({required String fileName});

  Future<List<String>> listLogFiles();

  Future<List<String>> listArchivedLogFiles();

  Future<bool> deleteLogFile({required String fileName});

  Future<bool> deleteLogArchiveFile({required String fileName});

  Future<bool> clearArchiveDirectory();

  Future<bool> clearLogDirectory();

  Future<List<String>> readLogFile({required String fileName});

  Future<int> getFileSize({required String fileName});

  Future<bool> appendToLogFile({
    required String fileName,
    required String content,
  });

  Future<bool> markLogEntry({
    required String fileName,
    required String timestamp,
    required String mark,
  });
}
