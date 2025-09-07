import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/interview/data/models/interview_info.dart';
import 'package:interview_master/features/interview/domain/repositories/ai_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';
import '../../../../core/errors/exceptions.dart';
import '../../data/models/interview.dart';
import '../repositories/remote_repository.dart';

class CheckResultsUseCase {
  final AIRepository _aiRepository;
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;

  CheckResultsUseCase(
    this._aiRepository,
    this._remoteRepository,
    this._localRepository,
    this._networkInfo,
  );

  Future<Interview> call(InterviewInfo info) async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();
    final questions = await _aiRepository.checkAnswers(info.userInputs!);
    final interview = Interview.fromQuestions(questions, info);

    final user = await _localRepository.getUser();
    await _remoteRepository.addInterview(interview, user!.id);
    await _localRepository.addInterview(interview);

    return interview;
  }
}
