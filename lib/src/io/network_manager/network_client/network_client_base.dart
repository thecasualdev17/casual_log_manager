import 'package:http/http.dart';

abstract class NetworkClientBase {
  NetworkClientBase();

  void init({Client? client, String userAgent});

  Future<Response> post({required Uri url, Map<String, String>? headers, Object? body});
}
