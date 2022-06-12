import 'package:first_app/main_screen/attendance/attendance_screen.dart';
import 'package:first_app/main_screen/leave/leave_screen.dart';
import 'package:first_app/main_screen/test_debug.dart';
import 'package:flutter/material.dart';
import '../authenticate/login.dart';
import '../global/global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future logoutNow() async {
    await sharedPreferences?.setString("email", "");
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
              const Text(
                'Full Name: Rajesh Maharjan',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Email : rajesh@gmail.com',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Phone : 9881233182',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Status : approved',
                style: TextStyle(
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
                        onTap: () => {},
                        child: Container(
                          color: Colors.cyan,
                          alignment: Alignment.bottomCenter,
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'QR attend',
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
                          Route newRoute = MaterialPageRoute(
                              builder: (_) => const Test());
                          Navigator.pushReplacement(context, newRoute);
                        },
                        child: Container(
                          color: Colors.cyan,
                          alignment: Alignment.bottomCenter,
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Test',
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
