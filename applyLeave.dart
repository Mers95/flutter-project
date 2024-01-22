import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({super.key});

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  final empName = TextEditingController();
  final leaveReason = TextEditingController();
  final startDate = TextEditingController(); // Change here
  final endDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    startDate.text = "";
    endDate.text = "";
  }

  bool _valName = false;
  bool _valReason = false;
  bool _valStartDate = false;
  bool _valEndDate = false;

  /* Using PHP */
  // Future _saveDetails(String name, String startdate, String enddate, String reason) async {
  //   var url = Uri.parse("http://192.168.1.101/API-Flutter/flutter_insert.php");
  //   final response = await http.post(url as Uri, body: {
  //     "name": name, "startdate": startdate, "enddate": enddate, "reason": reason
  //
  //   }
  //
  //   );
  //   print(enddate);
  //   var res = response.body;
  //   if (res == "True") {
  //     Navigator.pop(context);
  //   }
  //   else {
  //     print("Error " + res);
  //   }
  // }

  /* Using Python */
  Future<void> _saveDetails(
      String name, String startdate, String enddate, String reason) async {
    final url =
        'https://d1grhnhou4.execute-api.us-west-2.amazonaws.com/insert-data-flutter';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'name': name,
          'startdate': DateFormat('yyyy-MM-dd')
              .format(DateFormat('yyyy-MM-dd').parse(startdate)),
          'enddate': DateFormat('yyyy-MM-dd')
              .format(DateFormat('yyyy-MM-dd').parse(enddate)),
          'reason': reason,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print(
          'Formatted Start Date: ${DateFormat('yyyy-MM-dd').format(DateFormat('yyyy-MM-dd').parse(startdate))}');
      print(
          'Formatted End Date: ${DateFormat('yyyy-MM-dd').format(DateFormat('yyyy-MM-dd').parse(enddate))}');

      if (response.statusCode == 200) {
        print('Form submitted successfully');

      } else {
        print(
            'Failed to submit form. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  Navigator.pop(context);

  @override // Form Close agum pothu it will clear the occupied memory
  void dispose() {
    empName.dispose();
    startDate.dispose();
    endDate.dispose();
    leaveReason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medisim VR'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text("Apply Leave",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                      fontFamily: 'Times New Roman')),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: empName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the Name',
                  labelText: 'Name of the employee',
                  errorText: _valName ? 'Name Can\'t be empty' : null,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: startDate,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Select the Leave Start Date",
                  labelText: "Start Date",
                  prefixIcon: Icon(Icons.calendar_today),
                  errorText:
                      _valStartDate ? 'Kindly Select the Start Date' : null,
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  if (pickedDate != null) {
                    setState(() {
                      startDate.text =
                          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                    });
                  } else {
                    print("Date Not Selected");
                  }
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: endDate,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Select the Leave End Date",
                  labelText: "End Date",
                  prefixIcon: Icon(Icons.calendar_today),
                  errorText: _valEndDate ? 'Kindly Select the End Date' : null,
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedEndDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  if (pickedEndDate != null) {
                    setState(() {
                      endDate.text =
                          "${pickedEndDate.year}-${pickedEndDate.month}-${pickedEndDate.day}";
                    });
                  } else {
                    print("Date Not Selected");
                  }
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: leaveReason,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Reason for Leave',
                  labelText: 'Leave Reason',
                  errorText: _valReason ? 'Reason Should be add' : null,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {
                        setState(() {
                          empName.text.isEmpty
                              ? _valName = true
                              : _valName = false;
                          startDate.text.isEmpty
                              ? _valStartDate = true
                              : _valStartDate = false;
                          endDate.text.isEmpty
                              ? _valEndDate = true
                              : _valEndDate = false;
                          leaveReason.text.isEmpty
                              ? _valReason = true
                              : _valReason = false;
                          if (_valName == false &&
                              _valStartDate == false &&
                              _valReason == false) {
                            _saveDetails(empName.text, startDate.text,
                                endDate.text, leaveReason.text);
                          }
                        });
                      },
                      child: const Text('Apply Leave')),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {
                        empName.text = '';
                        startDate.text = '';
                        leaveReason.text = '';
                        endDate.text = '';
                      },
                      child: const Text('Clear'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
