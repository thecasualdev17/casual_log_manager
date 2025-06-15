import '../models/log.dart';

extension NoFormatter on Log {
  /// Returns the log string in the format: timestamp -> logLevel -> label -> message -> stackTrace
  String toNoFormatString({String delimiter = ' -> '}) {
    return '${timestamp.toIso8601String()}$delimiter'
        '$logLevel$delimiter'
        '$message$delimiter'
        '${stackTrace?.toString() ?? ''}';
  }

  /// Static method to create a Log instance from a no-format string.
  /// Format: timestamp -> logLevel -> label -> message -> stackTrace
  static Log fromNoFormatString(String noFormatString, {String delimiter = ' -> '}) {
    final parts = noFormatString.split(delimiter);
    return Log(
      timestamp: parts.isNotEmpty ? DateTime.parse(parts[0]) : DateTime.now(),
      logLevel: parts.length > 1 ? parts[1] : '',
      message: parts.length > 2 ? parts[2] : '',
      stackTrace: parts.length > 3 && parts[3].isNotEmpty ? StackTrace.fromString(parts[3]) : null,
    );
  }
}
