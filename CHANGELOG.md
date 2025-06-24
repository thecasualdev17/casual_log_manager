## 0.1.0

-Initial Version

## 0.2.0

- Added network logging support with configurable `NetworkOptions`.
- Improved log message formatting and stack trace handling.
- Enhanced initialization logic with `LogManagerCore` and `initLogManagerCore`.
- Added support for custom log labels.
- Improved error handling for uninitialized `LogManagerIO`.
- Updated documentation and usage examples for logging methods.
- Internal refactoring and code cleanup
- Added log filters for console, file and network logs.

## 0.2.1

- Added ensureInitialized parameter in `init`

## 0.2.2

- Enhanced error handling and assertions in logging methods.
- Minor internal refactoring and code cleanup.
- Added base log level for `print` method to make sure prints from libraries are not logged
  accidentally.