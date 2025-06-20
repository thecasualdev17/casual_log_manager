/// Configuration for log retention policies, such as file size, count, age, and compression.
class RetentionPolicy {
  /// Creates a [RetentionPolicy] with the given configuration.
  ///
  /// [enabled] enables or disables retention policy enforcement.
  /// [maxFileSize] sets the maximum file size in bytes for a log file (default: 10 MB).
  /// [maxFileCount] sets the maximum number of log files to keep (default: 10).
  /// [maxLogAge] sets the maximum age of logs in seconds (default: 7 days).
  /// [maxLogCount] sets the maximum number of logs to keep in memory (default: 1000).
  /// [compressLogs] enables compression of logs when saving.
  /// [encryptLogs] enables encryption of logs when saving.
  RetentionPolicy({
    required this.enabled,
    this.maxFileSize = 10 * 1024 * 1024, // 10 MB
    this.maxFileCount = 10,
    this.maxLogAge = 7 * 24 * 60 * 60, // 7 days
    this.maxLogCount = 1000,
    this.compressLogs = true,
    this.encryptLogs = false,
  });

  /// Whether retention policy is enabled.
  final bool enabled;

  /// Maximum file size in bytes for a log file.
  final int maxFileSize;

  /// Maximum number of log files to keep.
  final int maxFileCount;

  /// Maximum age of logs in seconds (0 means no limit).
  final int maxLogAge;

  /// Maximum number of logs to keep in memory.
  final int maxLogCount;

  /// Whether to compress logs when saving.
  final bool compressLogs;

  /// Whether to encrypt logs when saving.
  final bool encryptLogs;
}
