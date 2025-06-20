/// Abstract base class for file management operations related to logging.
abstract class FileManagerBase {
  /// Default constructor for the FileManagerBase class.
  FileManagerBase();

  /// Initializes the file manager with required directories and file extension.
  ///
  /// [logDirectory] is the directory for log files.
  /// [archiveDirectory] is the directory for archived logs.
  /// [networkDirectory] is the directory for network logs.
  /// [extension] is the file extension for log files.
  void initialize({
    required String logDirectory,
    required String archiveDirectory,
    required String networkDirectory,
    required String extension,
  });

  /// Checks if the log directory exists.
  Future<bool> logDirectoryExists();

  /// Checks if the log archive directory exists.
  Future<bool> logArchiveDirectoryExists();

  /// Checks if the network log directory exists.
  Future<bool> networkLogDirectoryExists();

  /// Creates the log directory.
  Future<bool> createLogDirectory();

  /// Creates the log archive directory.
  Future<bool> createLogArchiveDirectory();

  /// Creates the network log directory.
  Future<bool> createNetworkDirectory();

  /// Creates a log file with the given [fileName].
  Future<bool> createLogFile({required String fileName});

  /// Creates a network log file with the given [fileName].
  Future<bool> createNetworkLogFile({required String fileName});

  /// Archives a log file with the given [fileName].
  Future<bool> archiveLogFile({required String fileName});

  /// Checks if a log file exists with the given [fileName].
  Future<bool> logFileExists({required String fileName});

  /// Checks if a network log file exists with the given [fileName].
  Future<bool> networkLogFileExists({required String fileName});

  /// Lists all log files in the log directory.
  Future<List<String>> listLogFiles();

  /// Lists all archived log files in the archive directory.
  Future<List<String>> listArchivedLogFiles();

  /// Deletes a log file with the given [fileName].
  Future<bool> deleteLogFile({required String fileName});

  /// Deletes an archived log file with the given [fileName].
  Future<bool> deleteLogArchiveFile({required String fileName});

  /// Deletes a network log file with the given [fileName].
  Future<bool> deleteNetworkLogFile({required String fileName});

  /// Clears all files in the archive directory.
  Future<bool> clearArchiveDirectory();

  /// Clears all files in the log directory.
  Future<bool> clearLogDirectory();

  /// Reads the contents of a log file with the given [fileName].
  Future<List<String>> readLogFile({required String fileName});

  /// Reads the contents of a network log file with the given [fileName].
  Future<List<String>> readNetworkLogFile({required String fileName});

  /// Gets the size of a file with the given [fileName].
  Future<int> getFileSize({required String fileName});

  /// Gets the age of a file with the given [fileName] in seconds.
  Future<int> getFileAge({required String fileName});

  /// Appends [content] to a log file with the given [fileName].
  Future<bool> appendToLogFile({
    required String fileName,
    required String content,
  });

  /// Appends [content] to a network log file with the given [fileName].
  Future<bool> appendToNetworkLogFile({
    required String fileName,
    required String content,
  });

  /// Marks a log entry in a file with the given [fileName], [timestamp], and [mark].
  Future<bool> markLogEntry({
    required String fileName,
    required String timestamp,
    required String mark,
  });
}
