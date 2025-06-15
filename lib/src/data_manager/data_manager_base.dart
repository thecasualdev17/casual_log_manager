import 'package:log_manager/src/shared/models/log.dart';

abstract class DataManagerBase {
  List<Log> logs = [];

  /// Returns the last log entry or null if no logs are available.
  /// If there are no logs, it returns null.
  Log? get lastLog => logs.isNotEmpty ? logs.last : null;

  /// Returns the number of log entries.
  /// This is the total count of logs stored in the manager's list.
  int get logCount => logs.length;

  /// Checks if there are any logs available.
  /// Returns true if there are logs, false otherwise.
  bool get hasLogs => logs.isNotEmpty;
}
