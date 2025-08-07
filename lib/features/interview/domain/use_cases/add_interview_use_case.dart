import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';

class AddInterviewUseCase {
  final RemoteRepository _remoteRepository;

  AddInterviewUseCase(this._remoteRepository);

  Future<void> call(Interview interview, String userId) async {
    await _remoteRepository.addInterview(interview, userId);
  }
}
