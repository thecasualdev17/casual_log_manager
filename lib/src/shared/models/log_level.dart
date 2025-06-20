// ignore_for_file: constant_identifier_names

/// Represents a logging level with a name and integer value.
class LogLevel implements Comparable<LogLevel> {
  /// The name of the log level (e.g., 'INFO', 'ERROR').
  final String name;

  /// The integer value representing the severity of the log level.
  final int value;

  /// Creates a [LogLevel] with the given [name] and [value].
  const LogLevel(this.name, this.value);

  /// Log level for all logs (lowest severity).
  static const LogLevel ALL = LogLevel('ALL', 0);

  /// Log level for informational logs.
  static const LogLevel INFO = LogLevel('INFO', 200);

  /// Log level for warning logs.
  static const LogLevel WARNING = LogLevel('WARNING', 300);

  /// Log level for error logs (highest severity before OFF).
  static const LogLevel ERROR = LogLevel('ERROR', 400);

  /// Log level for disabling all logs.
  static const LogLevel NONE = LogLevel('OFF', 2000);

  /// List of all log levels.
  static const List<LogLevel> LOG_LEVELS = [ALL, INFO, WARNING, ERROR, NONE];

  @override
  bool operator ==(Object other) => other is LogLevel && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  int compareTo(LogLevel other) => value - other.value;
}
