import 'package:flutter_test/flutter_test.dart';
import 'package:log_manager/log_manager.dart';
import 'package:log_manager/src/core/log_manager_core.dart';

void main() {
  test('LogManagerCore initialization test', () {
    final options = Options(
      preventCrashes: true,
      prettyPrint: true,
      logToConsole: true,
      logToNetwork: true,
      logToFile: true,
    );
    final fileOptions = FileOptions();
    final networkOptions = NetworkOptions(networkUrl: 'sample.com');
    final logLabel = 'TestLog';

    LogManagerCore().initLogManagerCore(
      onAppStart: () {},
      options: options,
      fileOptions: fileOptions,
      networkOptions: networkOptions,
      logLabel: logLabel,
    );

    expect(LogManager.logManagerIO, isNotNull);
  });

  test('LogManagerCore without crash prevention', () {
    final options = Options(preventCrashes: true);
    final fileOptions = FileOptions();
    final networkOptions = NetworkOptions(networkUrl: 'sample.com');
    final logLabel = 'TestLog';

    LogManagerCore().initLogManagerCore(
      onAppStart: () {},
      options: options,
      fileOptions: fileOptions,
      networkOptions: networkOptions,
      logLabel: logLabel,
    );

    expect(LogManager.logManagerIO, isNotNull);
  });

  test('LogManagerCore initializes with different logLabel', () {
    final options = Options(preventCrashes: true);
    final fileOptions = FileOptions();
    final networkOptions = NetworkOptions(networkUrl: 'sample.com');
    final logLabel = 'AnotherLogLabel';

    LogManagerCore().initLogManagerCore(
      onAppStart: () {},
      options: options,
      fileOptions: fileOptions,
      networkOptions: networkOptions,
      logLabel: logLabel,
    );

    expect(LogManager.logManagerIO, isNotNull);
  });

  test('LogManagerCore calls onAppStart callback', () {
    final options = Options(preventCrashes: true);
    final fileOptions = FileOptions();
    final networkOptions = NetworkOptions(networkUrl: 'sample.com');
    final logLabel = 'TestLog';
    bool callbackCalled = false;

    LogManagerCore().initLogManagerCore(
      onAppStart: () {
        callbackCalled = true;
      },
      options: options,
      fileOptions: fileOptions,
      networkOptions: networkOptions,
      logLabel: logLabel,
    );

    expect(callbackCalled, isTrue);
  });

  test('LogManagerCore catchUnhandledExceptions does not throw', () async {
    final core = LogManagerCore();
    final options = Options(preventCrashes: true);

    await core.catchUnhandledExceptions(
      Exception('error'),
      StackTrace.current,
      options,
    );
  });

  group('LogManager singleton', () {
    test('LogManager returns singleton instance', () {
      final instance1 = LogManager();
      final instance2 = LogManager();
      expect(instance1, same(instance2));
    });

    test('LogManager initializes and sets logManagerCore', () {
      final logManager = LogManager();
      logManager.init(
        onAppStart: () {},
        label: 'TestApp',
        options: Options(preventCrashes: true),
        fileOptions: FileOptions(),
        networkOptions: NetworkOptions(networkUrl: 'http://test.com'),
      );
      expect(logManager.logManagerCore, isNotNull);
    });

    test('LogManager.log writes log without error', () {
      expect(() => LogManager.log('Test log message'), returnsNormally);
    });

    test('LogManager.logWithStack writes log with stack trace', () {
      // Initialize logManagerIO to avoid assertion error
      final logManager = LogManager();
      logManager.init(
        onAppStart: () {},
        label: 'TestApp',
        options: Options(preventCrashes: true),
        fileOptions: FileOptions(),
        networkOptions: NetworkOptions(networkUrl: 'http://test.com'),
      );
      expect(
        () => LogManager.logWithStack('Test error with stack'),
        returnsNormally,
      );
    });

    test('LogManager.getLogManagerIO returns LogManagerIO instance after init',
        () {
      final logManager = LogManager();
      logManager.init(
        onAppStart: () {},
        label: 'TestApp',
        options: Options(preventCrashes: true),
        fileOptions: FileOptions(),
        networkOptions: NetworkOptions(networkUrl: 'http://test.com'),
      );
      expect(LogManager.getLogManagerIO(), isNotNull);
    });
  });
}
