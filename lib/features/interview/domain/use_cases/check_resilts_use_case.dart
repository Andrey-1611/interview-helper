import 'package:interview_master/features/interview/data/models/question.dart';
import 'package:interview_master/features/interview/domain/repositories/ai_repository.dart';

import '../../data/models/user_input.dart';

class CheckResultsUseCase {
  final AIRepository _aiRepository;

  CheckResultsUseCase(this._aiRepository);

  Future<List<Question>> call(List<UserInput> userInputs) async {
    return await _aiRepository.checkAnswers(userInputs);
  }
}