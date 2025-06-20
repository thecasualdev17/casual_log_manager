import 'package:flutter_test/flutter_test.dart';
import 'package:casual_log_manager/src/io/console_manager/console_manager.dart';

void main() {
  ConsoleManager consoleManager = ConsoleManager();
  String message = 'Test message';
  test('test with normal print', () {
    expect(() => consoleManager.print(message), returnsNormally);
  });

  test('test with pretty print', () {
    expect(() => consoleManager.print(message, pretty: true), returnsNormally);
  });

  test('test with blank print stack', () {
    expect(() => consoleManager.printStack(), returnsNormally);
  });

  test('test with blank print stack with pretty', () {
    expect(() => consoleManager.printStack(pretty: true), returnsNormally);
  });

  test('test with print stack', () {
    expect(() => consoleManager.printStack(stackTrace: StackTrace.current),
        returnsNormally);
  });
}
