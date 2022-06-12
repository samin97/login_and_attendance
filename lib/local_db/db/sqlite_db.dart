import 'dart:io';

import 'package:first_app/local_db/interface/log_interface.dart';
import 'package:first_app/models/local_storage_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqliteMethods implements LogInterface {
  Database? _db;
  String databaseName = "LogBD";
  String tableName = "Attendance_logs";

  //columns
  String id = "attendDateTime";
  String nepaliDate = "nepaliDate";
  String englishDate = "englishDate";
  String latitude = "latitude";
  String longitude = "longitude";
  String deviceId = "deviceId";
  String networkId = "networkId";
  String altitude = "altitude";

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    print("db was null, now awaiting it");
    _db = await init();
    return _db;
  }

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, databaseName);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    String createTableQuery =
        "CREATE TABLE $tableName ($id INTEGER PRIMARY KEY, $nepaliDate TEXT, $englishDate TEXT, $latitude TEXT, $longitude TEXT, $deviceId TEXT, $networkId TEXT, $altitude TEXT)";

    await db.execute(createTableQuery);
    print("table created");
  }

  @override
  addLogs(Log log) async {
    var dbClient = await db;
    await dbClient?.insert(tableName, log.toMap(log));
    print("log has been added");
  }

  @override
  deleteLogs(int attendDateTime) async {
    var dbClient = await db;
    return await dbClient!
        .delete(tableName, where: '$id=?', whereArgs: [attendDateTime]);
  }

  updateLogs(Log log) async {
    var dbClient = await db;
    await dbClient!.update(tableName, log.toMap(log),
        where: '$id = ?', whereArgs: [log.attendDateTime]);
  }

  @override
  Future<List<Log>?> getLogs() async {
    try {
      var dbClient = await db;
      //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $tableName");
      List<Map> maps = await dbClient!.query(tableName, columns: [
        id,
        altitude,
        networkId,
        englishDate,
        deviceId,
        latitude,
        longitude,
        nepaliDate
      ]);


      List<Log> logList = [];
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          logList.add(Log.fromMap(map));
        }
      }
      return logList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  close() async {
    var dbClient = await db;
    dbClient!.close();
  }
}
