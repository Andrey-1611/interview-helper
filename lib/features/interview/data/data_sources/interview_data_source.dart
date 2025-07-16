import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:interview_master/features/interview/data/repositories/interview_repository.dart';

import '../models/gemini_response.dart';
import '../models/question.dart';

class InterviewDataSource implements InterviewRepository {
  final List<GeminiResponses> remoteDataSource;
  final int difficulty;

  InterviewDataSource({required this.difficulty, required this.remoteDataSource});

  int _calculateAverageScore() {
    final totalScore = remoteDataSource
        .map((response) => response.score)
        .reduce((score1, score2) => score1 + score2)
        .toInt();
    return totalScore ~/ remoteDataSource.length;
  }

  @override
  Interview createInterview() {
    final List<Question> questions = remoteDataSource
        .map(
          (response) => Question(
            score: response.score,
            question: response.userInput.question,
            userAnswer: response.userInput.answer,
            correctAnswer: response.correctAnswer,
          ),
        )
        .toList();
    final Interview interview = Interview(
      score: _calculateAverageScore().toDouble(),
      difficulty: difficulty,
      date: DateTime.now(),
      questions: questions,
    );
    return interview;
  }
}
