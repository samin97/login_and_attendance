import 'package:flutter/material.dart';

import 'home_screen.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

  attendanceDetails() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Test',
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
          children:  [

            ElevatedButton(
                onPressed: () {
                  attendanceDetails();
                },
                child: const Text("Set Attendance Details")),

          ],
        ),
      ),
    );
  }
}
