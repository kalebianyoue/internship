import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverName;
  const ChatPage({super.key, required this.receiverName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();

  // Example local messages
  List<Map<String, dynamic>> messages = [
    {"text": "Hi there!", "isMe": true, "time": "10:20 AM"},
    {"text": "Hello 👋", "isMe": false, "time": "10:21 AM"},
  ];

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        "text": messageController.text.trim(),
        "isMe": true,
        "time": TimeOfDay.now().format(context),
      });
    });

    messageController.clear();

    // Simulate reply
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        messages.add({
          "text": "Got it 👍",
          "isMe": false,
          "time": TimeOfDay.now().format(context),
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment:
                  msg["isMe"] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: msg["isMe"] ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: msg["isMe"]
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg["text"],
                          style: TextStyle(
                            color: msg["isMe"] ? Colors.white : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg["time"],
                          style: TextStyle(
                            fontSize: 11,
                            color: msg["isMe"] ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}