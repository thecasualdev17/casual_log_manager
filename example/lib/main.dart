// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:log_manager/log_manager.dart';

final baseSeedColor = const Color.fromARGB(255, 57, 185, 127);
final lightColorScheme = ColorScheme.fromSeed(seedColor: baseSeedColor);
final darkColorScheme = ColorScheme.fromSeed(seedColor: baseSeedColor, brightness: Brightness.dark);

int counter = 0;

void main() {
  LogManager().init(
    onAppStart: () {
      // This is where you would initialize your app or perform any startup tasks.
      runApp(const MyApp());
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Log Manager Demo',
      theme: ThemeData(colorScheme: lightColorScheme),
      darkTheme: ThemeData(colorScheme: darkColorScheme),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void onPrintExample() {
    // This is where you would print a message to the console.
    print('This is an example print statement.');
  }

  void onLogExample() {
    // This is where you would log a message using log utils or logging package.
    LogManager.log('This is an example log statement.', logLevel: LogLevel.INFO, label: 'example');
  }

  void onExceptionExample() {
    try {
      throw Exception('This is an example exception.');
    } catch (e, stackTrace) {
      // This is where you would log the exception using log utils or logging package.
      LogManager.logWithStack('Caught an exception: $e', stacktrace: stackTrace);

      // Or you can use a normal print statement
      //print('Stack trace:\n$stackTrace');
    }
  }

  void onExceptionExampleWithoutTryCatch() {
    // This is where you would log an exception without using try/catch.
    throw Exception('This is an example exception without try/catch.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: <Widget>[
            Text('Log was created $counter times.'),
            ElevatedButton(
              onPressed: () {
                onPrintExample();
              },
              child: Text('Example Print Statement'),
            ),
            ElevatedButton(
              onPressed: () {
                onLogExample();
              },
              child: Text('Example Log Statement'),
            ),
            ElevatedButton(
              onPressed: () {
                onExceptionExample();
              },
              child: Text('Example Exception with Try/Catch'),
            ),
            ElevatedButton(
              onPressed: () {
                onExceptionExampleWithoutTryCatch();
              },
              child: Text('Example Exception without Try/Catch'),
            ),
            SizedBox(height: 20),
            TextButton(onPressed: () {}, child: Text('Show latest log')),
            TextButton(onPressed: () {}, child: Text('Get log file')),
          ],
        ),
      ),
    );
  }
}
