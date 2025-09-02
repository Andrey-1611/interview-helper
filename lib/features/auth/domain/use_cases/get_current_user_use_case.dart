import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';

import '../../data/models/my_user.dart';

class GetCurrentUserUseCase {
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;

  GetCurrentUserUseCase(this._remoteRepository, this._localRepository);

  Future<MyUser?> call() async {
    final user = await _localRepository.getUser();
    if (user != null) {
      final interviews = await _remoteRepository.showInterviews(user.id!);
      _localRepository.loadInterviews(interviews);
      return user;
    }
    return null;
  }
}
