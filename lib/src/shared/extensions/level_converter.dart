import 'package:log_manager/log_manager.dart';
import 'package:logging/logging.dart';

extension LevelConverter on LogLevel {
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

extension LogLevelConverter on Level {
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
