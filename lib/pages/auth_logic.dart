import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSigningIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/login2.jpg",
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Lato',
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () => _signIn(context),
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _isSigningIn
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _signIn(BuildContext context) async {
    setState(() {
      _isSigningIn = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('Error signing in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in. Please check your credentials.'),
        ),
      );
    }

    setState(() {
      _isSigningIn = false;
    });
  }
}
