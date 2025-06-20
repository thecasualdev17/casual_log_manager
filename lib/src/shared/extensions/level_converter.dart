// coverage:ignore-file

import 'package:log_manager/log_manager.dart';
import 'package:logging/logging.dart';

/// Extension to convert between [LogLevel] and [Level] enums.
extension LevelConverter on LogLevel {
  /// Converts a [Level] from the logging package to a [LogLevel].
  static LogLevel fromLevel(Level level) {
    switch (level) {
      case Level.ALL:
        return LogLevel.ALL;
      case Level.INFO:
        return LogLevel.INFO;
      case Level.SEVERE:
        return LogLevel.ERROR;
      case Level.WARNING:
        return LogLevel.WARNING;
      case Level.OFF:
        return LogLevel.NONE;
      default:
        return LogLevel.INFO; // Default to INFO if no match
    }
  }

  /// Converts this [LogLevel] to a [Level] from the logging package.
  Level toLevel() {
    Level level = Level.ALL;
    switch (this) {
      case LogLevel.ALL:
        level = Level.ALL;
        break;
      case LogLevel.INFO:
        level = Level.INFO;
        break;
      case LogLevel.ERROR:
        level = Level.SEVERE;
        break;
      case LogLevel.WARNING:
        level = Level.WARNING;
        break;
      case LogLevel.NONE:
        level = Level.OFF;
        break;
    }
    return level;
  }
}

/// Extension to convert between [Level] and [LogLevel].
extension LogLevelConverter on Level {
  /// Converts a [LogLevel] to a [Level] from the logging package.
  LogLevel toLogLevel() {
    switch (this) {
      case Level.ALL:
        return LogLevel.ALL;
      case Level.INFO || Level.CONFIG:
        return LogLevel.INFO;
      case Level.SEVERE || Level.SHOUT:
        return LogLevel.ERROR;
      case Level.WARNING:
        return LogLevel.WARNING;
      case Level.OFF:
        return LogLevel.NONE;
      default:
        return LogLevel.INFO; // Default to INFO if no match
    }
  }

  /// Converts a [LogLevel] to a [Level] from the logging package.
  static Level fromLogLevel(LogLevel logLevel) {
    switch (logLevel) {
      case LogLevel.ALL:
        return Level.ALL;
      case LogLevel.INFO:
        return Level.INFO;
      case LogLevel.ERROR:
        return Level.SEVERE;
      case LogLevel.WARNING:
        return Level.WARNING;
      case LogLevel.NONE:
        return Level.OFF;
      default:
        return Level.INFO; // Default to INFO if no match
    }
  }
}
