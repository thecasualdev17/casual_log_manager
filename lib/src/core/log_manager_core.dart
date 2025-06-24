import 'dart:async';

import 'package:casual_log_manager/casual_log_manager.dart';
import 'package:casual_log_manager/src/io/log_manager_io.dart';
import 'package:casual_log_manager/src/shared/zone_specs.dart';
import 'package:flutter/widgets.dart';

/// Core logic for the LogManager, handling initialization and unhandled exceptions.
/// This class is responsible for setting up the LogManagerIO instance and managing the application's logging behavior.
/// It provides methods to initialize the logging system, catch unhandled exceptions, and configure logging options.
class LogManagerCore {
  /// Initializes the LogManager core logic.
  ///
  /// [onAppStart] is called after log manager initialization.
  /// [options] provides configuration for logging behavior.
  /// [fileOptions] configures file logging.
  /// [networkOptions] configures network logging.
  /// [logLabel] is a label for log identification.
  void initLogManagerCore({
    required Function onAppStart,
    required Options options,
    required FileOptions fileOptions,
    required NetworkOptions networkOptions,
    required String logLabel,
    bool ensureInitialized = false,
  }) {
    if (options.preventCrashes) {
      runZonedGuarded(
        () async {
          if (ensureInitialized) {
            WidgetsFlutterBinding.ensureInitialized();
          }
          await initLogManagerIO(
            options: options,
            fileOptions: fileOptions,
            networkOptions: networkOptions,
            logLabel: logLabel,
          );
          onAppStart();
        },
        // coverage:ignore-start
        (error, stack) => catchUnhandledExceptions(error, stack, options),
        // coverage:ignore-end
        zoneSpecification: ZoneSpecs.defaultZoneSpecification(options: options),
      );
    } else {
      runZoned(() async {
        if (ensureInitialized) {
          WidgetsFlutterBinding.ensureInitialized();
        }
        await initLogManagerIO(
          options: options,
          fileOptions: fileOptions,
          networkOptions: networkOptions,
          logLabel: logLabel,
        );
        onAppStart();
      });
    }
  }

  /// Initializes the LogManagerIO instance with the provided options.
  ///
  /// [options] provides configuration for logging behavior.
  /// [fileOptions] configures file logging.
  /// [networkOptions] configures network logging.
  /// [logLabel] is a label for log identification.
  Future<void> initLogManagerIO({
    required Options options,
    required FileOptions fileOptions,
    required NetworkOptions networkOptions,
    required String logLabel,
  }) async {
    LogManager.logManagerIO = LogManagerIO(
      options: options,
      fileOptions: fileOptions,
      networkOptions: networkOptions,
      logLabel: logLabel,
    );
    await LogManager.logManagerIO?.init();
  }

  /// Handles uncaught exceptions in the application.
  ///
  /// [error] is the uncaught error object.
  /// [stack] is the associated stack trace.
  /// [options] provides configuration for logging behavior.
  Future<void> catchUnhandledExceptions(
    Object error,
    StackTrace? stack,
    Options options,
  ) async {
    // this part is somehow not needed but is required by runZoneGuarded
  }
}
