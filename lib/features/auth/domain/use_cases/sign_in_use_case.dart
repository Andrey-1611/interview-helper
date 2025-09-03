import 'package:interview_master/core/errors/network_exception.dart';
import 'package:interview_master/core/utils/network_info.dart';
import '../../../interview/domain/repositories/local_repository.dart';
import '../../../interview/domain/repositories/remote_repository.dart';
import '../../data/models/my_user.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  final NetworkInfo _networkInfo;

  SignInUseCase(
    this._authRepository,
    this._remoteRepository,
    this._localRepository,
    this._networkInfo,
  );

  Future<MyUser?> call(MyUser user, String password) async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      throw NetworkException();
    }
    await _authRepository.signIn(user, password);
    final result = await _authRepository.checkEmailVerified();
    if (result!.isEmailVerified) {
      final user = result.user!;
      final interviews = await _remoteRepository.showInterviews(user.id!);
      await _localRepository.loadInterviews(interviews);
      await _localRepository.loadUser(user);
      return user;
    }
    await _authRepository.sendEmailVerification();
    return null;
  }
}
