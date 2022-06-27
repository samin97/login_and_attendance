


import 'package:first_app/main_screen/report/report_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../../global/widgets/button_widget.dart';

class ReportYear extends StatefulWidget {
  const ReportYear({Key? key}) : super(key: key);

  @override
  _ReportYearState createState() => _ReportYearState();
}

class _ReportYearState extends State<ReportYear> {

  DateTime? selectedDate;
  late String value;

  String getText() {
    if (selectedDate == null) {
      return 'Select';
    } else {
      return DateFormat('yyyy').format(selectedDate!);
    }
  }

  Future<void> pickDate({
    required BuildContext context,
    String? locale,
  }) async {
    final localeObj = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(DateTime
          .now()
          .year - 10),
      lastDate: DateTime(DateTime
          .now()
          .year + 5),
      locale: localeObj,
      initialMonthYearPickerMode: MonthYearPickerMode.year,
    );
    if (selected != null) {
      setState(() {
        selectedDate = selected;
        print(selectedDate);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Flexible(
                  child: Text(
                    'Year:',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Flexible(
                  child: ButtonHeaderWidget(
                    title: 'Date',
                    text: getText(),
                    onClicked: () => pickDate(context: context),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),

            ElevatedButton(
                onPressed: () {
                  Route newRoute =
                  MaterialPageRoute(builder: (_) =>
                      ReportDetails(value: value, ));
                  Navigator.pushReplacement(context, newRoute);
                },
                child: const Text("Submit"))
          ],
        ),
      ),
    );
  }
}