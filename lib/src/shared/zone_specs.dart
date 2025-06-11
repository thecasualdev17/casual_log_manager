import 'dart:async';

import 'package:log_manager/log_manager.dart';
import 'package:log_manager/src/shared/log_printer.dart';

abstract class ZoneSpecs {
  static ZoneSpecification defaultZoneSpecification({
    bool logToFile = false,
    bool prettyPrint = false,
    Function(String message)? onLogCreated,
  }) {
    return ZoneSpecification(
      print: (self, parent, zone, message) async {
        // Override print to handle log messages
        LogPrinter.print(message, delegate: parent, zone: zone, pretty: prettyPrint);
        if (logToFile) {
          if (LogManager.getLogManagerIO() != null && LogManager.getLogManagerIO()!.isInitialized()) {
            LogManager.getLogManagerIO()?.writeToFile(message);
          }
        }
      },
    );
  }
}
