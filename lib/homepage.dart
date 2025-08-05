import 'package:flutter/material.dart';
import 'package:untitled/signin.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('On work Quoi',
          style: TextStyle(
              fontFamily: 'Gothic',
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white

          ),),
      ),
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 20),
              Column(
                children: [

                  SizedBox(height: 40),
                  Image.asset('assets/images/work-removebg-preview.png',
                    height: 320,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Welcome!',
                      style: TextStyle(
                        fontFamily: 'Gothic',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blue,

                      ),
                    ),
                    SizedBox(height: 16,),

                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Signin()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 16)
                        ),
                        child: Text('Get Started',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        )

                    ),

                  ],
                ),
              )
            ],
          )

      ),
    );
  }
}

