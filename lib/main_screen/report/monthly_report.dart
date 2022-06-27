import 'package:first_app/main_screen/report/monthly_report_details.dart';
import 'package:flutter/material.dart';

class ReportMonth extends StatefulWidget {
  const ReportMonth({Key? key}) : super(key: key);

  @override
  _ReportMonthState createState() => _ReportMonthState();
}

class _ReportMonthState extends State<ReportMonth> {


  var dropdownValue;

  @override
  void initState() {
    dropdownValue = monthList[0];
    super.initState();
  }

  String? value;
  final monthList = [
    'Baishakh',
    'Jestha',
    'Ashadh',
    'Shrawan',
    'Bhadau',
    'Ashwin',
    'Kartik',
    'Mangsir',
    'Poush',
    'Magh',
    'Falgun',
    'Chaitra',
  ];

  DropdownMenuItem<String> buildMenuItems(String monthList) => DropdownMenuItem(
        value: monthList,
        child: Text(monthList),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Flexible(
                  child: Text(
                    'Month: ',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: value,
                        hint: const Text("Pick"),
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        items: monthList.map(buildMenuItems).toList(),
                        onChanged: (value) => setState(
                          () {
                            this.value = value as String?;

                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: (){
                if(value == null){
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text("Month not selected"),
                      content: const Text(
                          "Please pick a month."),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"))
                      ],
                    ),
                  );
                }else
                {
                  Route newRoute = MaterialPageRoute(
                      builder: (_) => MonthlyReportDetails(
                            value: value as String,
                          ));
                  Navigator.pushReplacement(context, newRoute);
                }},
                child: const Text("Submit"))
          ],
        ),
      ),
    );
  }
}
