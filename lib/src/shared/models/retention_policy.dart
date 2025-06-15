class RetentionPolicy {
  RetentionPolicy({
    required this.enabled,
    this.maxFileSize = 10 * 1024 * 1024, // 10 MB
    this.maxFileCount = 10,
    this.maxLogAge = 7 * 24 * 60 * 60, // 7 days
    this.maxLogCount = 1000,
    this.compressLogs = true,
    this.encryptLogs = false,
  });

  final bool enabled;
  final int maxFileSize; // in bytes
  final int maxFileCount; // maximum number of log files to keep
  final int maxLogAge; // in seconds, 0 means no limit
  final int maxLogCount; // maximum number of logs to keep in memory
  final bool compressLogs; // whether to compress logs when saving
  final bool encryptLogs; // whether to encrypt logs when saving
}
