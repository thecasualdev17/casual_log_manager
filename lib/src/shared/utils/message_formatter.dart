// coverage:ignore-file

/// Formats a log message for output, optionally including quotes around the message.
///
/// [message] is the log message to format.
/// [header] is the header or key for the log entry.
/// [includeQuotesInMessage] determines if the message should be wrapped in quotes (default: true).
///
/// Returns a formatted string in the form 'header="message"' or 'header=message'.
String logFormatter(
  String message,
  String header, {
  bool includeQuotesInMessage = true,
}) {
  if (includeQuotesInMessage) {
    message = '"$message"';
  }
  return '$header=$message';
}
