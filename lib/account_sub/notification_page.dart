import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool pushEnabled = true;
  bool emailEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications",style: TextStyle(color: Colors.white),), backgroundColor: Colors.blue),
      body: ListView(
        children: [
          SwitchListTile(
            value: pushEnabled,
            onChanged: (val) => setState(() => pushEnabled = val),
            title: const Text("Push Notifications"),
          ),
          SwitchListTile(
            value: emailEnabled,
            onChanged: (val) => setState(() => emailEnabled = val),
            title: const Text("Email Notifications"),
          ),
        ],
      ),
    );
  }
}