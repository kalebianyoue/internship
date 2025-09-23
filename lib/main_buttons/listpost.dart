import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Listpost extends StatefulWidget {
  final String JobId;
  const Listpost({super.key, required this.JobId});

  @override
  State<Listpost> createState() => _ListpostState();
}


class _ListpostState extends State<Listpost> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<List<Map<String, dynamic>>> _getAcceptedUsers() async {
    try {
      // Récupérer le job correspondant
      DocumentSnapshot jobDoc = await FirebaseFirestore.instance
          .collection('jobs')
          .doc(widget.JobId)
          .get();

      if (!jobDoc.exists) {
        return [];
      }

      // Récupérer la liste des IDs (AcceptList)
      List<dynamic> acceptList = jobDoc['AcceptList'] ?? [];

      if (acceptList.isEmpty) return [];

      // Charger les users dont l'ID est dans acceptList
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('provider')
          .where(FieldPath.documentId, whereIn: acceptList)
          .get();

      // Transformer en liste exploitable
      return usersSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // 👈 Ajoute l’ID du document
        return data;
      }).toList();
    } catch (e) {
      print("Erreur: $e");
      return [];
    }
  }

  void _acceptBooking(String bookingId, String providerId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      // Récupérer les infos du provider connecté
      final providerDoc =
      await _firestore.collection('provider').doc(providerId).get();

      if (!providerDoc.exists) {
        throw Exception("Provider introuvable !");
      }

      final providerData = providerDoc.data() as Map<String, dynamic>;
      final providerName = providerData['name'] ?? "Inconnu";

      // Mettre à jour le job
      await _firestore.collection('jobs').doc(bookingId).update({
        'status': 'accepted',
        'acceptedBy': providerId,         // ID du provider qui accepte
        'acceptedByName': providerName,   // Nom du provider
        'acceptedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Créer une notification pour le client
      await _firestore.collection('notifications').add({
        'userId': providerId, // ⚠️ ici tu dois mettre l'ID du client, pas le provider si c'est pour le client
        'title': 'Job Accepted',
        'message': '$providerName a accepté votre demande',
        'type': 'job_accepted',
        'jobId': bookingId,
        'providerId': providerId,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vous avez accepté ce job. Le client a été notifié.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec lors de l’acceptation du job : $error'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Accept List"),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
            future: _getAcceptedUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("Aucun utilisateur accepté"));
              }

              final users = snapshot.data!;

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final userId = user['id']; // 👉 Ici tu récupères l'ID du user

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user['photoUrl'] != null
                          ? NetworkImage(user['photoUrl'])
                          : null,
                      child: user['photoUrl'] == null
                          ? Icon(Icons.person)
                          : null,
                    ),
                    title: Text(user['name'] ?? "Nom inconnu"),
                    subtitle: Text("${user['email'] ?? ""}\nID: $userId"),
                    trailing: Wrap(
                      spacing: 10,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _acceptBooking(widget.JobId, userId);
                          },
                          child: Icon(Icons.check, color: Colors.green),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Icon(Icons.not_interested, color: Colors.red),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
        )
    );
  }
}