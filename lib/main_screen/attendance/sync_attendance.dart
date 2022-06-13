import 'dart:convert';
import 'package:first_app/local_db/repository/log_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/attendance_model.dart';
import '';
import '../../models/local_storage_model.dart';

class SyncAttendance extends StatelessWidget {
  const SyncAttendance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: LogRepository.getLogs(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            List<dynamic> logList = snapshot.data;
            if (logList.isNotEmpty) {
              return ListView.builder(
                itemCount: logList.length,
                itemBuilder: (context, index) {
                  Log _log = logList[index];
                  if (_log.attendDateTime ==) {
                    LogRepository.deleteLogs(_log.attendDateTime);
                  }
                  else {
                    syncNow();
                  }

                  return const Text("No attendance log");
                },
              );
            }
          }
          return const Text("No attendance log");
        });
  }

  Future syncNow() async {
    fetchAttendance();
  }

}

Future<AttendanceModel> fetchAttendance() async {
  final response = await http
      .get(Uri.parse('http://api.ssgroupm.com/Api/Attendence/GetAttendence'));

  if (response.statusCode == 200) {

    AttendanceModel fetchedAttendance = AttendanceModel.fromJson(jsonDecode(response.body));
    return fetchedAttendance;
  } else {

    throw Exception('Failed to load attendance log');
  }
}
