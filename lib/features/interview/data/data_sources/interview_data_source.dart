import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:interview_master/features/interview/data/repositories/interview_repository.dart';
import '../models/gemini_response.dart';
import '../models/question.dart';

class InterviewDataSource implements InterviewRepository {

  int _calculateAverageScore(List<GeminiResponses> remoteDataSource) {
    final totalScore = remoteDataSource
        .map((response) => response.score)
        .reduce((score1, score2) => score1 + score2)
        .toInt();
    return totalScore ~/ remoteDataSource.length;
  }

  @override
  Interview createInterview(List<GeminiResponses> remoteDataSource, int difficulty) {
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
      score: _calculateAverageScore(remoteDataSource).toDouble(),
      difficulty: difficulty,
      date: DateTime.now(),
      questions: questions,
    );
    return interview;
  }
}
