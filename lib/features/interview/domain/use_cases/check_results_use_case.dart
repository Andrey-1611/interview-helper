import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/interview/data/models/interview_info.dart';
import 'package:interview_master/features/interview/domain/repositories/ai_repository.dart';
import '../../data/models/interview.dart';
import '../repositories/remote_repository.dart';

class CheckResultsUseCase {
  final AIRepository _aiRepository;
  final AuthRepository _authRepository;
  final RemoteRepository _remoteRepository;

  CheckResultsUseCase(
    this._aiRepository,
    this._authRepository,
    this._remoteRepository,
  );

  Future<Interview> call(InterviewInfo info) async {
    final questions = await _aiRepository.checkAnswers(info.userInputs!);
    final interview = Interview.fromQuestions(questions, info);

    final user = await _authRepository.getUser();
    await _remoteRepository.addInterview(
      Interview.fromQuestions(questions, info),
      user!.id!,
    );

    return interview;
  }
}
