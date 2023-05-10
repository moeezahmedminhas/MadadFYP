import './question.dart';

class Questionnaire {
  final String name;
  final List<Question> questions;

  Questionnaire({required this.name, required this.questions});

  factory Questionnaire.fromJson(Map<String, dynamic> json) {
    return Questionnaire(
      name: json['name'],
      questions: List<Question>.from(
          json['questions'].map((x) => Question.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'questions': List<dynamic>.from(questions.map((x) => x.toJson())),
    };
  }
}
