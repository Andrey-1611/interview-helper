
import 'package:interview_master/features/interview/data/models/user_input.dart';

class GeminiResponses {
  final UserInput userInput;
  final double score;
  final String correctAnswer;

  GeminiResponses({
    required this.userInput,
    required this.score,
    required this.correctAnswer,
  });

  factory GeminiResponses.fromMap(Map<String, dynamic> map) {
    return GeminiResponses(
      userInput: UserInput(
        question: map['question'] as String,
        answer: map['user_answer'] as String ,
      ),
      score: map['score'] as double,
      correctAnswer: map['correct_answer'] as String,
    );
  }
}
