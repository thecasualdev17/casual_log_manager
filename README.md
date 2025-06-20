# log_manager

A lightweight and flexible logging utility for Dart and Flutter projects.

`log_manager` helps you manage, filter, and output logs efficiently during development and
production. It provides convenient wrappers and implementations on top of the popular [
`logging`](https://pub.dev/packages/logging) package.

## Features

- Simple API for logging at different levels (info, warning, error, etc.)
- Customizable log formatters and outputs
- Log filtering by level or tag
- Integration with Dart and Flutter
- Easily extendable for custom log sinks
- Prints logs to console
- Writes logs to files
- Sends logs to remote servers or services

## Usage

Import and use the logger in your Dart or Flutter project:

```dart
import 'package:log_manager/log_manager.dart';

void main() {
  LogManager().init(
    onAppStart: () {
      // This is where you would initialize your app or perform any startup tasks.
      runApp(const MyApp());
      // This is an example log.
      LogManager.log(
        'This is an example log statement.',
        logLevel: LogLevel.INFO,
        label: 'example',
      );
    },
    label: 'log label example app',
    options: Options(
      preventCrashes: true,
      logToFile: true,
      logToNetwork: true,
      prettyPrint: true,
      logToConsole: true, //
    ),
    networkOptions: const NetworkOptions(networkUrl: 'https://example.com/logs/'),
  );
}
```

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

© 2025 The Casual Dev - Ronald Erosa. Released under the MIT License.
