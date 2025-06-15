import 'dart:convert';

import '../models/log.dart';

extension JsonFormatter on Log {
  String toJsonString() {
    final jsonMap = {
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'label': label,
      'stackTrace': stackTrace?.toString(),
      'logLevel': logLevel.toString(),
    };
    return jsonMap.toString();
  }

  static Log fromJsonString(String jsonString) {
    final jsonMap = jsonString.isNotEmpty ? Map<String, dynamic>.from(json.decode(jsonString)) : {};

    return Log(
      message: jsonMap['message'] ?? '',
      timestamp: DateTime.parse(jsonMap['timestamp'] ?? DateTime.now().toIso8601String()),
      label: jsonMap['label'],
      stackTrace: jsonMap['stackTrace'] != null ? StackTrace.fromString(jsonMap['stackTrace']) : null,
      logLevel: jsonMap['logLevel'],
    );
  }
}
