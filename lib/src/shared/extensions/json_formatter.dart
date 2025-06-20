// coverage:ignore-file
import 'dart:convert';

import '../models/log.dart';

/// Extension to provide JSON serialization and deserialization for [Log] objects.
extension JsonFormatter on Log {
  /// Converts the [Log] object to a JSON string.
  ///
  /// Returns a JSON-encoded string representing the log entry.
  String toJsonString() {
    final jsonMap = {
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'label': label,
      'stackTrace': stackTrace?.toString(),
      'logLevel': logLevel.toString(),
    };
    return json.encode(jsonMap);
  }

  /// Creates a [Log] object from a JSON string.
  ///
  /// [jsonString] is the JSON-encoded string representing a log entry.
  /// Returns a [Log] object with the parsed data.
  static Log fromJsonString(String jsonString) {
    final jsonMap = jsonString.isNotEmpty
        ? Map<String, dynamic>.from(json.decode(jsonString))
        : {};

    return Log(
      message: jsonMap['message'] ?? '',
      timestamp: DateTime.parse(
        jsonMap['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      label: jsonMap['label'],
      stackTrace: jsonMap['stackTrace'] != null
          ? StackTrace.fromString(jsonMap['stackTrace'])
          : null,
      logLevel: jsonMap['logLevel'],
    );
  }
}
