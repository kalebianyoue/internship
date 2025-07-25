import 'package:flutter/material.dart';
import 'package:untitled/home.dart';
class Signin extends StatelessWidget {
  const Signin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,

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
                      color: Colors.white,
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
                        borderRadius: BorderRadius.circular(20),
                      )
                    ),
                  ),
                  SizedBox(height: 16,),

                    TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_month_outlined),
                        hintText: "Enter your date of birth",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                  ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        hintText: "Enter your Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        hintText: "Enter your Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.local_activity),
                        hintText: "Enter your City",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Password ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Confirm Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                  ),
                  SizedBox(height: 16,),
                  SizedBox(

                    width: double.infinity,
                    child: ElevatedButton(onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> Home())
                      );
                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[100],
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
                  SizedBox(height: 16,),
                  Row(
                    children: [
                      Expanded(child: Divider(thickness: 2)),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Sign In with"),
                      ),
                      Expanded(child: Divider(thickness: 2)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.blue[200],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
