import 'dart:async';

import 'package:http/http.dart';

class NetworkOptions {
  final String networkUrl;
  final Map<String, String> headers;
  final int retryCount;
  final bool sendBatchLogs;
  final FutureOr<bool> Function(BaseResponse)? when;
  final FutureOr<bool> Function(Object, StackTrace)? whenError;
  final Duration Function(int retryCount)? delay;
  final FutureOr<void> Function(BaseRequest, BaseResponse?, int retryCount)? onRetry;

  const NetworkOptions({
    required this.networkUrl,
    this.headers = const {
      'Content-Type': 'application/json',
    },
    this.retryCount = 3,
    this.when,
    this.whenError,
    this.delay,
    this.onRetry,
    this.sendBatchLogs = false,
  });
}
