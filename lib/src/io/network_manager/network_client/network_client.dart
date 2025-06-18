export 'network_client_stub.dart'
    if (dart.library.io) 'network_client_io.dart'
    if (dart.library.html) 'network_client_web.dart';
