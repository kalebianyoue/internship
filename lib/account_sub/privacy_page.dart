import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blue,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            """Our Privacy Policy explains how we collect, use, and protect your information. 
            
- We collect only necessary data for account and service functionality.
- Your information is encrypted and secure.
- You can request deletion of your account and data anytime.
            
We respect your privacy and are committed to keeping your data safe.""",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}