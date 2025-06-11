import 'package:log_manager/src/io/file_writer/file_writer_base.dart';

class FileWriter extends FileWriterBase {
  @override
  Future<void> close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  Future<void> writeFile(String data) {
    // TODO: implement writeFile
    throw UnimplementedError();
  }

  @override
  Future<void> init({String? rootPath, String fileName = 'log', String fileExtension = '.txt'}) {
    // TODO: implement init
    throw UnimplementedError();
  }
}
