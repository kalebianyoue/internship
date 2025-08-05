import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,

     body: ListView(
         children: [
     Container(
     margin: EdgeInsets.all(25),
      child: Form(
        child: Column(
          children: [
          Text(
          "Home",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
          SizedBox(height: 40),
         Container(
           padding: EdgeInsets.symmetric(horizontal: 12
           ),
           decoration: BoxDecoration(
             color:Colors.white,
             borderRadius: BorderRadius.circular(12),
           ),
           child: TextField(
             decoration: InputDecoration(
               icon: Icon(Icons.search),
               hintText: "Search Services"
             ),
           ),
         ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("For you"),
                Text("Domestic"),
                Text("Outdoor"),
                Text("Mechanics")
              ],
            ),
            SizedBox(height: 30 ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Most Wanted",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                )
              ],
            ),

          ],
     ),
    ),
    ),
    ],
    ),


    );
  }
}
