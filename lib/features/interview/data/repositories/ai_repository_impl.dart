import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/data/models/user_input.dart';
import 'package:interview_master/features/interview/domain/repositories/ai_repository.dart';
import '../data_sources/gemini_data_source.dart';

class AIRepositoryImpl implements AIRepository {
  final GeminiDataSource _geminiDataSource;

  AIRepositoryImpl(this._geminiDataSource);

  @override
  Future<List<Question>> checkAnswers(List<UserInput> userInputs) async {
    return await _geminiDataSource.checkAnswers(userInputs);
  }
}