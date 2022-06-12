import '../../models/local_storage_model.dart';

abstract class LogInterface{
  init();

  addLogs(Log log);

  Future<List<Log>?> getLogs();

  deleteLogs(int attendDateTime);

  close();

}