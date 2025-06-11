abstract class FileWriterBase {
  Future<void> init({String? rootPath, String fileName = 'log', String fileExtension = '.txt'});

  /// Writes the given [data] to the file at the specified [path].
  ///
  /// Returns a [Future] that completes when the write operation is done.
  Future<void> writeFile(String data);

  /// Closes the file writer, releasing any resources held.
  ///
  /// Returns a [Future] that completes when the writer is closed.
  Future<void> close();
}
