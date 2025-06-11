import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:log_manager/src/shared/log_level.dart';
import 'package:log_manager/src/shared/log_printer.dart';
import 'package:log_manager/src/shared/options.dart';
import 'package:log_manager/src/shared/zone_specs.dart';
import 'package:logging/logging.dart';

class LogManager {
  /// Singleton instance of LogManager
  /// This ensures that only one instance of LogManager exists throughout the app.
  ///   /// This is achieved through a private constructor and a static instance variable.
  LogManager._internal();

  static final LogManager _instance = LogManager._internal();

  /// Private constructor for singleton pattern
  /// This constructor is private to prevent direct instantiation.
  /// LogManager._internal();
  factory LogManager() {
    return _instance;
  }

  /// Initializes the LogManager with the given options.
  /// This method sets up the Flutter environment and configures error handling based on the provided options.
  /// [options] - An instance of [Options] that specifies how the LogManager should behave.
  /// If [options.preventCrashes] is true, it will run the app in a zone that catches unhandled exceptions
  /// and prevents the app from crashing. Otherwise, it runs in a normal zone.
  void init({required Function onAppStart, Options options = const Options()}) {
    if (options.preventCrashes) {
      runZonedGuarded(
        () {
          WidgetsFlutterBinding.ensureInitialized();
          Logger.root.level = Level.ALL; // Set the root logger level to ALL
          Logger.root.onRecord.listen((record) {
            LogPrinter.print(record.message, pretty: true, label: record.loggerName);
          });

          FlutterError.onError = (FlutterErrorDetails details) {
            catchUnhandledExceptions(details.exception, details.stack);
          };
          onAppStart();
        },
        catchUnhandledExceptions,
        zoneSpecification: ZoneSpecs.defaultZoneSpecification(prettyPrint: true), // Use the default zone specification
      );
    } else {
      runZoned(() {
        WidgetsFlutterBinding.ensureInitialized();
        FlutterError.onError = (FlutterErrorDetails details) {
          catchUnhandledExceptions(details.exception, details.stack);
        };
        onAppStart();
      });
    }
  }

  /// Catches unhandled exceptions and prints the error and stack trace.
  /// This method is called when an unhandled exception occurs in the app.
  /// It prints the error message and stack trace to the console.
  /// @param error The error object that was thrown.
  /// @param stack The stack trace associated
  /// with the error, if available.
  /// This method is useful for debugging and logging purposes,
  /// allowing developers to see what went wrong in the app.
  Future<void> catchUnhandledExceptions(Object error, StackTrace? stack) async {
    LogPrinter.printStack(stackTrace: stack, label: error.toString(), pretty: true);
  }

  static void log(String message, {LogLevel logLevel = LogLevel.INFO, String identifier = 'log_manager'}) {
    Level level = Level.LEVELS.firstWhere(
      (e) => e.name.toLowerCase() == logLevel.name.toLowerCase(),
      orElse: () => Level.INFO,
    );

    final log = Logger(identifier);
    log.log(level, message);
  }

  static void logWithStack(
    String message, {
    LogLevel logLevel = LogLevel.ALL,
    String identifier = 'log_manager',
    StackTrace? stacktrace,
  }) {
    Level level = Level.LEVELS.firstWhere(
      (e) => e.name.toLowerCase() == logLevel.name.toLowerCase(),
      orElse: () => Level.ALL,
    );

    final log = Logger(identifier);
    log.log(level, message);
    LogPrinter.printStack(stackTrace: stacktrace);
  }
}
