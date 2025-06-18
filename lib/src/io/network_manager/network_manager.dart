import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:log_manager/src/io/network_manager/network_client/network_client_io.dart';
import 'package:log_manager/src/shared/models/network_options.dart';

class NetworkManager {
  final NetworkOptions networkOptions;
  late NetworkClient networkClient;

  NetworkManager({required this.networkOptions, http.Client? client}) {
    networkClient = NetworkClient();
    networkClient.init();
  }

  Future<void> sendLogsInBatch({
    required String networkUrl,
    required List<Map<String, String>> logs,
  }) async {
    assert(networkUrl.isNotEmpty, 'Network Url must be provided');
    // List<http.Response?> multiResponse = await Future.wait(logs.map((log) async {
    //   final response = await _client.post(
    //     Uri.parse(networkUrl),
    //     body: log,
    //     headers: networkOptions.headers,
    //   );
    //   return response;
    // }));
    // return multiResponse;
  }

  Future<bool> sendLog({required String networkUrl, required Map<String, String> body}) async {
    assert(networkUrl.isNotEmpty, 'Network Url must be provided');
    try {
      final response = await networkClient
          .post(
            url: Uri.parse(networkUrl),
            body: jsonEncode(body),
            headers: networkOptions.headers,
          )
          .timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      developer.log('Error Sending log to server $e');
      return false;
    }
  }
}
