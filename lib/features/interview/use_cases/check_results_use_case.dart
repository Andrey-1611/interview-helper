import 'package:injectable/injectable.dart';
import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/core/utils/stopwatch_info.dart';
import '../../../core/errors/exceptions.dart';
import '../../../data/models/interview/interview_data.dart';
import '../../../data/models/interview/interview_info.dart';
import '../../../data/models/user/user_data.dart';
import '../../../data/repositories/ai_repository.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';

@injectable
class CheckResultsUseCase {
  final AIRepository _aiRepository;
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;
  final StopwatchInfo _stopwatchInfo;

  CheckResultsUseCase(
    this._aiRepository,
    this._remoteRepository,
    this._localRepository,
    this._networkInfo,
    this._stopwatchInfo,
  );

  Future<InterviewData> call(InterviewInfo interviewInfo) async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();

    final duration = _stopwatchInfo.stop();
    final questions = await _aiRepository.checkAnswers(interviewInfo);
    final interview = InterviewData.fromQuestions(
      questions,
      interviewInfo,
      duration,
    );

    final user = (await _localRepository.getUser())!;
    final updatedUser = UserData.updateData(user, interview);
    await _remoteRepository.addInterview(interview, updatedUser);
    await _localRepository.addInterview(interview, updatedUser);

    return interview;
  }
}
