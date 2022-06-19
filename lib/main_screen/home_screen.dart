import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:first_app/main_screen/attendance/attendance_screen.dart';
import 'package:first_app/main_screen/leave/leave_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../authenticate/login.dart';
import '../global/error_dialog.dart';
import '../global/global.dart';
import '../local_db/repository/log_repository.dart';
import '../models/attendance_model.dart';
import '../models/local_storage_model.dart';
import 'attendance/sync_attendance.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? position;
  late AttendanceModel attendanceModel = AttendanceModel(
      nepaliDate: "nepaliDate",
      englishDate: "englishDate",
      attendDateTime: "attendDateTime",
      latitude: "latitude",
      longitude: "longitude",
      deviceId: "deviceId",
      networkId: "networkId",
      altitude: "attitude");

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
        altitude: attendanceModel.altitude);
    LogRepository.addLogs(log);
  }

  Future postAttendance() async {
    final token = sharedPreferences!.getString("token")!;
    var response = await http.post(
        Uri.parse("http://api.ssgroupm.com/Api/Attendence/AttendUser"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(attendanceModel));
    print(response.statusCode);

    if (response.statusCode == 200) {
      const snackBar = SnackBar(
          content:
          Text("Attendance posted"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  bool? _hasBioSensor;
  LocalAuthentication bioAuthentication = LocalAuthentication();

  Future<void> _checkBio() async {
    try {
      _hasBioSensor = await bioAuthentication.canCheckBiometrics;
      print(_hasBioSensor);
      if (_hasBioSensor!) {
        _getAuth();
      } else {
        const snackBar = SnackBar(
            content:
                Text("Device does not support fingerprint authentication"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAuth() async {
    bool isAuth = false;
    try {
      isAuth = await bioAuthentication.authenticate(
          localizedReason: 'Scan your finger for attendance');
      const AuthenticationOptions(
          biometricOnly: true, useErrorDialogs: true, stickyAuth: true);
      if (isAuth) {
        attendanceDetails();
        checkConnection();
      } else {
        const snackBar =
            SnackBar(content: Text("Fingerprint authentication failed"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future logoutNow() async {
    await sharedPreferences?.remove("email");
    Route newRoute = MaterialPageRoute(builder: (_) => const Login());
    Navigator.pushReplacement(context, newRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Homepage',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                  radius: MediaQuery.of(context).size.width * .20,
                  backgroundColor: Colors.white,
                  child: Image.network(
                    "https://www.jeancoutu.com/globalassets/revamp/photo/conseils-photo/20160302-01-reseaux-sociaux-profil/photo-profil_301783868.jpg",
                    fit: BoxFit.fitHeight,
                  )),
              Text(
                'First Name : ' + sharedPreferences!.getString("firstName")!,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Email : ' + sharedPreferences!.getString("username")!,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Role : ' + sharedPreferences!.getString("role")!,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Permission : ' + sharedPreferences!.getString("permission")!,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 4,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          Route newRoute = MaterialPageRoute(
                              builder: (_) => const Attendance());
                          Navigator.pushReplacement(context, newRoute);
                        },
                        child: Container(
                          color: Colors.cyan,
                          alignment: Alignment.bottomCenter,
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Attendance',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Flexible(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          _checkBio();
                        },
                        child: Container(
                          color: Colors.cyan,
                          alignment: Alignment.bottomCenter,
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Fingerprint attend',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          Route newRoute = MaterialPageRoute(
                              builder: (_) => const LeaveForm());
                          Navigator.pushReplacement(context, newRoute);
                        },
                        child: Container(
                          color: Colors.cyan,
                          alignment: Alignment.bottomCenter,
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Request Leave',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Flexible(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          const SyncAttendance();
                        },
                        child: Container(
                          color: Colors.cyan,
                          alignment: Alignment.bottomCenter,
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Sync',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: InkWell(
                        onTap: () => {},
                        child: Container(
                          color: Colors.cyan,
                          alignment: Alignment.bottomCenter,
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Event',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Flexible(
                      flex: 3,
                      child: InkWell(
                        onTap: () => {},
                        child: Container(
                          color: Colors.cyan,
                          alignment: Alignment.bottomCenter,
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Help',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Flexible(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          logoutNow();
                        },
                        child: Container(
                          color: Colors.cyan,
                          alignment: Alignment.bottomCenter,
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Log out',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
