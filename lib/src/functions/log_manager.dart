import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:log_manager/src/shared/log_level.dart';
import 'package:log_manager/src/shared/log_printer.dart';
import 'package:log_manager/src/shared/options.dart';
import 'package:log_manager/src/shared/zone_specs.dart';
import 'package:logging/logging.dart';

import '../io/log_manager_io.dart';

class LogManager {
  /// Singleton instance of LogManager
  /// This ensures that only one instance of LogManager exists throughout the app.
  ///   /// This is achieved through a private constructor and a static instance variable.
  LogManager._internal();

  static final LogManager _instance = LogManager._internal();

  static LogManagerIO? logManagerIO;

  static Function(String message)? _onLogCreated;

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
  void init({required Function onAppStart, Function(String message)? onLogCreated, Options options = const Options()}) {
    if (options.preventCrashes) {
      runZonedGuarded(
        () {
          WidgetsFlutterBinding.ensureInitialized();
          _onLogCreated = onLogCreated;
          if (options.logToFile) {
            logManagerIO = LogManagerIO();
            logManagerIO!.init();
          }

          Logger.root.level = Level.ALL; // Set the root logger level to ALL
          Logger.root.onRecord.listen((record) {
            LogPrinter.print(record.message, pretty: options.prettyPrint, label: record.loggerName);
            if (options.logToFile) {
              if (LogManager.getLogManagerIO() != null && LogManager.getLogManagerIO()!.isInitialized()) {
                LogManager.getLogManagerIO()?.writeToFile(record.message, stacktrace: record.stackTrace);
              }
            }
          });

          FlutterError.onError = (FlutterErrorDetails details) {
            catchUnhandledExceptions(details.exception, details.stack, options, _onLogCreated);
          };
          onAppStart();
        },
        (error, stack) => catchUnhandledExceptions(error, stack, options, _onLogCreated),
        zoneSpecification: ZoneSpecs.defaultZoneSpecification(
          prettyPrint: options.prettyPrint,
          logToFile: options.logToFile,
        ), // Use the default zone specification
      );
    } else {
      runZoned(() {
        WidgetsFlutterBinding.ensureInitialized();
        FlutterError.onError = (FlutterErrorDetails details) {
          catchUnhandledExceptions(details.exception, details.stack, options, _onLogCreated);
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
  Future<void> catchUnhandledExceptions(
    Object error,
    StackTrace? stack,
    Options options,
    Function(String message)? onLogCreated,
  ) async {
    LogPrinter.printStack(stackTrace: stack, label: error.toString(), pretty: options.prettyPrint);
    if (options.logToFile) {
      if (LogManager.getLogManagerIO() != null && LogManager.getLogManagerIO()!.isInitialized()) {
        LogManager.getLogManagerIO()?.writeToFile(error.toString(), stacktrace: stack);
      }
    }
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

  static void setOnLogCreated(Function(String message) onLogCreated) {
    _onLogCreated = onLogCreated;
  }

  static Function(String message)? getOnLogCreated() {
    return _onLogCreated;
  }

  static LogManagerIO? getLogManagerIO() {
    return logManagerIO;
  }

  static void dispose() {
    logManagerIO?.dispose();
  }
}
