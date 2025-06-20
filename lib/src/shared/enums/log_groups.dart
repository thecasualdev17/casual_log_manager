// coverage:ignore-file

/// Enum representing supported log grouping strategies for log file rotation.
enum LogGroups {
  /// Group logs by day.
  daily('daily'),

  /// Group logs every two days.
  everyTwoDays('every_two_days'),

  /// Group logs every three days.
  everyThreeDays('every_three_days'),

  /// Group logs weekly.
  weekly('weekly'),

  /// Group logs bi-weekly.
  biWeekly('bi_weekly'),

  /// Group logs monthly.
  monthly('monthly');

  /// The string value associated with the log group.
  final String value;

  /// Const constructor for [LogGroups].
  const LogGroups(this.value);

  @override
  String toString() {
    return value;
  }

  /// Returns the [LogGroups] value matching the given [group] string.
  ///
  /// If no match is found, defaults to [LogGroups.daily].
  static LogGroups fromString(String group) {
    return LogGroups.values.firstWhere(
      (e) => e.value.toLowerCase() == group.toLowerCase(),
      orElse: () => LogGroups.daily,
    );
  }
}
