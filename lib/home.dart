import 'package:flutter/material.dart';
import 'package:untitled/main_buttons/account.dart';
import 'package:untitled/main_buttons/homepage.dart';
import 'package:untitled/login.dart';
import 'package:untitled/main_buttons/chat_list.dart';
import 'package:untitled/main_buttons/request.dart';
import 'package:untitled/main_buttons/account.dart';
import 'package:untitled/services_detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  List pages = [
    Login(),
    Request(),
    ChatList(),
    Account(userData: {},),
  ];


  void changepage(int index){
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: changepage,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),
                label:"Home"
            ),
            BottomNavigationBarItem(icon: Icon(Icons.notification_add),
                label: "request"
            ),
             BottomNavigationBarItem(icon: Icon(Icons.message),
                  label: "messages"
             ),
             BottomNavigationBarItem(icon: Icon(Icons.account_circle),
                label: "account"
             ),
          ]
    ),
    );
  }
}


