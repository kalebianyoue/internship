import 'package:flutter/material.dart';
import 'package:untitled/home.dart';
class Signin extends StatelessWidget {

  const Signin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(30),
            child: Form(
              child: Column(
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_circle),
                      hintText: "Enter your Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                  ),
                  SizedBox(height: 16,),

                    TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_month_outlined),
                        hintText: "Enter your date of birth",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                  ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        hintText: "Enter your Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        hintText: "Enter your Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.local_activity),
                        hintText: "Enter your City",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Password ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Confirm Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),


                  SizedBox(height: 16,),
                  SizedBox(height: 16,),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("By continuing you accept the terms of services"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(

                    width: double.infinity,
                    child: ElevatedButton(onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> Home())
                      );
                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 14,),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(21),
                        )

                      ),
                        child: Text(
                        "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    ),
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
