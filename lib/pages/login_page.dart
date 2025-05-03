import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:period_tracker_app/pages/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isSigningIn = false;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  // bool isSigningIn = false; // Declare this at the top of your State class.

  List<DateTime> markedDates = [];
  // DateTime? _selectedDay;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
    // _fetchDataFromFirestore();
  }

  void _login(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  // void _forgotPassword() async {
  //   String email = _emailController.text;

  //   if (email.isEmpty) {
  //     showToast(message: "Please enter your email.");
  //     return;
  //   }

  //   try {
  //     await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  //     showToast(message: "Password reset link has been sent to your email.");
  //   } catch (e) {
  //     print("Error: $e");
  //     showToast(message: "Error sending password reset email.");
  //   }
  // }
  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Future<User?> _signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) return null;

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final OAuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //     return userCredential.user;
  //   } catch (e) {
  //     print("Google Sign-In Error: $e");
  //     return null;
  //   }
  // }
  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // This token can be sent to your backend or used directly with Firebase
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void _forgotPassword(BuildContext context) async {
    String email = _emailController.text;

    if (email.isEmpty) {
      showSnackBar(context, "Please enter your email.");
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showSnackBar(context, "Password reset link has been sent to your email.");
    } catch (e) {
      print("Error: $e");
      showSnackBar(context, "Error sending password reset email.");
    }
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
                        color: const Color.fromRGBO(233, 30, 99, 1),
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
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () => _login(context),
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 40, 30, 233),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _forgotPassword(context),
                    child: Text('Forgot Password?'),
                  ),
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

  // void _fetchDataFromFirestore(String email) async {
  //   try {
  //     // Get reference to the user's document
  //     DocumentSnapshot userDoc =
  //         await FirebaseFirestore.instance.collection('users').doc(email).get();

  //     // Check if the document exists and data is not null
  //     if (userDoc.exists && userDoc.data() != null) {
  //       var data = userDoc.data() as Map<String, dynamic>; // Cast data to Map

  //       // Check if the 'markedDates' field exists
  //       if (data.containsKey('markedDates')) {
  //         List<Timestamp> markedTimestamps = List.from(data['markedDates']);

  //         // Convert Timestamps to DateTime objects
  //         markedDates = markedTimestamps
  //             .map((ts) => DateTime(ts.toDate().year, ts.toDate().month,
  //                 ts.toDate().day)) // Set time to 00:00:00
  //             .toList();
  //         // setState(() {});
  //         // Do something with the markedDates list
  //         print(markedDates);
  //       }
  //     } else {
  //       print('No data found for the user.');
  //     }
  //   } catch (e) {
  //     print('Error fetching marked dates: $e');
  //   }
  // }

  // Example from your sign-in method
  // void _signIn(BuildContext context) async {
  //   try {
  //     // Get user input (email and password)
  //     String email = _emailController.text;
  //     String password = _passwordController.text;

  //     // Sign in with email and password
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     // Get userId from the signed-in user
  //     String userId = userCredential.user!.uid;

  //     // Navigate to the home page with the userId
  //     // _fetchDataFromFirestore();
  //     print('Signing in successful for: $email');

  //     // Fetch marked dates after sign-in
  //     // _fetchDataFromFirestore(email);
  //     Navigator.pushReplacementNamed(context, '/home', arguments: {
  //       'userId': userId,
  //       'email': email,
  //     });
  //     // Navigator.pushReplacementNamed(context, '/home', arguments: email);
  //     // Navigator.pushReplacementNamed(context, '/home', arguments: userId);
  //   } catch (e) {
  //     // Handle sign-in errors
  //     print('Error signing in: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error signing in. Please check your credentials.'),
  //       ),
  //     );
  //   }
  // }
  void _signIn(BuildContext context) async {
    setState(() {
      _isSigningIn = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      // Sign in with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        // Check if the user document exists in Firestore
        DocumentReference userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        DocumentSnapshot docSnapshot = await userDoc.get();

        if (docSnapshot.exists) {
          // Document exists, proceed to home page
          print('User document found. Signing in: $email');

          // Navigate to the home page with userId and email
          Navigator.pushReplacementNamed(context, '/home', arguments: {
            'userId': user.uid,
            'email': email,
          });
        } else {
          // If no Firestore document is found, prompt the user
          print('No Firestore document found for user: $email');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: No account found. Please sign up.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign-in failed.'),
          ),
        );
      }
    } catch (e) {
      print('Error signing in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in. Please check your credentials.'),
        ),
      );
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  // void _savePeriod(String email) async {
  //   if (_selectedDay != null) {
  //     // String periodType = selectedBlock;
  //     DateTime selectedDate = _selectedDay!;

  //     try {
  //       // await FirebaseFirestore.instance.collection('users').add({
  //       //   'date': Timestamp.fromDate(selectedDate),
  //       //   'periodType': periodType,
  //       // });
  //       // DocumentReference userDoc = FirebaseFirestore.instance
  //       // .collection('users')
  //       // .doc('mmm.abhishek104@gmail.com');
  //       DocumentReference userDoc =
  //           FirebaseFirestore.instance.collection('users').doc(email);

  //       // Add the selected date and period type to the markedDates array in Firestore
  //       // await userDoc.update({
  //       //   'markedDates': FieldValue.arrayUnion([
  //       //     {'date': Timestamp.fromDate(selectedDate)}
  //       //   ])
  //       // });
  //       await userDoc.update({
  //         'markedDates':
  //             FieldValue.arrayUnion([Timestamp.fromDate(selectedDate)])
  //       });

  //       // Successfully saved, navigate to home page
  //       Navigator.of(context)
  //           .pop(); // This will pop the current screen and go back to the previous one
  //       print('Period saved successfully.');
  //     } catch (e) {
  //       print('Error saving period: $e');
  //     }
  //   } else {
  //     // No block selected, show a message or perform a screen shake
  //     // You can use a Flutter package like 'shake' for screen shake effect
  //     // or show a Snackbar or Dialog with an appropriate message
  //     // if (selectedBlock.isEmpty) {
  //     //   final snackBar = SnackBar(
  //     //     content: Text('Please select a period type before saving.'),
  //     //   );
  //     //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     // }
  //   }
  // }
}
