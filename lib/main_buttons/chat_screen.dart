import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String? currentUserId;
  final String? currentUserName;
  final String? jobId; // For job-specific chats
  final String? recipientId; // For direct messaging

  const ChatScreen({
    Key? key,
    this.currentUserId,
    this.currentUserName,
    this.jobId,
    this.recipientId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late DatabaseReference dbRef;
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  // Generate user info if not provided
  late String userId;
  late String userName;

  @override
  void initState() {
    super.initState();

    // Use provided user info or generate temporary ones
    userId = widget.currentUserId ?? "user_${DateTime.now().millisecondsSinceEpoch}";
    userName = widget.currentUserName ?? "User${DateTime.now().millisecondsSinceEpoch % 1000}";

    // Set up database reference based on chat type
    if (widget.jobId != null) {
      // Job-specific chat
      dbRef = FirebaseDatabase.instance.ref("job_chats/${widget.jobId}/messages");
    } else if (widget.recipientId != null) {
      // Direct message chat - create a consistent chat ID for the pair
      final chatId = _generateChatId(userId, widget.recipientId!);
      dbRef = FirebaseDatabase.instance.ref("direct_chats/$chatId/messages");
    } else {
      // General chat
      dbRef = FirebaseDatabase.instance.ref("general_chats/messages");
    }

    // Scroll to bottom when keyboard appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  // Generate a consistent chat ID for two users
  String _generateChatId(String user1, String user2) {
    final ids = [user1, user2]..sort();
    return "${ids[0]}_${ids[1]}";
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final messageText = _messageController.text.trim();

      dbRef.push().set({
        "text": messageText,
        "senderId": userId,
        "senderName": userName,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "type": "text", // Can be extended for images, files, etc.
      }).then((_) {
        _messageController.clear();
        _scrollToBottom();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send message: $error")),
        );
      });
    }
  }

  Widget _buildMessageBubble(Map<dynamic, dynamic> message, bool isOwnMessage) {
    final timestamp = message["timestamp"] as int?;
    final timeString = timestamp != null
        ? DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(timestamp))
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isOwnMessage)
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                message["senderName"]?.toString().substring(0, 1).toUpperCase() ?? 'U',
                style: TextStyle(color: Colors.white),
              ),
              radius: 16,
            ),
          if (!isOwnMessage) SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: isOwnMessage ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: isOwnMessage ? Radius.circular(16) : Radius.circular(4),
                  bottomRight: isOwnMessage ? Radius.circular(4) : Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isOwnMessage)
                    Text(
                      message["senderName"]?.toString() ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isOwnMessage ? Colors.white70 : Colors.blueGrey,
                      ),
                    ),
                  if (!isOwnMessage) SizedBox(height: 4),
                  Text(
                    message["text"]?.toString() ?? '',
                    style: TextStyle(
                      color: isOwnMessage ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    timeString,
                    style: TextStyle(
                      fontSize: 10,
                      color: isOwnMessage ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isOwnMessage) SizedBox(width: 8),
          if (isOwnMessage)
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                userName.substring(0, 1).toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
              radius: 16,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jobId != null
            ? "Job Discussion"
            : widget.recipientId != null
            ? "Direct Message"
            : "Professional Chat"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Chat Info"),
                  content: Text("User: $userName\nID: $userId"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: dbRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error loading messages"));
                }

                if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return Center(
                    child: Text(
                      "No messages yet\nStart the conversation!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                final messages = data.entries.map((entry) {
                  return {
                    'key': entry.key,
                    ...(entry.value as Map<dynamic, dynamic>),
                  };
                }).toList();

                // Sort messages by timestamp
                messages.sort((a, b) {
                  final aTime = a["timestamp"] as int? ?? 0;
                  final bTime = b["timestamp"] as int? ?? 0;
                  return aTime.compareTo(bTime);
                });

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.only(bottom: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isOwnMessage = message["senderId"] == userId;

                    return _buildMessageBubble(message, isOwnMessage);
                  },
                );
              },
            ),
          ),

          // Input area
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _messageFocusNode,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}