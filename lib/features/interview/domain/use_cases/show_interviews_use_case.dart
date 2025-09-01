import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';

class ShowInterviewsUseCase {
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;

  ShowInterviewsUseCase(this._remoteRepository, this._localRepository);

  Future<List<Interview>> call(String? userId) async {
    return userId != null
        ? await _remoteRepository.showInterviews(userId)
        : await _localRepository.showInterviews();
  }
}
