// coverage:ignore-file

/// Enum representing supported log formats.
enum LogFormats {
  /// JSON log format.
  json('json'),

  /// Plain text log format.
  plainText('plain_text');

  /// The string value associated with the log format.
  final String value;

  /// Const constructor for [LogFormats].
  const LogFormats(this.value);

  @override
  String toString() {
    return value;
  }

  /// Returns the [LogFormats] value matching the given [format] string.
  ///
  /// If no match is found, defaults to [LogFormats.plainText].
  static LogFormats fromString(String format) {
    return LogFormats.values.firstWhere(
      (e) => e.value.toLowerCase() == format.toLowerCase(),
      orElse: () => LogFormats.plainText,
    );
  }
}
