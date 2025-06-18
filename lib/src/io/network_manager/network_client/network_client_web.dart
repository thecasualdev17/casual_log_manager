import 'package:fetch_client/fetch_client.dart';
import 'package:http/http.dart';
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
    client = FetchClient(mode: RequestMode.cors);
  }
}
