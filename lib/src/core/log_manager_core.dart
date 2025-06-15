import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:log_manager/log_manager.dart';
import 'package:log_manager/src/io/log_manager_io.dart';
import 'package:log_manager/src/shared/zone_specs.dart';

class LogManagerCore {
  initLogManagerCore({
    required Function onAppStart,
    Function(String message)? onLogCreated,
    required Options options,
    required FileOptions fileOptions,
    required NetworkOptions networkOptions,
  }) {
    if (options.preventCrashes) {
      runZonedGuarded(
        () {
          WidgetsFlutterBinding.ensureInitialized();
          initLogManagerIO(options, fileOptions, networkOptions);
          onAppStart();
        },
        (error, stack) => catchUnhandledExceptions(error, stack, options, onLogCreated),
        zoneSpecification: ZoneSpecs.defaultZoneSpecification(options: options), // Use the default zone specification
      );
    } else {
      runZoned(() {
        WidgetsFlutterBinding.ensureInitialized();
        initLogManagerIO(options, fileOptions, networkOptions);
        onAppStart();
      });
    }
  }

  void initLogManagerIO(
    Options options,
    FileOptions fileOptions,
    NetworkOptions networkOptions,
  ) {
    LogManager.logManagerIO = LogManagerIO(
      options: options,
      fileOptions: fileOptions,
      networkOptions: networkOptions,
    );
  }

  Future<void> catchUnhandledExceptions(
    Object error,
    StackTrace? stack,
    Options options,
    Function(String message)? onLogCreated,
  ) async {
    // this part is somehow not needed but is required by runZoneGuarded
  }
}
