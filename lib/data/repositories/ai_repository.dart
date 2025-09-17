import '../../data/models/question.dart';
import '../../data/models/user_input.dart';

abstract interface class AIRepository {
  Future<List<Question>> checkAnswers(List<UserInput> userInputs);
}