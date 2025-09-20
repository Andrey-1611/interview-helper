import 'package:injectable/injectable.dart';
import 'package:interview_master/core/utils/network_info.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../data/models/user/my_user.dart';
import '../../../data/models/user/user_data.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';

@injectable
class WatchEmailVerifiedUseCase {
  final AuthRepository _authRepository;
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;

  WatchEmailVerifiedUseCase(
    this._authRepository,
    this._remoteRepository,
    this._localRepository,
    this._networkInfo,
  );

  Future<MyUser> call() async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();
    await _authRepository.watchEmailVerified();
    final user = await _authRepository.getUser();
    await _remoteRepository.saveUser(UserData.fromMyUser(user!));
    final userData = await _remoteRepository.getUserData(user.id!);
    await _localRepository.loadUser(userData);
    return user;
  }
}
