import 'dart:async';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:log_manager/src/shared/extensions/http_status_checker.dart';
import 'package:log_manager/src/shared/models/network_options.dart';

/// NetworkManager is responsible for sending logs to a remote server
class NetworkManager {
  /// networkOptions contains the configuration for network requests
  final NetworkOptions networkOptions;

  /// dio is the HTTP client used for making network requests
  final Dio dio;

  /// Default constructor for NetworkManager
  NetworkManager({required this.networkOptions, required this.dio});

  /// Sends multiple logs to the specified [networkUrl].
  ///
  /// [networkUrl] is the endpoint to which logs are sent.
  /// [logs] is a list of log entries to send.
  /// Returns true if the request is successful, false otherwise.
  Future<bool> sendMultipleLogs({
    required String networkUrl,
    required List<Map<String, String>> logs,
  }) async {
    assert(networkUrl.isNotEmpty, 'Network Url must be provided');
    try {
      final response = await dio.request(
        networkUrl,
        data: logs,
        options: Options(
          method: 'POST',
          receiveTimeout: networkOptions.receiveTimeout,
          sendTimeout: networkOptions.sendTimeout,
          headers: networkOptions.headers,
        ),
      );
      return checkResponse(response);
    } catch (e) {
      developer.log('Error Sending log to server $e');
      return false;
    }
  }

  /// Sends a single log entry to the specified [networkUrl].
  ///
  /// [networkUrl] is the endpoint to which the log is sent.
  /// [body] is the log entry to send.
  /// Returns true if the request is successful, false otherwise.
  Future<bool> sendLog(
      {required String networkUrl, required Map<String, String> body}) async {
    assert(networkUrl.isNotEmpty, 'Network Url must be provided');
    try {
      final response = await dio.request(
        networkUrl,
        data: body,
        options: Options(
          method: 'POST',
          receiveTimeout: networkOptions.receiveTimeout,
          sendTimeout: networkOptions.sendTimeout,
          headers: networkOptions.headers,
        ),
      );
      return checkResponse(response);
    } catch (e) {
      developer.log('Error Sending log to server $e');
      return false;
    }
  }

  /// Checks the HTTP response and returns true if the status is OK.
  ///
  /// [response] is the HTTP response to check.
  /// Returns true if the response status is OK, false otherwise.
  bool checkResponse(Response response) {
    developer.log('network log: ${response.statusCode.toString()}');
    if (response.statusCode != null) {
      if (response.ok) {
        return true;
      } else {
        developer.log(response.statusMessage.toString());
        return false;
      }
    } else {
      return false;
    }
  }
}
