import 'dart:async';

import 'package:casual_log_manager/casual_log_manager.dart';

/// Provides custom [ZoneSpecification]s for logging and error handling.
abstract class ZoneSpecs {
  /// Returns the default [ZoneSpecification] for logging.
  ///
  /// [options] specifies logging options to use for log output.
  ///
  /// The default specification intercepts print statements and routes them to the log manager.
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
