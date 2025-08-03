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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('BMI Calculator'),
        backgroundColor: Colors.pink[100],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink[50]!,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                                 decoration: BoxDecoration(
                   color: Colors.pink[200],
                   borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.monitor_weight,
                      size: 50,
                      color: Colors.pink[700],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Body Mass Index Calculator',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Calculate your BMI to understand your health status',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.pink[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              
              // Input Fields Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Height Input
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.pink[200]!),
                      ),
                      child: TextField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Height (cm)',
                          labelStyle: TextStyle(color: Colors.pink[600]),
                          border: InputBorder.none,
                          icon: Icon(Icons.height, color: Colors.pink[400]),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // Weight Input
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.pink[200]!),
                      ),
                      child: TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Weight (kg)',
                          labelStyle: TextStyle(color: Colors.pink[600]),
                          border: InputBorder.none,
                          icon: Icon(Icons.fitness_center, color: Colors.pink[400]),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    
                    // Calculate Button
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calculateBMI,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[400],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calculate, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Calculate BMI',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              
              // Result Card
              if (_bmiResult != null) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: _getBMIColor(_bmiResult!),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _getBMIColor(_bmiResult!).withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getBMIIcon(_bmiResult!),
                        size: 60,
                        color: Colors.white,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Your BMI',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${_bmiResult!.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          _getBMICategory(_bmiResult!),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _getBMIAdvice(_bmiResult!),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
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

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue[400]!; // Underweight
    if (bmi < 25) return Colors.green[400]!; // Normal
    if (bmi < 30) return Colors.orange[400]!; // Overweight
    return Colors.red[400]!; // Obese
  }

  IconData _getBMIIcon(double bmi) {
    if (bmi < 18.5) return Icons.trending_down; // Underweight
    if (bmi < 25) return Icons.check_circle; // Normal
    if (bmi < 30) return Icons.warning; // Overweight
    return Icons.error; // Obese
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal Weight';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  String _getBMIAdvice(double bmi) {
    if (bmi < 18.5) {
      return 'You are underweight. Consider increasing your caloric intake with healthy foods and consult a healthcare provider.';
    } else if (bmi < 25) {
      return 'Great! You are in the healthy weight range. Maintain a balanced diet and regular exercise routine.';
    } else if (bmi < 30) {
      return 'You are overweight. Focus on a balanced diet and regular physical activity to improve your health.';
    } else {
      return 'You are in the obese category. Please consult a healthcare provider for personalized advice and support.';
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Profile'),
        backgroundColor: Colors.pink[100],
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Modern Profile Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.pink[100]!,
                      Colors.pink[200]!,
                      Colors.pink[300]!,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Profile Image with Border
                    GestureDetector(
                      onTap: _getImage,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : AssetImage('assets/about_logo.jpg')
                                  as ImageProvider,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // User Name/Email
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        shortenedEmail,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.pink[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: ListView(
                    children: [
                      // BMI Calculator Card
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          leading: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.pink[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.calculate,
                              color: Colors.pink[700],
                              size: 24,
                            ),
                          ),
                          title: Text(
                            'BMI Calculator',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          subtitle: Text(
                            'Calculate your Body Mass Index',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.pink[300],
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BMIPage()),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      // Logout Button
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _logout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink[400],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 3,
                            shadowColor: Colors.pink.withOpacity(0.3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, size: 20),
                              SizedBox(width: 10),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
