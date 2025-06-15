enum LogGroups {
  daily('daily'),
  everyTwoDays('every_two_days'),
  everyThreeDays('every_three_days'),
  weekly('weekly'),
  biWeekly('bi_weekly'),
  monthly('monthly');

  final String value;

  const LogGroups(this.value);

  @override
  String toString() {
    return value;
  }

  static LogGroups fromString(String group) {
    return LogGroups.values.firstWhere(
      (e) => e.value.toLowerCase() == group.toLowerCase(),
      orElse: () => LogGroups.daily,
    );
  }
}
