import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/data/models/user_input.dart';
import 'package:interview_master/features/interview/domain/repositories/ai_repository.dart';
import '../data_sources/chat_gpt_data_source.dart';

class AIRepositoryImpl implements AIRepository {
  final ChatGPTDataSource _chatGPTDataSource;

  AIRepositoryImpl(this._chatGPTDataSource);

  @override
  Future<List<Question>> checkAnswers(List<UserInput> userInputs) async {
    return await _chatGPTDataSource.checkAnswers(userInputs);
  }
}