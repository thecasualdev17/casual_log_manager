import 'dart:io';

import 'package:cronet_http/cronet_http.dart';
import 'package:cupertino_http/cupertino_http.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:log_manager/src/io/network_manager/network_client/network_client_base.dart';

class NetworkClient extends NetworkClientBase {
  late Client client;

  @override
  Future<Response> post({required Uri url, Map<String, String>? headers, Object? body}) async {
    final response = await client.post(url, headers: headers, body: body);
    return response;
  }

  @override
  void init({Client? client, String userAgent = 'LogManager Agent'}) {
    if (isAndroid()) {
      final engine =
          CronetEngine.build(cacheMode: CacheMode.memory, cacheMaxSize: 2 * 1024 * 1024, userAgent: userAgent);
      client = CronetClient.fromCronetEngine(engine, closeEngine: true);
    } else if (isMacOrIOS()) {
      final config = URLSessionConfiguration.ephemeralSessionConfiguration()
        ..cache = URLCache.withCapacity(memoryCapacity: 2 * 1024 * 1024)
        ..httpAdditionalHeaders = {'User-Agent': userAgent};
      client = CupertinoClient.fromSessionConfiguration(config);
    } else {
      client = IOClient(HttpClient()..userAgent = userAgent);
    }
  }

  bool isAndroid() {
    return Platform.isAndroid;
  }

  bool isMacOrIOS() {
    return Platform.isMacOS || Platform.isIOS;
  }
}
