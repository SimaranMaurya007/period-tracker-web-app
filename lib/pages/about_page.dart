import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is the About Page'),
            SizedBox(height: 20),
            Text('Counter: $counter'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  counter++;
                });
              },
              child: Text('Increment Counter'),
            ),
          ],
        ),
      ),
    );
  }
}
