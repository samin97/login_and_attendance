import 'package:first_app/local_db/db/sqlite_db.dart';
import 'package:flutter/material.dart';
import '../../models/local_storage_model.dart';

class LogRepository{
  static var dbObject;

  static init(){
    dbObject = SqliteMethods();
    dbObject.init();
  }
  static addLogs(Log log) => dbObject.addLogs(log);

  static deleteLogs(int attendDateTime) => dbObject.deleteLogs(attendDateTime);

  static getLogs() => dbObject.getLogs();

  static close() => dbObject.close();

}