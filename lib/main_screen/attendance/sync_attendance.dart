import 'dart:convert';
import 'package:first_app/local_db/repository/log_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../global/error_dialog.dart';
import '../../global/global.dart';
import '../../models/attendance_model.dart';
import '../../models/local_storage_model.dart';
import '../home_screen.dart';

class SyncAttendance extends StatefulWidget {
  const SyncAttendance({Key? key}) : super(key: key);

  @override
  State<SyncAttendance> createState() => _SyncAttendanceState();
}

class _SyncAttendanceState extends State<SyncAttendance> {
  AttendanceModel fetchedAttendance = AttendanceModel(
      nepaliDate: 'nepaliDate',
      englishDate: 'englishDate',
      attendDateTime: 'attendDateTime',
      latitude: 'latitude',
      longitude: 'longitude',
      deviceId: 'deviceId',
      networkId: 'networkId',
      altitude: 'altitude');

  AttendanceModel newAttendance = AttendanceModel(
      nepaliDate: 'nepaliDate',
      englishDate: 'englishDate',
      attendDateTime: 'attendDateTime',
      latitude: 'latitude',
      longitude: 'longitude',
      deviceId: 'deviceId',
      networkId: 'networkId',
      altitude: 'altitude');

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
                  fetchAttendance();
                  if (_log.attendDateTime == fetchedAttendance.attendDateTime) {
                    LogRepository.deleteLogs(_log.attendDateTime);
                  } else {
                    setState(() {
                      newAttendance.nepaliDate = _log.nepaliDate;
                      newAttendance.englishDate = _log.englishDate;
                      newAttendance.attendDateTime = _log.attendDateTime!;
                      newAttendance.latitude = _log.latitude;
                      newAttendance.longitude = _log.longitude;
                      newAttendance.deviceId = _log.deviceId!;
                      newAttendance.networkId = _log.networkId;
                      newAttendance.altitude = _log.altitude;
                    });
                    postAttendance();
                  }
                  return const Text("Attendance sync failed");
                },
              );
            }
          }
          Route newRoute =
              MaterialPageRoute(builder: (_) => const HomeScreen());
          Navigator.pushReplacement(context, newRoute);
          return const Text("No attendance log");
        });
  }

  Future postAttendance() async {
    final token = sharedPreferences!.getString("token")!;
    var response = await http.post(
        Uri.parse("http://api.ssgroupm.com/Api/Attendence/AttendUser"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(newAttendance));
    print(response.statusCode);

    if (response.statusCode == 200) {
      // var s = response.body.toString();
      print("sync successful");
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(
              message: "Failed to attend",
            );
          });
    }
  }

  Future<AttendanceModel> fetchAttendance() async {
    final token = sharedPreferences!.getString("token")!;
    final response = await http.get(
      Uri.parse('http://api.ssgroupm.com/Api/Attendence/GetAttendence'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response);
    if (response.statusCode == 200) {
      fetchedAttendance = AttendanceModel.fromJson(jsonDecode(response.body));
      return fetchedAttendance;
    } else {
      throw Exception('Failed to load attendance log');
    }
  }
}
