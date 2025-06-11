import 'file_writer_base.dart';

class FileWriter extends FileWriterBase {
  @override
  Future<void> close() {
    throw UnimplementedError('FileWriter.close() is not implemented for this platform.');
  }

  @override
  Future<void> writeFile(String data) {
    throw UnimplementedError('FileWriter.writeFile() is not implemented for this platform.');
  }

  @override
  Future<void> init({String? rootPath, String fileName = 'log', String fileExtension = '.txt'}) {
    throw UnimplementedError('FileWriter.init() is not implemented for this platform.');
  }
}
