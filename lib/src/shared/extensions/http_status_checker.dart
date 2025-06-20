// coverage:ignore-file
import 'package:dio/dio.dart' as http;

/// Extension on [http.Response] to check if the response status code indicates success.
extension IsOk on http.Response {
  /// [ok] checks if the response status code indicates a successful request.
  bool get ok {
    if (statusCode == null) {
      return false;
    }
    return (statusCode! ~/ 100) == 2;
  }
}
