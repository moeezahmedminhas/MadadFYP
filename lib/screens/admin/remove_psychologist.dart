import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Psychologists'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('profession', isEqualTo: 'psychologist')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final psychologists = snapshot.data!.docs;

          return ListView.builder(
            itemCount: psychologists.length,
            itemBuilder: (context, index) {
              final psychologist = psychologists[index];

              return ListTile(
                title: Text(psychologist['name']),
                subtitle: Text(psychologist['email']),
                trailing: ElevatedButton(
                  onPressed: () {
                    blockAccess(psychologist.id);
                  },
                  child: Text('Block Access'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> blockAccess(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'access': 'blocked'});
  }
}
