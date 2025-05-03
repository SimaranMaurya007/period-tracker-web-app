import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  final String email;

  ProfilePage({required this.userId, required this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class BMIPage extends StatefulWidget {
  @override
  _BMIPageState createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  double? _bmiResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Height (cm)'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _calculateBMI();
              },
              child: Text('Calculate BMI'),
            ),
            SizedBox(height: 20),
            _bmiResult != null
                ? Text(
                    'BMI: ${_bmiResult?.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void _calculateBMI() {
    double height = double.tryParse(_heightController.text) ?? 0;
    double weight = double.tryParse(_weightController.text) ?? 0;

    if (height > 0 && weight > 0) {
      double heightInMeters = height / 100;
      double bmi = weight / (heightInMeters * heightInMeters);
      setState(() {
        _bmiResult = bmi;
      });
    }
  }
}

Widget _buildOptionTile(String title, VoidCallback onTap) {
  return ListTile(
    title: Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    onTap: onTap,
    trailing: Icon(Icons.arrow_forward_ios),
  );
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String shortenedEmail = widget.email.substring(0, widget.email.length - 10);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          // ColorFiltered(
          //   colorFilter: ColorFilter.mode(
          //     Colors.black.withOpacity(0.5), // Change the opacity value here
          //     BlendMode.darken,
          //   ),
          //   child: Image.asset(
          //     'assets/profile_background.jpg',
          //     fit: BoxFit.cover, // Cover the entire screen
          //   ),
          // ),
          // Foreground content
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(225, 115, 168,
                      1), // Set background color to purple with transparency
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _getImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : AssetImage('assets/about_logo.jpg')
                                as ImageProvider,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      shortenedEmail,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildOptionTile('BMI Calculator', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BMIPage()),
                      );
                    }),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 200, 118, 209), // Background color
                          // shadowColor: Colors.white, // Text color
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5, // Shadow elevation
                        ),
                        child: Text(
                          'Logout',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out the user
      // Navigate to the login screen after logout
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => LoginPage()), // Replace with your login page
      );
    } catch (e) {
      print('Error signing out: $e');
      // Optionally, show a message to the user indicating that logout failed
    }
  }

  Widget _buildOptionTile(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}
