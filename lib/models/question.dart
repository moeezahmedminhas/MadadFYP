import './answer.dart';

class Question {
  final String text;
  final List<Answer> answers;

  Question({required this.text, required this.answers});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['text'],
      answers:
          List<Answer>.from(json['answers'].map((x) => Answer.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'answers': List<dynamic>.from(answers.map((x) => x.toJson())),
    };
  }
}
