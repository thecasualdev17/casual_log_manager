import 'package:log_manager/src/io/file_writer/file_writer_base.dart';

class FileWriter extends FileWriterBase {
  @override
  Future<void> close() {
    throw UnimplementedError('FileWriter.close() is not supported for web.');
  }

  @override
  Future<void> writeFile(String data) {
    throw UnimplementedError('FileWriter.writeFile() is not supported for web.');
  }

  @override
  Future<void> init({String? rootPath, String fileName = 'log', String fileExtension = '.txt'}) {
    throw UnimplementedError('FileWriter.init() is not supported for web.');
  }
}
