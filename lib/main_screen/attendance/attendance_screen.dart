import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:first_app/local_db/repository/log_repository.dart';
import 'package:first_app/main_screen/home_screen.dart';
import 'package:first_app/models/attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:http/http.dart' as http;

import '../../global/error_dialog.dart';
import '../../models/local_storage_model.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  Position? position;
  List<Placemark>? placeMarks;
  late AttendanceModel attendanceModel = AttendanceModel(
      nepaliDate: "nepaliDate",
      englishDate: "englishDate",
      attendDateTime: "attendDateTime",
      latitude: "latitude",
      longitude: "longitude",
      deviceId: "deviceId",
      networkId: "networkId",
      altitude: "attitude");

  get builder => null;

  @override
  void initState() {
    super.initState();
    attendanceDetails();
  }

  Future<void> attendanceDetails() async {
    //nepaliDate:
    NepaliDateTime currentNepaliTime = NepaliDateTime.now();
    var nepaliDate = NepaliDateFormat("yyyy.MMMM.dd");
    final String nepaliFormatted = nepaliDate.format(currentNepaliTime);
    print(nepaliDate.format(currentNepaliTime));
    //englishDate:
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String englishFormatted = formatter.format(now);
    print(formatter.format(now));
    //attendDateTime:
    String isoAttendDateTime = now.toIso8601String();
    //latitude, longitude and attitude:
    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = newPosition;
    print(position?.latitude);
    //deviceId:
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    //networkId:
    final info = NetworkInfo();
    var wifiGateway = await info.getWifiGatewayIP();

    //todo set state

    setState(() {
      attendanceModel.nepaliDate = nepaliFormatted.trim();
      attendanceModel.englishDate = englishFormatted.trim();
      attendanceModel.attendDateTime = isoAttendDateTime.trim();
      attendanceModel.latitude = position?.latitude.toString();
      attendanceModel.longitude = position?.longitude.toString();
      attendanceModel.deviceId = deviceInfo.toString();
      attendanceModel.networkId = wifiGateway;
      attendanceModel.altitude = position?.altitude.toString();
    });
    print(attendanceModel.networkId);
    print(attendanceModel.deviceId);
  }

  Future checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      postAttendance();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      postAttendance();
    } else {
      localStorage();
    }
  }

  Future localStorage() async {
    Log log = Log(
        attendDateTime: attendanceModel.deviceId,
        nepaliDate: attendanceModel.nepaliDate,
        longitude: attendanceModel.longitude,
        latitude: attendanceModel.latitude,
        deviceId: attendanceModel.deviceId,
        englishDate: attendanceModel.englishDate,
        networkId: attendanceModel.networkId,
        attitude: attendanceModel.altitude);
    LogRepository.addLogs(log);
  }

  Future postAttendance() async {
    var response = await http.post(
        Uri.parse("http://api.ssgroupm.com/Api/Attendence/AttendUser"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(attendanceModel));
    print(response.statusCode);

    if (response.statusCode == 200) {
     // var s = response.body.toString();
      Route newRoute = MaterialPageRoute(builder: (_) => const HomeScreen());
      Navigator.pushReplacement(context, newRoute);
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

  getCurrentLocation() async {
    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Forum',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Route newRoute =
                MaterialPageRoute(builder: (_) => const HomeScreen());
            Navigator.pushReplacement(context, newRoute);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(flex: 1, child: Text("Nepali Date")),
                Expanded(flex: 1, child: Text(attendanceModel.nepaliDate!)),
              ],
            ),
            Row(
              children: [
                const Expanded(flex: 1, child: Text("English Date")),
                Expanded(flex: 1, child: Text(attendanceModel.englishDate!)),
              ],
            ),
            Row(
              children: [
                const Expanded(flex: 1, child: Text("Attend Date Time")),
                Expanded(flex: 1, child: Text(attendanceModel.attendDateTime)),
              ],
            ),
            Row(
              children: [
                const Expanded(flex: 1, child: Text("Latitude")),
                Expanded(flex: 1, child: Text(attendanceModel.latitude!)),
              ],
            ),
            Row(
              children: [
                const Expanded(flex: 1, child: Text("Longitude")),
                Expanded(flex: 1, child: Text(attendanceModel.longitude!)),
              ],
            ),
            Row(
              children: [
                const Expanded(flex: 1, child: Text("Device Id")),
                Expanded(flex: 1, child: Text(attendanceModel.deviceId)),
              ],
            ),
            Row(
              children: [
                const Expanded(flex: 1, child: Text("Network Id")),
                Expanded(flex: 1, child: Text(attendanceModel.networkId!)),
              ],
            ),
            Row(
              children: [
                const Expanded(flex: 1, child: Text("Attitude")),
                Expanded(flex: 1, child: Text(attendanceModel.altitude!)),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  attendanceDetails();
                },
                child: const Text("Set Attendance Details")),
            ElevatedButton(
                onPressed: () {
                  checkConnection();
                },
                child: const Text("Post Attendance")),
          ],
        ),
      ),
    );
  }
}
