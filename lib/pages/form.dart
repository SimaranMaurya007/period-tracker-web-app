import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddPeriodPage extends StatefulWidget {
  final String userId;

  AddPeriodPage({required this.userId});

  @override
  _AddPeriodPageState createState() => _AddPeriodPageState();
}

class _AddPeriodPageState extends State<AddPeriodPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      DateTime startDate =
          DateFormat('yyyy-MM-dd').parse(_startDateController.text);
      DateTime endDate =
          DateFormat('yyyy-MM-dd').parse(_endDateController.text);
      List<String> symptoms =
          _symptomsController.text.split(',').map((s) => s.trim()).toList();

      addPeriod(widget.userId, startDate, endDate, symptoms);

      // Clear the form
      _formKey.currentState!.reset();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Period added successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Period')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _startDateController,
                decoration:
                    InputDecoration(labelText: 'Start Date (yyyy-MM-dd)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter start date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endDateController,
                decoration: InputDecoration(labelText: 'End Date (yyyy-MM-dd)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter end date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _symptomsController,
                decoration:
                    InputDecoration(labelText: 'Symptoms (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter symptoms';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Period'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void addPeriod(String userId, DateTime startDate, DateTime endDate,
    List<String> symptoms) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    await _firestore.collection('users').doc(userId).collection('periods').add({
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'symptoms': symptoms,
    });
    print('Period added successfully');
  } catch (e) {
    print('Error adding period: $e');
  }
}
