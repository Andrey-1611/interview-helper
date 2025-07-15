import '../models/gemini_response.dart';
import '../models/user_input.dart';

abstract interface class RemoteRepository {
  Future<List<GeminiResponses>> checkAnswers(List<UserInput> userInputs);
}