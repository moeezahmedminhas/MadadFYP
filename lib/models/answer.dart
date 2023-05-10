class Answer {
  final String text;
  final int score;

  Answer({required this.text, required this.score});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      text: json['text'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'score': score,
    };
  }
}
