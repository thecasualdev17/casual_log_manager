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

  /// [message] is the content of the log entry.
  final String message;

  /// [logLevel] indicates the severity or type of the log entry (e.g., INFO, ERROR).
  final String logLevel;

  /// [timestamp] is the date and time when the log entry was created.
  final DateTime timestamp;

  /// [label] is an optional identifier for the log entry, useful for categorization.
  final String? label;

  /// [stackTrace] is an optional stack trace associated with the log entry,
  final StackTrace? stackTrace;
}
