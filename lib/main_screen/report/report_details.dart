import 'package:first_app/main_screen/report/report_category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/attendance_model.dart';
import '../attendance/fetch_attendance.dart';
import '../home_screen.dart';

class ReportDetails extends StatefulWidget {
  final String? value;

  const ReportDetails({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  State<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {

  //2022-06-25
  int presentDays = 0;
  DateTime newDate = DateTime.now();
  late DateTime fetchedMonthDT;
  late String selectedMonth;
  late String fetchedMonth;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text(
          'Report Details',
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
                MaterialPageRoute(builder: (_) => const ReportCategory());
            Navigator.pushReplacement(context, newRoute);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            children: [
              FutureBuilder(
                future: fetchAttendance(),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    List<dynamic> attendanceList = snapshot.data;
                    if (attendanceList.isNotEmpty) {
                      return  Expanded(
                        child: SizedBox(
                          height: 200.0,
                          child: ListView.builder(
                            itemCount: attendanceList.length,
                            itemBuilder: (context, index) {
                              AttendanceModel _fetchedAttendance =
                                  attendanceList[index];


                              return Text("Total no of days present:" + presentDays.toString());
                            },
                          ),
                        ),
                      );
                    }
                  }
                  return Text("Total no zz of days present:" + presentDays.toString());
                },
              ),
              const SizedBox(height: 12),
              Text("For the month of" + DateFormat.MMMM().format(newDate) + "total number of days present" ),
              const SizedBox(height: 12),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                  onPressed: () {
                    Route newRoute =
                        MaterialPageRoute(builder: (_) => const HomeScreen());
                    Navigator.pushReplacement(context, newRoute);
                  },
                  child: const Text("Finish"))
            ],
          ),
        ),
      ),
    );
  }
}
