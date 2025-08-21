import 'package:flutter/material.dart';
import 'chat_page.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> chats = [
      {"name": "Alice", "lastMessage": "Hey! How are you?", "time": "10:30 AM"},
      {"name": "Bob", "lastMessage": "See you tomorrow.", "time": "09:15 AM"},
      {"name": "Charlie", "lastMessage": "Let’s catch up soon!", "time": "Yesterday"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(chat["name"]![0]),
            ),
            title: Text(chat["name"]!),
            subtitle: Text(chat["lastMessage"]!),
            trailing: Text(
              chat["time"]!,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(receiverName: chat["name"]!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}