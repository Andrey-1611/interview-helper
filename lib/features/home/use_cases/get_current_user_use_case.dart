import 'package:injectable/injectable.dart';
import 'package:interview_master/core/utils/network_info.dart';
import '../../../data/models/user/user_data.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';

@injectable
class GetCurrentUserUseCase {
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;

  GetCurrentUserUseCase(
    this._remoteRepository,
    this._localRepository,
    this._networkInfo,
  );

  Future<UserData?> call() async {
    final user = await _localRepository.getUser();
    if (user != null) {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) return user;
      final interviews = await _localRepository.showInterviews();
      await _remoteRepository.updateInterviews(user.id, interviews);
      return user;
    }
    return null;
  }
}
