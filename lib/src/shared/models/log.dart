/// A model representing a log entry with various attributes.
/// This class encapsulates the details of a log entry, including the message,
/// log level, timestamp, label, stack trace, and a flag indicating if the log is marked.
class Log {
  /// Default Constructor for [Log].
  /// Creates a new instance of [Log] with the provided parameters.
  /// @param message The log message.
  /// @param timestamp The time when the log was created.
  /// @param logLevel The level of the log (e.g., INFO, ERROR).
  /// @param label An optional label for the log entry.
  /// @param stackTrace An optional stack trace associated with the log entry.
  Log({
    required this.message,
    required this.timestamp,
    this.logLevel = 'INFO',
    this.label,
    this.stackTrace,
  });

  final String message;
  final String logLevel;
  final DateTime timestamp;
  final String? label;
  final StackTrace? stackTrace;
}
