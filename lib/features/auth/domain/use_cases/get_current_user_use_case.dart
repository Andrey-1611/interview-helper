import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';

import '../../data/models/my_user.dart';

class GetCurrentUserUseCase {
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;

  GetCurrentUserUseCase(
    this._remoteRepository,
    this._localRepository,
    this._networkInfo,
  );

  Future<MyUser?> call() async {
    final user = await _localRepository.getUser();
    if (user != null) {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return user;
      final interviews = await _remoteRepository.showInterviews(user.id!);
      _localRepository.loadInterviews(interviews);
      return user;
    }
    return null;
  }
}
