import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Services", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blue,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            """These are the Terms & Services of our application. 
            
By using this app, you agree to follow the rules and guidelines set forth. 
- You must not misuse the platform.
- You must provide accurate information.
- We reserve the right to suspend accounts violating our policy.
            
For full details, please contact support.""",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}