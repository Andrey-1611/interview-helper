import 'package:injectable/injectable.dart';
import 'package:interview_master/core/errors/exceptions.dart';
import 'package:interview_master/core/utils/network_info.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';

@injectable
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

  Future<void> call(String email, String password) async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();
    final userId = await _authRepository.signIn(email, password);
    final emailVerified = await _authRepository.checkEmailVerified();
    if (!emailVerified) {
      await _authRepository.sendEmailVerification();
      throw EmailVerifiedException();
    }
    final user = await _remoteRepository.getUserData(userId);
    final interviews = await _remoteRepository.showInterviews(userId);
    await _localRepository.loadInterviews(interviews);
    await _localRepository.loadUser(user);
  }
}
