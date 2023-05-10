import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/answer.dart';
import '../../models/question.dart';
import '../../models/questionnaire.dart';

class SelectQuestionnaireScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Questionnaire'),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('questionnaires').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final questionnaires = snapshot.data!.docs
              .map((doc) => Questionnaire.fromJson(doc.data()))
              .toList();
          return ListView.builder(
            itemCount: questionnaires.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(questionnaires[index].name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionnaireScreen(
                        questionnaire: questionnaires[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class QuestionnaireScreen extends StatefulWidget {
  final Questionnaire questionnaire;

  const QuestionnaireScreen({required this.questionnaire});

  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final _formKey = GlobalKey<FormState>();
  final _answerControllers = <int, int>{};
  int _totalScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.questionnaire.name),
      ),
      body: Form(
        key: _formKey,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: widget.questionnaire.questions.length,
          itemBuilder: (context, questionIndex) {
            final question = widget.questionnaire.questions[questionIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.text,
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                Column(
                  children: question.answers.map((answer) {
                    final answerIndex = question.answers.indexOf(answer);
                    return RadioListTile(
                      title: Text(answer.text),
                      value: answerIndex,
                      groupValue: _answerControllers[questionIndex],
                      onChanged: (value) {
                        setState(() {
                          _answerControllers[questionIndex] = value!;
                          _calculateTotalScore();
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Total Score: $_totalScore',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _calculateTotalScore() {
    int totalScore = 0;
    for (final entry in _answerControllers.entries) {
      final questionIndex = entry.key;
      final answerIndex = entry.value;
      final answer =
          widget.questionnaire.questions[questionIndex].answers[answerIndex];
      totalScore += answer.score;
    }
    setState(() {
      _totalScore = totalScore;
    });
  }
}
