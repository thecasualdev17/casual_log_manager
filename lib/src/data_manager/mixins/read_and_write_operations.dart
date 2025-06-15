import 'package:log_manager/src/shared/models/log.dart';

import '../data_manager_base.dart';

mixin ReadAndWriteOperations on DataManagerBase {
  void push(Log log) {
    logs.add(log);
  }

  void popLog() {
    if (logs.isNotEmpty) {
      logs.removeLast();
    }
  }

  void clear() {
    logs.clear();
  }

  void pushLogs(List<Log> newLogs) {
    logs.addAll(newLogs);
  }

  void getLogs(List<Log> logs) {
    this.logs = logs;
  }

  List<Log> getAndPopLogs(int count) {
    if (count <= 0 || logs.isEmpty) return [];
    final logsToReturn = logs.take(count).toList();
    logs.removeRange(0, count);
    return logsToReturn;
  }
}
