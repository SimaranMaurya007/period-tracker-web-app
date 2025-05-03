import 'dart:async';

import 'package:flutter/material.dart';
// import 'home_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;

  SplashScreen({Key? key, this.child}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);
    _controller.forward();

    // Navigate to Home Page after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget.child!),
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // Background Image
              Image.asset(
                'assets/background_image.png',
                fit: BoxFit.cover,
              ),
              // Logo Image centered on top of the background
              Center(
                child: ClipOval(
                  child: Image.asset(
                    'assets/Aura.png',
                    width: 200,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
