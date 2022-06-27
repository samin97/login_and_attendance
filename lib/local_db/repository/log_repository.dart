import 'package:first_app/local_db/db/sqlite_db.dart';
import '../../models/local_storage_model.dart';

class LogRepository{
  static var dbObject;

  static init(){
    dbObject = SqliteMethods();
    SqliteMethods().init();
  }
  static addLogs(Log log) => SqliteMethods().addLogs(log);

  static deleteLogs(String? attendDateTime) => dbObject.deleteLogs(attendDateTime);

  static getLogs() => dbObject.getLogs();

  static close() => dbObject.close();

}