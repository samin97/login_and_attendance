import 'package:first_app/main_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../global/button_widget.dart';

class LeaveForm extends StatefulWidget {
  const LeaveForm({Key? key}) : super(key: key);

  @override
  State<LeaveForm> createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> {
  final leaveFor = [
    'Sick leave',
    'Maternal Leave',
    'Unpaid leave',
    'Religious observance',
    'Vacation leave',
    'Others'
  ];
  DateTime? date;

  String? value;

  TextEditingController reasonController = TextEditingController();

  String getText() {
    if (date == null) {
      return 'Select Date';
    } else {
      return DateFormat('MM/dd/yyyy').format(date!);
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;
    setState(() => date = newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text(
          'Leave Form',
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
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Flexible(
                    child: Text(
                      'Leave Date:',
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
                      onClicked: () => pickDate(context),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Flexible(
                    child: Text(
                      'Leave For',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: value,
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          items: leaveFor.map(buildMenuItems).toList(),
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
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Leave Description'),
                controller: reasonController,
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                  onPressed: () {
                    Route newRoute =
                        MaterialPageRoute(builder: (_) => const HomeScreen());
                    Navigator.pushReplacement(context, newRoute);
                  },
                  child: const Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItems(String leaveFor) => DropdownMenuItem(
        value: leaveFor,
        child: Text(leaveFor),
      );
}
