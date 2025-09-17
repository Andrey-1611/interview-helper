import 'package:injectable/injectable.dart';
import 'package:interview_master/core/errors/exceptions.dart';
import 'package:interview_master/core/utils/network_info.dart';
import '../../../../../data/models/my_user.dart';
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

  Future<MyUser?> call(MyUser user, String password) async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();
    final newUser = await _authRepository.signIn(user, password);
    final emailVerified = await _authRepository.checkEmailVerified();
    if (emailVerified) {
      final userData = await _remoteRepository.getUserData(newUser.id!);
      final interviews = await _remoteRepository.showInterviews(newUser.id!);
      await _localRepository.loadInterviews(interviews);
      await _localRepository.loadUser(userData);
      return newUser;
    }
    await _authRepository.sendEmailVerification();
    return null;
  }
}
