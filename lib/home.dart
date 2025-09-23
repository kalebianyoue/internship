import 'package:flutter/material.dart';
import 'package:untitled/main_buttons/account.dart';
import 'package:untitled/main_buttons/chat_screen.dart';
import 'package:untitled/main_buttons/homepage.dart';
import 'package:untitled/login.dart';
import 'package:untitled/main_buttons/chat_list.dart';
import 'package:untitled/main_buttons/request.dart';
import 'package:untitled/services_detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  final List<Widget> pages = [
    Login(),
    MainTabsScreen(),
    ChatList(),
    Account(userData: {}),
  ];

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher( // 👈 animation fluide quand on change d’onglet
        duration: const Duration(milliseconds: 300),
        child: pages[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex, // 👈 important pour que la sélection marche
        onTap: changePage,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue, // couleur onglet actif
        unselectedItemColor: Colors.grey, // couleur onglets inactifs
        showUnselectedLabels: true, // garder les labels visibles
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // 👈 icône différente quand actif
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: "Request",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
