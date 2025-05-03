import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_auth_services.dart';
import 'login_page.dart';
import 'toast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
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
            "assets/Pink3.jpg",
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SignUp",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Lato',
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: "User",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
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
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      _signUp();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(233, 30, 99, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: isSigningUp
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // TextButton(
                  //   onPressed: () => _forgotPassword(context),
                  //   child: Text('Forgot Password?'),
                  // ),
                  // ElevatedButton.icon(
                  //   onPressed: () async {q
                  //    User? user = await _signInWithGoogle();
                  //     if (user != null) {
                  //       Navigator.pushReplacementNamed(context, '/home');
                  //     } else {
                  //       showSnackBar(context, "Google Sign-In failed.");
                  //     }
                  //   },
                  //   icon: Icon(Icons.login),
                  //   label: Text("Sign in with Google"),
                  // ),
                  // ElevatedButton.icon(
                  //   onPressed: () async {
                  //     setState(() {
                  //       _isSigningIn = true; // Show loading indicator
                  //     });
                  //     User? user = await _signInWithGoogle();
                  //     setState(() {
                  //       _isSigningIn = false; // Hide loading indicator
                  //     });

                  //     if (user != null) {
                  //       Navigator.pushReplacementNamed(context, '/home');
                  //     } else {
                  //       showSnackBar(context, "Google Sign-In failed.");
                  //     }
                  //   },
                  //   icon: Icon(Icons.login),
                  //   label: Text("Sign in with Google"),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       automaticallyImplyLeading: false,
  //       title: Text("SignUp"),
  //     ),
  //     body: Container(
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           begin: Alignment.topCenter,
  //           end: Alignment.bottomCenter,
  //           colors: [
  //             Colors.pink,
  //             Colors.purple,
  //             Colors.white,
  //           ],
  //         ),
  //       ),
  //       child: Center(
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 15),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 "Sign Up",
  //                 style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(
  //                 height: 30,
  //               ),
  //               FormContainerWidget(
  //                 controller: _usernameController,
  //                 hintText: "Username",
  //                 isPasswordField: false,
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               FormContainerWidget(
  //                 controller: _emailController,
  //                 hintText: "Email",
  //                 isPasswordField: false,
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               FormContainerWidget(
  //                 controller: _passwordController,
  //                 hintText: "Password",
  //                 isPasswordField: true,
  //               ),
  //               SizedBox(
  //                 height: 30,
  //               ),
  //               GestureDetector(
  //                 onTap: () {
  //                   _signUp();
  //                 },
  //                 child: Container(
  //                   width: double.infinity,
  //                   height: 45,
  //                   decoration: BoxDecoration(
  //                     color: const Color.fromARGB(255, 243, 33, 149),
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   child: Center(
  //                     child: isSigningUp
  //                         ? CircularProgressIndicator(
  //                             color: Colors.white,
  //                           )
  //                         : Text(
  //                             "Sign Up",
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text("Already have an account?"),
  //                   SizedBox(
  //                     width: 5,
  //                   ),
  //                   GestureDetector(
  //                     onTap: () {
  //                       Navigator.pushAndRemoveUntil(
  //                         context,
  //                         MaterialPageRoute(builder: (context) => LoginPage()),
  //                         (route) => false,
  //                       );
  //                     },
  //                     child: Text(
  //                       "Login",
  //                       style: TextStyle(
  //                         color: Colors.deepPurple,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void _signUp() async {
  //   setState(() {
  //     isSigningUp = true;
  //   });

  //   String username = _usernameController.text;
  //   String email = _emailController.text;
  //   String password = _passwordController.text;

  //   User? user = await _auth.signUpWithEmailAndPassword(email, password);

  //   setState(() {
  //     isSigningUp = false;
  //   });

  //   if (user != null) {
  //     showToast(message: "User is successfully created");
  //     Navigator.pushNamed(context, "/home");
  //   } else {
  //     showToast(message: "Some error happened");
  //   }
  // }
  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      // Create a new user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        // Check if the user document already exists in Firestore
        DocumentReference userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        DocumentSnapshot docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          // If the document doesn't exist, create a new document in Firestore
          await userDoc.set({
            'email': email,
            'username': username,
            'markedDates': [] // Initialize marked dates array
          });

          showToast(message: "User created and document added to Firestore");
        }

        // Navigate to home after successful sign-up
        Navigator.pushReplacementNamed(context, "/home", arguments: {
          'userId': user.uid,
          'email': email,
        });
      } else {
        showToast(message: "Failed to create user.");
      }
    } catch (e) {
      print('Error signing up: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing up. Please try again.'),
        ),
      );
    } finally {
      setState(() {
        isSigningUp = false;
      });
    }
  }
}
