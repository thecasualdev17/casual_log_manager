import 'dart:async';

import 'package:log_manager/log_manager.dart';

abstract class ZoneSpecs {
  static ZoneSpecification defaultZoneSpecification({
    Options options = const Options(),
  }) {
    return ZoneSpecification(
      print: (self, parent, zone, message) async {
        LogManager.getLogManagerIO()?.createLog(message, options: options);
      },
    );
  }
}
