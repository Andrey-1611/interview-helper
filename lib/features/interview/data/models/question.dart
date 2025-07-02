class Question {
  final double score;
  final String question;
  final String userAnswer;
  final String correctAnswer;

  Question({
    required this.score,
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
        score: map['score'] as double,
        question: map['question'] as String,
        userAnswer: map['userAnswer'] as String,
        correctAnswer: map['correctAnswer'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'question': question,
      'userAnswer': userAnswer,
      'correctAnswer': correctAnswer,
    };
  }
}
