import 'package:flutter/material.dart';

import '../../api/apis.dart';

class showQuestionaires extends StatefulWidget {
  const showQuestionaires({super.key});

  @override
  State<showQuestionaires> createState() => _showQuestionairesState();
}

class _showQuestionairesState extends State<showQuestionaires> {
  final list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: APIs.firestore.collection("questionaire").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data?.docs;
            for (var i in data!) {
              list.add(i.data()['questionaireName']);
            }
          }
          return ListView.builder(itemBuilder: (context, index) {
            return ListTile(
              title: list[index],
            );
          });
        },
      ),
    );
  }
}
