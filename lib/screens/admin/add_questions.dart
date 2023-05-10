import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/answer.dart';
import '../../models/question.dart';
import '../../models/questionnaire.dart';

class QuestionnaireScreen extends StatefulWidget {
  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _questionsController = <TextEditingController>[];
  final _answersController = <List<AnswerController>>[];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questionnaire'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Questionnaire Name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name for the questionnaire.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _questionsController.length,
              itemBuilder: (context, questionIndex) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _questionsController[questionIndex],
                    decoration: InputDecoration(
                      labelText: 'Question ${questionIndex + 1}',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            _questionsController.removeAt(questionIndex);
                          });
                        },
                      ),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _answersController[questionIndex]
                                .add(AnswerController());
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a question.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _answersController[questionIndex].length,
                    itemBuilder: (context, answerIndex) => Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _answersController[questionIndex]
                                    [answerIndex]
                                .textController,
                            decoration: InputDecoration(
                              labelText: 'Answer ${answerIndex + 1}',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an answer.';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        SizedBox(
                          width: 100.0,
                          child: TextFormField(
                            controller: _answersController[questionIndex]
                                    [answerIndex]
                                .scoreController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Score',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a score.';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid integer score.';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // _answersController[questionIndex]
                              //     .add(AnswerController());
                              _answersController[questionIndex]
                                  .removeAt(answerIndex);
                            });
                          },
                          child: const Icon(Icons.remove),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _questionsController.add(TextEditingController());
                  _answersController.add(List<AnswerController>.generate(
                      4, (index) => AnswerController(),
                      growable: true));
                });
              },
              child: Text('Add Question'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
// Upload the questionnaire to Firebase
                  _uploadQuestionnaire();
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _uploadQuestionnaire() async {
    final questions = _questionsController
        .map((controller) => Question(
              text: controller.text,
              answers: _answersController[
                      _questionsController.indexOf(controller)]
                  .map((answerController) => Answer(
                        text: answerController.textController.text,
                        score: int.parse(answerController.scoreController.text),
                      ))
                  .toList(),
            ))
        .toList();

    final questionnaire = Questionnaire(
      name: _nameController.text,
      questions: questions,
    );

    try {
      // upload questionnaire to Firebase
      await FirebaseFirestore.instance.collection('questionnaires').add({
        'name': questionnaire.name,
        'questions': questions
            .map((question) => {
                  'text': question.text,
                  'answers': question.answers
                      .map((answer) => {
                            'text': answer.text,
                            'score': answer.score,
                          })
                      .toList(),
                })
            .toList(),
      });
      // show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Questionnaire uploaded successfully'),
        ),
      );
    } catch (e) {
      // show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload questionnaire'),
        ),
      );
    }
  }
}

class AnswerController {
  final TextEditingController textController = TextEditingController();
  final TextEditingController scoreController = TextEditingController();
}
