export 'file_writer_stub.dart'
    if (dart.library.io) 'file_writer_io.dart' // for native platforms
    if (dart.library.html) 'file_writer_web.dart'; // for web/wasm
