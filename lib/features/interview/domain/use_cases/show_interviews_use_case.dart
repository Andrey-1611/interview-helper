import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';

class ShowInterviewsUseCase {
  final RemoteRepository _remoteRepository;

  ShowInterviewsUseCase(this._remoteRepository);

  Future<List<Interview>> call(String userId) async {
    return await _remoteRepository.showInterviews(userId);
  }
}