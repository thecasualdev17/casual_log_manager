// ignore_for_file: constant_identifier_names

class LogLevel implements Comparable<LogLevel> {
  final String name;
  final int value;

  const LogLevel(this.name, this.value);

  static const LogLevel ALL = LogLevel('ALL', 0);
  static const LogLevel INFO = LogLevel('INFO', 200);
  static const LogLevel WARNING = LogLevel('WARNING', 300);
  static const LogLevel ERROR = LogLevel('ERROR', 400);
  static const LogLevel NONE = LogLevel('OFF', 2000);

  static const List<LogLevel> LOG_LEVELS = [ALL, INFO, WARNING, ERROR, NONE];

  @override
  bool operator ==(Object other) => other is LogLevel && value == other.value;

  bool operator <(LogLevel other) => value < other.value;

  bool operator <=(LogLevel other) => value <= other.value;

  bool operator >(LogLevel other) => value > other.value;

  bool operator >=(LogLevel other) => value >= other.value;

  @override
  int compareTo(LogLevel other) => value - other.value;

  @override
  int get hashCode => value;

  @override
  String toString() => name;
}
