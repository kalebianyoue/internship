import 'package:flutter/material.dart';
import 'package:untitled/home.dart';
import 'package:untitled/main_buttons/homepage.dart';
import 'package:untitled/start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage()

    );
  }
}
