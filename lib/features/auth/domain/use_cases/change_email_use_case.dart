import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import '../../../../core/errors/exceptions.dart';
import '../../data/models/my_user.dart';

class ChangeEmailUseCase {
  final AuthRepository _authRepository;
  final NetworkInfo _networkInfo;

  ChangeEmailUseCase(this._authRepository, this._networkInfo);

  Future<void> call(String email, String password) async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) throw NetworkException();
    final user = await _authRepository.getUser();
    await _authRepository.deleteAccount();
    await _authRepository.signUp(
      MyUser(email: email, name: user!.name),
      password,
    );
    await _authRepository.sendEmailVerification();
  }
}
