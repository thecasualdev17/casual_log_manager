import 'package:log_manager/src/shared/utils/message_formatter.dart' as mf;

/// Configuration options for network-based logging.
class NetworkOptions {
  /// The URL endpoint to which logs are sent.
  final String networkUrl;

  /// HTTP headers to include in network requests.
  final Map<String, String> headers;

  /// Number of retry attempts for failed requests.
  final int retryCount;

  /// Whether to send logs in batches.
  final bool sendBatchLogs;

  /// Optional function to determine delay between retries.
  final Duration Function(int retryCount)? delay;

  /// Timeout for receiving a response.
  final Duration receiveTimeout;

  /// Timeout for sending a request.
  final Duration sendTimeout;

  /// The file name used for storing network logs locally.
  final String networkLogsFileName;

  /// Maximum number of stack frames to include in logs.
  final int maxFrames;

  /// Maximum number of logs to send in a single batch.
  final int maxLogsPerBatch;

  /// Function to format the entire log entry for network transmission.
  final String Function(String message, String header) logFormatter;

  /// Function to format the log message for network transmission.
  final String Function(String message, String header) messageFormatter;

  /// Function to format the stack trace for network transmission.
  final String Function(String message, String header) stackTraceFormatter;

  /// Creates a [NetworkOptions] instance with the given configuration.
  ///
  /// [networkUrl] sets the endpoint for log transmission.
  /// [headers] sets HTTP headers for requests.
  /// [retryCount] sets the number of retry attempts.
  /// [delay] sets the delay function for retries.
  /// [sendBatchLogs] enables or disables batch sending.
  /// [receiveTimeout] sets the receive timeout duration.
  /// [sendTimeout] sets the send timeout duration.
  /// [networkLogsFileName] sets the local file name for network logs.
  /// [maxFrames] sets the maximum stack frames to include.
  /// [maxLogsPerBatch] sets the maximum logs per batch.
  /// [logFormatter], [messageFormatter], and [stackTraceFormatter] set formatting functions.
  const NetworkOptions({
    required this.networkUrl,
    this.headers = const {
      'Content-Type': 'application/json',
    },
    this.retryCount = 3,
    this.delay,
    this.sendBatchLogs = false,
    this.receiveTimeout = const Duration(seconds: 5),
    this.sendTimeout = const Duration(seconds: 5),
    this.networkLogsFileName = 'network_logs',
    this.maxFrames = 10,
    this.maxLogsPerBatch = 50,
    this.logFormatter = mf.logFormatter,
    this.messageFormatter = mf.logFormatter,
    this.stackTraceFormatter = mf.logFormatter,
  });
}
