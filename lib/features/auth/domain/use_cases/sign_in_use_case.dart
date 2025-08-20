import '../../data/models/my_user.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<MyUser?> call(MyUser user, String password) async {
    await _authRepository.signIn(user, password);
    final result = await _authRepository.checkEmailVerified();
    if (result!.isEmailVerified) return result.user;
    await _authRepository.sendEmailVerification();
    return null;
  }
}

