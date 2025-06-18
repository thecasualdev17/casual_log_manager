import 'package:http/http.dart';
import 'package:log_manager/src/io/network_manager/network_client/network_client_base.dart';

class NetworkClient extends NetworkClientBase {
  @override
  Future<Response> post({required Uri url, Map<String, String>? headers, Object? body}) {
    throw UnimplementedError('post() is not supported in this platform');
  }

  @override
  void init({Client? client, String userAgent = 'LogManager Agent'}) {
    throw UnimplementedError('init() is not supported in this platform');
  }
}
