import 'package:flutter/material.dart';
import 'package:untitled/main_buttons/homepage.dart';

void main() => runApp(Start());

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}
  class _SplashScreen extends State<SplashScreen> {
    @override
    void initState() {
      super.initState();
      Future.delayed(Duration(seconds: 3),() {
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
      );
      });
    }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text("On Work Quoi",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 40,
        ),
        ),

      )
    );
  }
}
