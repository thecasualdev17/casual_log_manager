import 'package:log_manager/log_manager.dart';

class FileOptions {
  final LogGroups logGroup;
  final LogFormats logFormat;
  final int maxFileSize;
  final String fileExtension;
  final bool exposeLogs;
  final bool encryptLogs;

  const FileOptions({
    this.logGroup = LogGroups.daily,
    this.logFormat = LogFormats.plainText,
    this.maxFileSize = 2 * 1024 * 1024, // 2 MB
    this.fileExtension = 'log',
    this.exposeLogs = true,
    this.encryptLogs = false,
  });
}
