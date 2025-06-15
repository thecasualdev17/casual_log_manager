import 'data_manager_base.dart';
import 'mixins/read_and_write_operations.dart';

class DataManager extends DataManagerBase with ReadAndWriteOperations {
  DataManager();
}
