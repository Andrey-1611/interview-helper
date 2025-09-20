import '../models/interview/question.dart';
import '../models/interview/user_input.dart';

abstract interface class AIRepository {
  Future<List<Question>> checkAnswers(List<UserInput> userInputs);
}