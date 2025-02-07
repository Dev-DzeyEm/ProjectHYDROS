import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Add the flutter_spinkit package to pubspec.yaml

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'HYDROS x ATLANTIS',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Welcome to Project HYDROS: ',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
  onPressed: () {
    // Add your action here, like navigating
    Navigator.pop(context);
    Navigator.pushNamed(context, '/home');
  },
  style: ElevatedButton.styleFrom(
  backgroundColor: Colors.blueAccent,
  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
  foregroundColor: Colors.white, // This sets the text color
  textStyle: TextStyle(fontSize: 18), // Set only the font size here
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
  ),
),

  child: Text('View Dashboard'),
),

            SizedBox(height: 40),
            SpinKitFadingCircle(
              color: Colors.blueAccent,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
