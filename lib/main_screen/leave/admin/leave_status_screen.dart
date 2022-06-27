import 'dart:convert';
import 'package:first_app/main_screen/leave/admin/leave_status_details.dart';
import 'package:flutter/material.dart';
import '../../../global/global.dart';
import '../../../models/admin_leave_model.dart';
import 'package:http/http.dart' as http;
import '../../home_screen.dart';

class LeaveStatus extends StatefulWidget {
  const LeaveStatus({Key? key}) : super(key: key);

  @override
  State<LeaveStatus> createState() => _LeaveStatusState();
}

class _LeaveStatusState extends State<LeaveStatus> {
  Future<List<AdminGetLeaveModel>> adminGetLeave() async {
    final token = sharedPreferences!.getString("token")!;
    final response = await http.get(
      Uri.parse('http://api.ssgroupm.com/Api/Leave/GetLeaveForAdmin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> parsed =
          json.decode(response.body).cast<Map<String, dynamic>>();
      List<AdminGetLeaveModel> list = [];
      list = parsed.map((json) => AdminGetLeaveModel.fromJson(json)).toList();
      return list;
    } else {
      throw Exception('Failed to load leave log');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Leave',
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
      body: FutureBuilder<List<AdminGetLeaveModel>>(
        future: adminGetLeave(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            List<AdminGetLeaveModel> leaveList = snapshot.data;
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: InkWell(
                        child: Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Leave ID:" +
                                      leaveList[index].id.toString()),
                                  Text("Requested by: " +
                                      leaveList[index].userName.toString()),
                                  Text("Reason: " +
                                      leaveList[index].leaveFor.toString())
                                ],
                              ),
                            ),
                            Flexible(
                                flex: 3,
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text("Date: " +
                                        leaveList[index].leaveDate.toString())))
                          ],
                        ),
                        onTap: () {
                          Route newRoute = MaterialPageRoute(
                              builder: (_) => LeaveStatusDetails(
                                    adminGetLeaveModel: leaveList[index],
                                  ));
                          Navigator.pushReplacement(context, newRoute);
                        },
                      ),
                    ),
                  );
                });
          } else {
            return const Center(
              child: Text("There are no leave request"),
            );
          }
        },
      ),
    );
  }
}
