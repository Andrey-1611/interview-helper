import 'package:interview_master/features/auth/domain/repositories/auth_repository.dart';
import '../../data/models/my_user.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  Future<MyUser> call(MyUser user, String password) async {
    final myUser = await _authRepository.signUp(user, password);
    await _authRepository.sendEmailVerification();
    return myUser;
  }
}
