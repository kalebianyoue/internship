import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final dbRef = FirebaseDatabase.instance.ref("messages");
  final controller = TextEditingController();
  String username = "User${DateTime.now().millisecondsSinceEpoch % 1000}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Chat")),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: StreamBuilder(
              stream: dbRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    (snapshot.data! as DatabaseEvent).snapshot.value != null) {
                  final data = (snapshot.data! as DatabaseEvent).snapshot.value
                  as Map<dynamic, dynamic>;
                  final messages = data.values.toList();

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index] as Map;
                      return ListTile(
                        title: Text(msg["text"]),
                        subtitle: Text(msg["sender"]),
                      );
                    },
                  );
                }
                return Center(child: Text("No messages yet"));
              },
            ),
          ),
          // Input box
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: "Enter message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      dbRef.push().set({
                        "text": controller.text,
                        "sender": username,
                        "timestamp": DateTime.now().millisecondsSinceEpoch,
                      });
                      controller.clear();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
