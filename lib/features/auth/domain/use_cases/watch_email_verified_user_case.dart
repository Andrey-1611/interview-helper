import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';
import 'package:interview_master/features/interview/domain/repositories/remote_repository.dart';
import '../../../../core/errors/exceptions.dart';
import '../../data/models/my_user.dart';
import '../../../../app/global/models/user_data.dart';

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
    final result = await _authRepository.watchEmailVerified();
    final user = result?.user;
    await _remoteRepository.saveUser(UserData.fromMyUser(user!));
    final userData = await _remoteRepository.getUserData(user.id!);
    await _localRepository.loadUser(userData);
    return user;
  }
}
