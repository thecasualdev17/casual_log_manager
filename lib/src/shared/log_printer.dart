import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class LogPrinter {
  static void print(String message, {String? label, ZoneDelegate? delegate, Zone? zone, bool pretty = false}) {
    if (pretty) {
      prettyPrint(message, label: label, delegate: delegate, zone: zone);
    } else {
      normalPrint(message, label: label, delegate: delegate, zone: zone);
    }
  }

  static void normalPrint(String message, {String? label, ZoneDelegate? delegate, Zone? zone}) {
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
  }

  static void prettyPrint(String message, {String? label, ZoneDelegate? delegate, Zone? zone}) {
    String divider = '-' * 80;
    if (delegate != null && zone != null) {
      delegate.print(zone, '');
      if (label != null) {
        delegate.print(zone, label);
      }
      delegate.print(zone, divider);
      delegate.print(zone, '>   $message');
      delegate.print(zone, divider);
    } else {
      if (Zone.current.parent != null) {
        Zone.current.parent!.print('');
        if (label != null) {
          Zone.current.parent!.print(label);
        }
        Zone.current.parent!.print(divider);
        Zone.current.parent!.print('>   $message');
        Zone.current.parent!.print(divider);
      } else {
        Zone.current.print('');
        if (label != null) {
          Zone.current.print(label);
        }
        Zone.current.print(divider);
        Zone.current.print('>   $message');
        Zone.current.print(divider);
      }
    }
  }

  static void printStack({
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
