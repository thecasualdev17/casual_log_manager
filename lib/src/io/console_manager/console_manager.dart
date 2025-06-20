import 'dart:async';

import 'package:flutter/foundation.dart';

/// A manager for console printing with support for normal and pretty formats,
/// as well as stack trace printing.
class ConsoleManager {
  /// Prints a message to the console, with optional label and formatting.
  ///
  /// [message] is the text to print.
  /// [label] is an optional label to print before the message.
  /// [delegate] and [zone] allow custom zone-based printing.
  /// [pretty] enables pretty-printing with dividers.
  void print(String message,
      {String? label,
      ZoneDelegate? delegate,
      Zone? zone,
      bool pretty = false}) {
    if (pretty) {
      prettyPrint(message, label: label, delegate: delegate, zone: zone);
    } else {
      normalPrint(message, label: label, delegate: delegate, zone: zone);
    }
  }

  /// Prints a message in normal format, with optional label and zone support.
  ///
  /// [message] is the text to print.
  /// [label] is an optional label to print before the message.
  /// [delegate] and [zone] allow custom zone-based printing.
  void normalPrint(String message,
      {String? label, ZoneDelegate? delegate, Zone? zone}) {
    // coverage:ignore-start
    if (delegate != null && zone != null) {
      delegate.print(zone, message);
    } else {
      if (Zone.current.parent != null) {
        if (label != null) {
          Zone.current.parent!.print(label);
        }
        Zone.current.parent!.print(message);
      } else {
        if (label != null) {
          Zone.current.print(label);
        }
        Zone.current.print(message);
      }
    }
    // coverage:ignore-end
  }

  /// Prints a message in a pretty format with dividers, with optional label and zone support.
  ///
  /// [message] is the text to print.
  /// [label] is an optional label to print before the message.
  /// [delegate] and [zone] allow custom zone-based printing.
  void prettyPrint(String message,
      {String? label, ZoneDelegate? delegate, Zone? zone}) {
    String divider = '-' * 80;
    // coverage:ignore-start
    if (delegate != null && zone != null) {
      if (label != null) {
        delegate.print(zone, label);
      }
      delegate.print(zone, divider);
      delegate.print(zone, message);
      delegate.print(zone, divider);
    } else {
      if (Zone.current.parent != null) {
        if (label != null) {
          Zone.current.parent!.print(label);
        }
        Zone.current.parent!.print(divider);
        Zone.current.parent!.print(message);
        Zone.current.parent!.print(divider);
      } else {
        Zone.current.print('');
        if (label != null) {
          Zone.current.print(label);
        }
        Zone.current.print(divider);
        Zone.current.print(message);
        Zone.current.print(divider);
      }
    }
    // coverage:ignore-end
  }

  /// Prints a stack trace to the console, with optional label, formatting, and frame limit.
  ///
  /// [stackTrace] is the stack trace to print (defaults to current if null).
  /// [label] is an optional label to print before the stack trace.
  /// [delegate] and [zone] allow custom zone-based printing.
  /// [maxFrames] limits the number of stack frames to print.
  /// [pretty] enables pretty-printing with dividers.
  void printStack({
    StackTrace? stackTrace,
    String? label,
    ZoneDelegate? delegate,
    Zone? zone,
    int? maxFrames = 5,
    bool pretty = false,
  }) {
    if (stackTrace == null) {
      stackTrace = StackTrace.current;
    } else {
      stackTrace = FlutterError.demangleStackTrace(stackTrace);
    }

    Iterable<String> lines = stackTrace.toString().trimRight().split('\n');
    // coverage:ignore-start
    if (kIsWeb && lines.isNotEmpty) {
      // Remove extra call to StackTrace.current for web platform.
      // taken from flutter assertions.dart debugPrintStack
      // TODO: remove when https://github.com/flutter/flutter/issues/37635
      // is resolved.
      lines = lines.skipWhile((String line) {
        return line.contains('StackTrace.current') ||
            line.contains('dart-sdk/lib/_internal') ||
            line.contains('dart:sdk_internal');
      });
    }
    // coverage:ignore-end
    if (maxFrames != null && maxFrames > 0) {
      lines = lines.take(maxFrames);
    }

    if (lines.isEmpty) {
      return;
    }

    String stackToPrint = FlutterError.defaultStackFilter(lines).join('\n');
    if (stackToPrint.isNotEmpty) {
      if (pretty) {
        stackToPrint = '$label\n${'-' * 80}\n$stackToPrint\n${'-' * 80}';
      }

      if (delegate != null && zone != null) {
        delegate.print(zone, stackToPrint);
      } else {
        if (Zone.current.parent != null) {
          Zone.current.parent!.print(stackToPrint);
        } else {
          Zone.current.print(stackToPrint);
        }
      }
    }
  }
}
