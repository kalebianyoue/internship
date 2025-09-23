import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';

class ChatList extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;

  ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("Aucun utilisateur connecté")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Messages",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .where("participants", arrayContains: currentUser!.uid)
            .orderBy("lastMessageTime", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Aucun message"));
          }

          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chatDoc = chats[index];
              final chat = chatDoc.data() as Map<String, dynamic>?;

              if (chat == null || chat["participants"] == null) {
                return const SizedBox.shrink();
              }

              final participants = List<String>.from(chat["participants"]);
              final otherUserId =
              participants.firstWhere((id) => id != currentUser!.uid);

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("provider") // ⚠️ adapte si tu stockes aussi dans "providers"
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(title: Text("Chargement..."));
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return const ListTile(title: Text("Utilisateur introuvable"));
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>? ?? {};
                  final name = userData["name"] ?? "Unknown";

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(name.isNotEmpty ? name[0] : "?"),
                    ),
                    title: Text(name),
                    subtitle: Text(chat["lastMessage"] ?? ""),
                    trailing: Text(
                      chat["lastMessageTime"] != null
                          ? (chat["lastMessageTime"] as Timestamp)
                          .toDate()
                          .toLocal()
                          .toString()
                          .substring(11, 16) // HH:mm
                          : "",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatPage(
                            Name: name,
                            providerId: participants[0],
                            clientId: participants[1],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
