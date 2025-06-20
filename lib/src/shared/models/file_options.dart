import 'package:log_manager/log_manager.dart';

/// Configuration options for file-based logging.
class FileOptions {
  /// The log grouping strategy for file rotation.
  final LogGroups logGroup;

  /// The format used for log files.
  final LogFormats logFormat;

  /// The maximum file size in bytes before rotation/archiving.
  final int maxFileSize;

  /// The file extension for log files.
  final String fileExtension;

  /// Whether to expose logs in a user-accessible directory.
  final bool exposeLogs;

  /// Whether to encrypt log files.
  final bool encryptLogs;

  /// The maximum age of logs in seconds before they are considered for deletion.
  final int maxLogAge;

  /// Creates a [FileOptions] instance with the given configuration.
  ///
  /// [logGroup] sets the log grouping strategy.
  /// [logFormat] sets the log file format.
  /// [maxFileSize] sets the maximum file size in bytes.
  /// [fileExtension] sets the file extension for log files.
  /// [exposeLogs] determines if logs are exposed to the user.
  /// [encryptLogs] determines if logs are encrypted.
  const FileOptions({
    this.logGroup = LogGroups.daily,
    this.logFormat = LogFormats.plainText,
    this.maxFileSize = 2 * 1024 * 1024, // 2 MB
    this.fileExtension = 'log',
    this.exposeLogs = true,
    this.encryptLogs = false,
    this.maxLogAge = 7 * 24 * 60 * 60, // 7 days
  });
}
