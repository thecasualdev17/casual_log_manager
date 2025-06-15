enum LogFormats {
  json('json'),
  plainText('plain_text');

  final String value;

  const LogFormats(this.value);

  @override
  String toString() {
    return value;
  }

  static LogFormats fromString(String format) {
    return LogFormats.values.firstWhere(
      (e) => e.value.toLowerCase() == format.toLowerCase(),
      orElse: () => LogFormats.plainText,
    );
  }
}
